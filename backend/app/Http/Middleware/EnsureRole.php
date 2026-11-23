<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Pembatas akses berdasarkan role. Contoh pemakaian di route:
 *   ->middleware('role:mitra,admin')
 */
class EnsureRole
{
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        $user = $request->user();

        if (!$user || !in_array($user->role, $roles, true)) {
            return response()->json([
                'status' => 403,
                'success' => false,
                'message' => 'Akses ditolak. Role Anda tidak diizinkan untuk aksi ini.',
            ], 403);
        }

        return $next($request);
    }
}
