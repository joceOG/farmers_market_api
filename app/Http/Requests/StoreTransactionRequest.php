<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreTransactionRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'farmer_id'          => 'required|exists:farmers,id',
            'payment_method'     => 'required|in:cash,credit',
            'interest_rate'      => 'required_if:payment_method,credit|numeric|min:0|max:1',
            'items'              => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity'   => 'required|integer|min:1',
        ];
    }

    public function messages(): array
    {
        return [
            'items.required'              => 'Au moins un produit est requis.',
            'items.*.product_id.required' => 'Chaque item doit avoir un produit.',
            'items.*.quantity.min'        => 'La quantité doit être au moins 1.',
            'interest_rate.required_if'   => 'Le taux d\'intérêt est requis pour un paiement à crédit.',
        ];
    }
}