<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class TiketStoreRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        if (request()->isMethod('post')) {
            return [
                'bidang_system' => 'required|string|max:255',
                'kategori' => 'required|string|max:255',
                'status' => 'max:255',
                'problem' => 'string|max:255',
                'result' => 'string|max:255',
                'prioritas' => 'max:255',
                'image' => 'image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            ];
        } else {
            return [
                'bidang_system' => 'required|min:3',
                'image' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048'
            ];
        }
    }

    public function messages()
    {
        if (request()->isMethod('post')) {
            return [
                'bidang_system.required' => 'Bidang System harus di isi',
                'kategori.required' => 'Kategori harus di isi',
                'problem.string' => 'Problem Harus Statement',
                'problem.max' => 'Problem Tidak Boleh lebih dari 255 Karakter',
                'image.max' => 'Lampiran Maximal 2048 MB',
            ];
        } else {
            return [
                'bidang_system.required' => 'Bidang System Harus Di Isi',
                'Kategori.required' => 'Kategori Harus Di Isi',
            ];
        }
    }
}
