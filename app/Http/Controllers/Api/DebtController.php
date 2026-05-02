<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Debt;
use App\Models\Farmer;
use Illuminate\Http\JsonResponse;

class DebtController extends Controller
{
    // GET /farmers/{farmer}/debts
    public function index(Farmer $farmer): JsonResponse
    {
        $debts = Debt::where('farmer_id', $farmer->id)
            ->with('transaction')
            ->orderBy('created_at', 'asc')
            ->get();

        $totalOutstanding = $debts->whereIn('status', ['open', 'partial'])
            ->sum('remaining_amount');

        return response()->json([
            'data' => [
                'farmer'           => $farmer,
                'debts'            => $debts,
                'total_outstanding' => $totalOutstanding,
            ],
        ]);
    }

    // GET /debts/{id}
    public function show(Debt $debt): JsonResponse
    {
        return response()->json([
            'data' => $debt->load(['transaction.items.product', 'repaymentDebts.repayment']),
        ]);
    }
}