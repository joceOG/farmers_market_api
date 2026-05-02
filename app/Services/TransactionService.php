<?php

namespace App\Services;

use App\Models\Debt;
use App\Models\Farmer;
use App\Models\Product;
use App\Models\Transaction;
use App\Models\TransactionItem;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class TransactionService
{
    /**
     * Crée une transaction avec ses items et gère la dette si crédit.
     */
    public function createTransaction(array $data, int $operatorId): Transaction
    {
        return DB::transaction(function () use ($data, $operatorId) {
            $farmer = Farmer::findOrFail($data['farmer_id']);

            // 1. Calculer le total FCFA
            $items        = $this->resolveItems($data['items']);
            $totalFcfa    = $items->sum('subtotal');

            // 2. Calculer le montant crédité si paiement à crédit
            $interestRate   = 0;
            $creditedAmount = null;

            if ($data['payment_method'] === 'credit') {
                $interestRate   = $data['interest_rate'];
                $creditedAmount = round($totalFcfa * (1 + $interestRate), 2);

                // 3. Vérifier la limite de crédit (FCFA debt actuel + nouveau crédit)
                $currentDebt = Debt::where('farmer_id', $farmer->id)
                    ->whereIn('status', ['open', 'partial'])
                    ->sum('remaining_amount');

                if (($currentDebt + $creditedAmount) > $farmer->credit_limit) {
                    throw ValidationException::withMessages([
                        'credit_limit' => "La limite de crédit du fermier serait dépassée. "
                            . "Dette actuelle: {$currentDebt} FCFA. "
                            . "Nouveau crédit: {$creditedAmount} FCFA. "
                            . "Limite: {$farmer->credit_limit} FCFA.",
                    ]);
                }
            }

            // 4. Créer la transaction
            $transaction = Transaction::create([
                'farmer_id'      => $farmer->id,
                'operator_id'    => $operatorId,
                'total_fcfa'     => $totalFcfa,
                'payment_method' => $data['payment_method'],
                'interest_rate'  => $interestRate,
                'credited_amount' => $creditedAmount,
            ]);

            // 5. Créer les items
            foreach ($items as $item) {
                TransactionItem::create([
                    'transaction_id' => $transaction->id,
                    'product_id'     => $item['product_id'],
                    'quantity'       => $item['quantity'],
                    'unit_price'     => $item['unit_price'],
                    'subtotal'       => $item['subtotal'],
                ]);
            }

            // 6. Créer la dette si crédit
            if ($data['payment_method'] === 'credit') {
                Debt::create([
                    'transaction_id'  => $transaction->id,
                    'farmer_id'       => $farmer->id,
                    'original_amount' => $creditedAmount,
                    'remaining_amount' => $creditedAmount,
                    'status'          => 'open',
                ]);
            }

            return $transaction->load(['items.product', 'farmer', 'operator', 'debt']);
        });
    }

    private function resolveItems(array $rawItems): \Illuminate\Support\Collection
    {
        $productIds = collect($rawItems)->pluck('product_id');
        $products   = Product::findMany($productIds)->keyBy('id');

        return collect($rawItems)->map(function ($item) use ($products) {
            $product  = $products->get($item['product_id']);
            $subtotal = round($product->price_fcfa * $item['quantity'], 2);

            return [
                'product_id' => $product->id,
                'quantity'   => $item['quantity'],
                'unit_price' => $product->price_fcfa,
                'subtotal'   => $subtotal,
            ];
        });
    }
}