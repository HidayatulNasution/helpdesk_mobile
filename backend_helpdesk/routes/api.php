<?php

use App\Http\Controllers\API\ApiController;
use App\Http\Controllers\TiketController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('register', [ApiController::class, 'register']);
Route::post('login', [ApiController::class, 'login']);

Route::group(
    [
        "middleware" => ["auth:sanctum"]
    ],
    function () {
        Route::get('profile', [ApiController::class, 'profile']);
        Route::get('logout', [ApiController::class, 'logout']);;

        Route::get('gettikets', [TiketController::class, 'index']);
        Route::get('paginates', [TiketController::class, 'paginates']);


        Route::post('tikets', [TiketController::class, 'store']);
        Route::get('tikets/{id}', [TiketController::class, 'show']);
        Route::put('tiketsupdate/{id}', [TiketController::class, 'update']);
        Route::delete('tiketsdelete/{id}', [TiketController::class, 'destroy']);
        Route::post('tiketpros/{tiket_id}', [TiketController::class, 'statusPros']);
        Route::post('tiketcomment/{tiket_id}', [TiketController::class, 'comment']);
        Route::get('tiketget/{tiket_id}', [TiketController::class, 'getComments']);
    }
);
