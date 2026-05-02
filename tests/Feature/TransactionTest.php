<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class TransactionTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    public function test_example(): void
    {
        $response = $this->get('/');

        $response->assertStatus(200);
    }
}
<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Farmer;
use App\Models\Product;
use Tests\TestCase;
use Laravel\Sanctum\Sanctum;

class TransactionTest extends TestCase
{
    public function test_credit_transaction_respects_limit()
    {
        $user = User::factory()->create(['role' => 'operator']);
        Sanctum::actingAs($user);

        $farmer = Farmer::factory()->create([
            'credit_limit' => 10000
        ]);

        $product = Product::factory()->create([
            'price_fcfa' => 15000
        ]);

        $response = $this->postJson('/api/transactions', [
            'farmer_id' => $farmer->id,
            'products' => [
                ['product_id' => $product->id, 'quantity' => 1]
            ],
            'payment_method' => 'credit'
        ]);

        $response->assertStatus(400); // bloque
    }
}