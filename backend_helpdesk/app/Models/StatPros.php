<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class StatPros extends Model
{
    /** @use HasFactory<\Database\Factories\StatProsFactory> */
    use HasFactory;

    protected $fillable = [
        'user_id',
        'tiket_id'
    ];

    public function tiket(): BelongsTo
    {
        return $this->belongsTo(tiket::class);
    }
}
