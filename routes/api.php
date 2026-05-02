<?php

use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\DebtController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\RepaymentController;
use App\Http\Controllers\Api\TransactionController;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\FarmerController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// 🔓 Public
Route::post('/login', [AuthController::class, 'login']);

// 🔐 Protected
Route::middleware('auth:sanctum')->group(function () {

    // 👤 Current user
    Route::get('/me', function (Request $request) {
        return $request->user();
    });

    // 🔐 Logout
    Route::post('/logout', [AuthController::class, 'logout']);

    // 👥 Users
    Route::apiResource('users', UserController::class);

    // 🌱 Farmers
    Route::get('farmers/search', [FarmerController::class, 'search']);
    Route::apiResource('farmers', FarmerController::class);

    // ---------- Categories & Products (admin + supervisor) ----------
    Route::apiResource('categories', CategoryController::class);
    Route::apiResource('products', ProductController::class);

    // ---------- Transactions ----------
    Route::get('transactions', [TransactionController::class, 'index']);
    Route::get('transactions/{transaction}', [TransactionController::class, 'show']);
    Route::post('transactions', [TransactionController::class, 'store']);

    // ---------- Debts ----------
    Route::get('farmers/{farmer}/debts', [DebtController::class, 'index']);
    Route::get('debts/{debt}', [DebtController::class, 'show']);

    // ---------- Repayments ----------
    Route::get('farmers/{farmer}/repayments', [RepaymentController::class, 'index']);
    Route::post('repayments', [RepaymentController::class, 'store']);
    Route::get('repayments/{repayment}', [RepaymentController::class, 'show']);
});