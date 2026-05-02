<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreRepaymentRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'farmer_id'      => 'required|exists:farmers,id',
            'kg_received'    => 'required|numeric|min:0.001',
            'commodity_rate' => 'required|numeric|min:1',
        ];
    }

    public function messages(): array
    {
        return [
            'kg_received.min'    => 'Le poids reçu doit être supérieur à 0.',
            'commodity_rate.min' => 'Le taux de la matière première doit être positif.',
        ];
    }
}