<?php

use App\Http\Controllers\Api\AdminController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\RecommenderController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\TukangProfileController;
use App\Http\Controllers\Api\TukangController;
use Illuminate\Support\Facades\Route;

Route::get('/health', function () {
    return response()->json(['status' => 'ok', 'app' => 'KangMas']);
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/recommend', [RecommenderController::class, 'recommend']);
Route::get('/reviews/tukang/{tukangId}', [ReviewController::class, 'byTukang']);
Route::get('/tukang/{id}', [TukangProfileController::class, 'show']);

Route::post('/tukang/register', [TukangController::class, 'registerTukang']);
Route::get('/tukang', [TukangController::class, 'getApprovedTukangs']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    Route::apiResource('orders', OrderController::class);
    Route::post('/orders/{id}/cancel', [OrderController::class, 'update']);
    Route::post('/orders/{id}/accept', [OrderController::class, 'update']);
    Route::post('/orders/{id}/complete', [OrderController::class, 'update']);
    Route::post('/orders/{id}/approve', [OrderController::class, 'approve']);

    Route::post('/reviews', [ReviewController::class, 'store']);

    Route::put('/tukang/profile', [TukangProfileController::class, 'update']);
    Route::patch('/tukang/toggle-active', [TukangProfileController::class, 'toggleActive']);

    Route::middleware('admin')->prefix('admin')->group(function () {
        Route::get('/dashboard', [AdminController::class, 'dashboard']);
        Route::get('/users', [AdminController::class, 'users']);
        Route::get('/orders', [AdminController::class, 'orders']);
        Route::get('/tukang/analytics', [AdminController::class, 'tukangAnalytics']);

        Route::get('/tukang/pending', [TukangController::class, 'getPendingTukangs']);
        Route::post('/tukang/approve/{id}', [TukangController::class, 'approveTukang']);
        Route::post('/tukang/reject/{id}', [TukangController::class, 'rejectTukang']);
        Route::post('/tukang/blacklist/{id}', [TukangController::class, 'blacklistTukang']);
        Route::post('/tukang/unblacklist/{id}', [TukangController::class, 'unblacklistTukang']);
    });
});
