<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Debt extends Model
{
    protected $fillable = [
        'transaction_id',
        'farmer_id',
        'original_amount',
        'remaining_amount',
        'status',
    ];

    protected $casts = [
        'original_amount'  => 'decimal:2',
        'remaining_amount' => 'decimal:2',
    ];

    public function transaction(): BelongsTo
    {
        return $this->belongsTo(Transaction::class);
    }

    public function farmer(): BelongsTo
    {
        return $this->belongsTo(Farmer::class);
    }

    public function repaymentDebts(): HasMany
    {
        return $this->hasMany(RepaymentDebt::class);
    }

    public function isPaid(): bool
    {
        return $this->status === 'paid';
    }

    public function isOpen(): bool
    {
        return in_array($this->status, ['open', 'partial']);
    }
}