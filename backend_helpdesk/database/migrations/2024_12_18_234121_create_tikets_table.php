<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('tikets', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->foreignId('user_id')->nullable()->constrained('users')->onDelete('cascade'); // Menambahkan user_id dengan foreign key
            $table->string('bidang_system');
            $table->string('kategori');
            $table->string('content')->nullable();
            $table->boolean('status')->default(false);
            $table->text('problem')->nullable();
            $table->text('result')->nullable();
            $table->boolean('prioritas')->default(false);
            $table->string('image')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tikets');
    }
};
