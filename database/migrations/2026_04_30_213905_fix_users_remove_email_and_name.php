<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{

public function up(): void
{
    // Supprimer email si existe
    if (Schema::hasColumn('users', 'email')) {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('email');
        });
    }

    // Supprimer name si existe
    if (Schema::hasColumn('users', 'name')) {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('name');
        });
    }
}
public function down(): void
{
    Schema::table('users', function (Blueprint $table) {

        if (!Schema::hasColumn('users', 'email')) {
            $table->string('email')->unique()->nullable();
        }

        if (!Schema::hasColumn('users', 'name')) {
            $table->string('name')->nullable();
        }
    });
}
};