<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Debt;
use App\Models\Farmer;
use App\Models\Product;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // ─── Categories (racines) ────────────────────────────────────────
        $pesticides = Category::create(['name' => 'Pesticides']);
        $engrais    = Category::create(['name' => 'Engrais']);
        $semences   = Category::create(['name' => 'Semences']);
        $materiels  = Category::create(['name' => 'Matériels']);

        // ─── Sous-catégories Pesticides ──────────────────────────────────
        $herbicides   = Category::create(['name' => 'Herbicides',   'parent_id' => $pesticides->id]);
        $fongicides   = Category::create(['name' => 'Fongicides',   'parent_id' => $pesticides->id]);
        $insecticides = Category::create(['name' => 'Insecticides', 'parent_id' => $pesticides->id]);
        $hematicides  = Category::create(['name' => 'Hematicides',  'parent_id' => $pesticides->id]);

        // ─── Sous-catégories Engrais ─────────────────────────────────────
        $engraisOrga    = Category::create(['name' => 'Engrais Organiques',           'parent_id' => $engrais->id]);
        $npk            = Category::create(['name' => 'NPK (Nitrogène, Phosphore, Potasse)', 'parent_id' => $engrais->id]);
        $engraisChim    = Category::create(['name' => 'Engrais Chimiques',            'parent_id' => $engrais->id]);
        $engraisLiq     = Category::create(['name' => 'Engrais Liquides Foliaires',   'parent_id' => $engrais->id]);

        // ─── Sous-catégories Semences ────────────────────────────────────
        $semencesCacao  = Category::create(['name' => 'Semences de Cacao',   'parent_id' => $semences->id]);
        $semencesCafe   = Category::create(['name' => 'Semences de Café',    'parent_id' => $semences->id]);
        $semencesLeg    = Category::create(['name' => 'Semences Légumes',    'parent_id' => $semences->id]);
        $semencesCer    = Category::create(['name' => 'Semences Céréales',   'parent_id' => $semences->id]);
        $semencesOlea   = Category::create(['name' => 'Semences Oléagineux', 'parent_id' => $semences->id]);

        // ─── Sous-catégories Matériels ───────────────────────────────────
        $outils         = Category::create(['name' => 'Outils Agricoles',          'parent_id' => $materiels->id]);
        $irrigation     = Category::create(['name' => "Équipements d'Irrigation",  'parent_id' => $materiels->id]);
        $stockage       = Category::create(['name' => 'Équipements de Stockage',   'parent_id' => $materiels->id]);
        $motorise       = Category::create(['name' => 'Petit Matériel Motorisé',   'parent_id' => $materiels->id]);

        // ─── Products ────────────────────────────────────────────────────
        $products = [
            ['name' => 'Glyphosate 1L',               'price_fcfa' => 4500,  'category_id' => $herbicides->id],
            ['name' => 'Atrazine 500ml',               'price_fcfa' => 3200,  'category_id' => $herbicides->id],
            ['name' => 'Lambda-cyhalothrine',          'price_fcfa' => 5800,  'category_id' => $insecticides->id],
            ['name' => 'NPK 15-15-15 (50kg)',          'price_fcfa' => 18000, 'category_id' => $npk->id],
            ['name' => 'Urée 46% (50kg)',              'price_fcfa' => 15000, 'category_id' => $engraisChim->id],
            ['name' => 'Compost Premium (25kg)',       'price_fcfa' => 8000,  'category_id' => $engraisOrga->id],
            ['name' => 'Semences Maïs hybride (5kg)',  'price_fcfa' => 12000, 'category_id' => $semencesCer->id],
            ['name' => 'Semences Cacao Amelioré (1kg)','price_fcfa' => 9500,  'category_id' => $semencesCacao->id],
            ['name' => 'Pulvérisateur à dos 16L',      'price_fcfa' => 22000, 'category_id' => $motorise->id],
            ['name' => 'Kit goutte-à-goutte',          'price_fcfa' => 35000, 'category_id' => $irrigation->id],
        ];

        foreach ($products as $p) {
            Product::create(array_merge($p, ['description' => 'Produit de qualité certifiée.']));
        }

        // ─── Farmers ─────────────────────────────────────────────────────
        $farmer1 = Farmer::create([
            'identifier'   => 'CI-2024-001',
            'firstname'    => 'Kofi',
            'lastname'     => 'Asante',
            'phone'        => '+2250102030405',
            'credit_limit' => 200000,
        ]);

        $farmer2 = Farmer::create([
            'identifier'   => 'CI-2024-002',
            'firstname'    => 'Ama',
            'lastname'     => 'Diallo',
            'phone'        => '+2250607080910',
            'credit_limit' => 150000,
        ]);

        // ─── Transaction de démonstration (crédit) ───────────────────────
        $operator = User::where('role', 'operator')->first();

        if ($operator) {
            $product  = Product::first();
            $total    = 36000;
            $interest = 0.30;
            $credited = round($total * (1 + $interest), 2);

            $tx = Transaction::create([
                'farmer_id'       => $farmer1->id,
                'operator_id'     => $operator->id,
                'total_fcfa'      => $total,
                'payment_method'  => 'credit',
                'interest_rate'   => $interest,
                'credited_amount' => $credited,
            ]);

            TransactionItem::create([
                'transaction_id' => $tx->id,
                'product_id'     => $product->id,
                'quantity'       => 2,
                'unit_price'     => $product->price_fcfa,
                'subtotal'       => $product->price_fcfa * 2,
            ]);

            Debt::create([
                'transaction_id'   => $tx->id,
                'farmer_id'        => $farmer1->id,
                'original_amount'  => $credited,
                'remaining_amount' => $credited,
                'status'           => 'open',
            ]);
        }
    }
}