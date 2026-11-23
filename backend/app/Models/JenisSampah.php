<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JenisSampah extends Model {
    use HasFactory;
    protected $fillable = ['nama', 'kategori', 'harga_per_kg', 'icon', 'deskripsi'];
    protected $casts = ['harga_per_kg' => 'decimal:2'];
}