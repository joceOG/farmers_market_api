<?php

namespace App\Services;

use App\Models\Debt;
use App\Models\Repayment;
use App\Models\RepaymentDebt;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class RepaymentService
{
    /**
     * Enregistre un remboursement et applique le FIFO sur les dettes.
     */
    public function recordRepayment(array $data, int $operatorId): Repayment
    {
        return DB::transaction(function () use ($data, $operatorId) {
            $fcfaValue = round($data['kg_received'] * $data['commodity_rate'], 2);

            // Vérifier qu'il y a des dettes ouvertes
            $openDebts = Debt::where('farmer_id', $data['farmer_id'])
                ->whereIn('status', ['open', 'partial'])
                ->orderBy('created_at', 'asc') // FIFO
                ->lockForUpdate()
                ->get();

            if ($openDebts->isEmpty()) {
                throw ValidationException::withMessages([
                    'farmer_id' => 'Ce fermier n\'a aucune dette ouverte.',
                ]);
            }

            // Créer le remboursement
            $repayment = Repayment::create([
                'farmer_id'      => $data['farmer_id'],
                'operator_id'    => $operatorId,
                'kg_received'    => $data['kg_received'],
                'commodity_rate' => $data['commodity_rate'],
                'fcfa_value'     => $fcfaValue,
            ]);

            // Appliquer FIFO
            $remaining = $fcfaValue;

            foreach ($openDebts as $debt) {
                if ($remaining <= 0) break;

                $applied = min($remaining, $debt->remaining_amount);

                RepaymentDebt::create([
                    'repayment_id'  => $repayment->id,
                    'debt_id'       => $debt->id,
                    'amount_applied' => $applied,
                ]);

                $debt->remaining_amount -= $applied;
                $debt->status = $debt->remaining_amount <= 0 ? 'paid' : 'partial';
                $debt->save();

                $remaining -= $applied;
            }

            return $repayment->load(['repaymentDebts.debt', 'farmer', 'operator']);
        });
    }
}