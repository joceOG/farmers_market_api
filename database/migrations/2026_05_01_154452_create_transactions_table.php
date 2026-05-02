<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('farmer_id')->constrained()->cascadeOnDelete();
            $table->foreignId('operator_id')->constrained('users')->cascadeOnDelete();
            $table->decimal('total_fcfa', 12, 2);
            $table->enum('payment_method', ['cash', 'credit']);
            $table->decimal('interest_rate', 5, 4)->default(0); // ex: 0.3000 = 30%
            $table->decimal('credited_amount', 12, 2)->nullable(); // total après intérêt
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};