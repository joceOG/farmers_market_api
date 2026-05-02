<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreRepaymentRequest;
use App\Models\Farmer;
use App\Models\Repayment;
use App\Services\RepaymentService;
use Illuminate\Http\JsonResponse;

class RepaymentController extends Controller
{
    public function __construct(private RepaymentService $service) {}

    // GET /farmers/{farmer}/repayments
    public function index(Farmer $farmer): JsonResponse
    {
        $repayments = Repayment::where('farmer_id', $farmer->id)
            ->with(['operator', 'repaymentDebts.debt'])
            ->latest()
            ->get();

        return response()->json(['data' => $repayments]);
    }

    // POST /repayments
    public function store(StoreRepaymentRequest $request): JsonResponse
    {
        $repayment = $this->service->recordRepayment(
            $request->validated(),
            $request->user()->id
        );

        return response()->json(['data' => $repayment], 201);
    }

    // GET /repayments/{id}
    public function show(Repayment $repayment): JsonResponse
    {
        return response()->json([
            'data' => $repayment->load(['farmer', 'operator', 'repaymentDebts.debt.transaction']),
        ]);
    }
}