<?php

namespace Tests\Feature;

use Illuminate\Fo<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Farmer;
use App\Models\Debt;
use Tests\TestCase;
use Laravel\Sanctum\Sanctum;

class RepaymentTest extends TestCase
{
    public function test_fifo_repayment()
    {
        $user = User::factory()->create(['role' => 'operator']);
        Sanctum::actingAs($user);

        $farmer = Farmer::factory()->create();

        $debt1 = Debt::factory()->create([
            'farmer_id' => $farmer->id,
            'remaining_amount' => 10000
        ]);

        $debt2 = Debt::factory()->create([
            'farmer_id' => $farmer->id,
            'remaining_amount' => 5000
        ]);

        $response = $this->postJson('/api/repayments', [
            'farmer_id' => $farmer->id,
            'kg' => 10,
            'rate' => 1000 // = 10000 FCFA
        ]);

        $response->assertStatus(200);

        $this->assertDatabaseHas('debts', [
            'id' => $debt1->id,
            'remaining_amount' => 0
        ]);
    }
}undation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class RepaymentTest extends TestCase
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
