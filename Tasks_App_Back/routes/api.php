<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\TaskController;
use App\Http\Controllers\CategoryController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);


Route::middleware('auth:sanctum')->group(function () {
    
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);


    Route::get('/dashboard', [TaskController::class, 'dashboard']);
    Route::get('/tasks/today', [TaskController::class, 'today']);
    Route::post('/tasks/{id}/restore', [TaskController::class, 'restore']);

    Route::apiResource('tasks', TaskController::class);
    Route::apiResource('categories', CategoryController::class);
});

//ينشئ Task.
//يعدلها.
//يحذفها.
//يرجعها بعد الحذف.
//يغير حالتها.
//يبحث عنها.
//يفلترها.
//يشوف Tasks النهاردة.
//يشوف Dashboard فيها إحصائيات.

