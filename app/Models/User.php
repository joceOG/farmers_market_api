<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'username',
        'password',
        'role',
        'supervisor_id'
    ];

    protected $hidden = [
        'password',
        'remember_token'
    ];

    // 🔗 Relations

    public function setPasswordAttribute($value)
    {
        $this->attributes['password'] = Hash::needsRehash($value)
            ? bcrypt($value)
            : $value;
    }

    public function supervisor()
    {
        return $this->belongsTo(User::class, 'supervisor_id');
    }

    public function operators()
    {
        return $this->hasMany(User::class, 'supervisor_id');
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class, 'operator_id');
    }
}