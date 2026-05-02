<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreTransactionRequest;
use App\Models\Transaction;
use App\Services\TransactionService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function __construct(private TransactionService $service) {}

    // GET /transactions
    public function index(Request $request): JsonResponse
    {
        $query = Transaction::with(['farmer', 'operator', 'items.product']);

        if ($request->has('farmer_id')) {
            $query->where('farmer_id', $request->farmer_id);
        }

        return response()->json(['data' => $query->latest()->paginate(20)]);
    }

    // GET /transactions/{id}
    public function show(Transaction $transaction): JsonResponse
    {
        return response()->json([
            'data' => $transaction->load(['farmer', 'operator', 'items.product', 'debt']),
        ]);
    }

    // POST /transactions
    public function store(StoreTransactionRequest $request): JsonResponse
    {
        $transaction = $this->service->createTransaction(
            $request->validated(),
            $request->user()->id
        );

        return response()->json(['data' => $transaction], 201);
    }
}