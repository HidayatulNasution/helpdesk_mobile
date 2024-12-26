<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\user;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class tiket extends Model
{
    /** @use HasFactory<\Database\Factories\TiketFactory> */
    use HasFactory;
    protected $table = 'tikets';
    protected $fillable = [
        'created_at',
        'bidang_system',
        'kategori',
        'status',
        'problem',
        'prioritas',
        'image'
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(user::class);
    }
}
