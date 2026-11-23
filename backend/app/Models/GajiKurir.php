<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class GajiKurir extends Model
{
    protected $fillable = ['kurir_id', 'dibayar_oleh', 'nominal', 'periode'];
    protected $casts = ['nominal' => 'decimal:2'];

    public function kurir() { return $this->belongsTo(User::class, 'kurir_id'); }
    public function pembayar() { return $this->belongsTo(User::class, 'dibayar_oleh'); }
}
