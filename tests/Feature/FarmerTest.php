<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class FarmerTest extends TestCase
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
use Tests\TestCase;
use Laravel\Sanctum\Sanctum;

class FarmerTest extends TestCase
{
    public function test_create_farmer()
    {
        $user = User::factory()->create(['role' => 'operator']);
        Sanctum::actingAs($user);

        $response = $this->postJson('/api/farmers', [
            'identifier' => 'CI-999',
            'firstname' => 'Test',
            'lastname' => 'Farmer',
            'phone' => '0700000000',
            'credit_limit' => 100000
        ]);

        $response->assertStatus(201);
    }

    public function test_search_farmer()
    {
        $user = User::factory()->create(['role' => 'operator']);
        Sanctum::actingAs($user);

        $response = $this->getJson('/api/farmers?phone=0700000000');

        $response->assertStatus(200);
    }
}