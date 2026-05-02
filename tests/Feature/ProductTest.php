<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
<?php

namespace Tests\Feature;

use App\Models\User;
use Tests\TestCase;
use Laravel\Sanctum\Sanctum;

class ProductTest extends TestCase
{
    public function test_admin_can_create_product()
    {
        $admin = User::factory()->create(['role' => 'admin']);
        Sanctum::actingAs($admin);

        $response = $this->postJson('/api/products', [
            'name' => 'Test Product',
            'price_fcfa' => 5000,
            'category_id' => 1,
            'description' => 'Test desc'
        ]);

        $response->assertStatus(201);
    }
}
class ProductTest extends TestCase
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
