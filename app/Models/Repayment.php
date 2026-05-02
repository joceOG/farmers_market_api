<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Repayment extends Model
{
    protected $fillable = [
        'farmer_id',
        'operator_id',
        'kg_received',
        'commodity_rate',
        'fcfa_value',
    ];

    protected $casts = [
        'kg_received'    => 'decimal:3',
        'commodity_rate' => 'decimal:2',
        'fcfa_value'     => 'decimal:2',
    ];

    public function farmer(): BelongsTo
    {
        return $this->belongsTo(Farmer::class);
    }

    public function operator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'operator_id');
    }

    public function repaymentDebts(): HasMany
    {
        return $this->hasMany(RepaymentDebt::class);
    }

    public function debts()
    {
        return $this->hasManyThrough(Debt::class, RepaymentDebt::class, 'repayment_id', 'id', 'id', 'debt_id');
    }
}