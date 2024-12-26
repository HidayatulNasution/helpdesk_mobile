<?php

namespace App\Http\Controllers;

use App\Http\Requests\TiketStoreRequest;
use App\Models\Comment;
use App\Models\StatPros;
use App\Models\tiket;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;

class TiketController extends Controller
{
    public function index(Request $request)
    {
        $query = tiket::with('user')->latest();

        // Count the tickets based on their status
        $statusCounts = tiket::selectRaw('status, count(*) as count')
            ->groupBy('status')
            ->get();

        $onProgress = $statusCounts->where('status', 0)->first()->count ?? 0;
        $done = $statusCounts->where('status', 1)->first()->count ?? 0;

        $tikets = $query->paginate(5);

        return response()->json([
            'status' => true,
            'message' => "Tiket Listed Successfully",
            'tiket' => $tikets->items(),
            'status_counts' => [
                'on_progress' => $onProgress,
                'done' => $done,
            ],
            'pagination' => [
                'current_page' => $tikets->currentPage(),
                'total_pages' => $tikets->lastPage(),
                'total_items' => $tikets->total(),
            ],
        ], 200);
    }

    public function paginates(Request $request)
    {
        $query = tiket::with('user')->latest();

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        $tikets = $query->paginate(20);

        return response()->json([
            'status' => true,
            'message' => "Tiket Listed Successfully",
            'tiket' => $tikets->items(),
            'pagination' => [
                'current_page' => $tikets->currentPage(),
                'total_pages' => $tikets->lastPage(),
                'total_items' => $tikets->total(),
            ],
        ], 200);
    }


    public function store(TiketStoreRequest $request)
    {
        try {
            $bidang_system = $request->bidang_system;
            $kategori = $request->kategori;
            $problem = $request->problem ?? null;
            $result = $request->result ?? null;
            $status = $request->status;
            $prioritas = $request->prioritas;

            $imageName = null;
            if ($request->hasFile('image')) {
                $imageName = Str::random(32) . "." . $request->image->getClientOriginalExtension();
                Storage::disk('public')->put($imageName, file_get_contents($request->image));
            }


            auth()->user()->tiket()->create(
                [
                    'bidang_system' => $bidang_system,
                    'kategori' => $kategori,
                    'image' => $imageName,
                    'problem' => $problem,
                    'result' => $result,
                    'prioritas' => $prioritas,
                    'status' => $status
                ]

            );

            return response()->json([
                'results' => "Tiket Successfully Created. '$bidang_system' -- '$kategori' -- '$imageName' -- '$problem' -- '$result' -- '$prioritas' -- '$status'"
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => "Something went really Wrong!",
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        $tiket = tiket::find($id);

        if (!$tiket) {
            return response()->json([
                'message' => 'Tiket Not Found!'
            ], 404);
        }

        return response()->json([
            'tiket' => $tiket
        ], 200);
    }

    public function update(TiketStoreRequest $request, $id)
    {
        try {
            $tiket = tiket::find($id);
            if (!$tiket) {
                return response()->json([
                    'message' => 'Tiket Not Found!'
                ], 404);
            }

            echo "request : $request->image";
            $tiket->bidang_system = $request->bidang_system;
            $tiket->kategori = $request->kategori;
            $tiket->status  = $request->status;
            $tiket->problem = $request->problem;
            $tiket->prioritas = $request->prioritas;

            if ($request->image) {
                $storage = Storage::disk('public');
                if ($storage->exists($tiket->image))
                    $storage->delete($tiket->image);

                $imageName = Str::random(32) . "." . $request->image->getClientOriginalExtension();
                $tiket->image = $imageName;

                $storage->put($imageName, file_get_contents($request->image));
            }

            $tiket->save();

            return response()->json([
                'message' => "Tiket Successfully Update!"
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => "Something Wrong!",
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id)
    {
        $tiket = tiket::find($id);

        if (!$tiket) {
            return response()->json([
                'message' => 'Tiket Not Found'
            ], 404);
        }

        $tiket->delete();

        return response()->json([
            'message' => "Tiket Successfully Deleted!"
        ], 200);
    }

    public function statusPros($tiket_id)
    {
        $tiket = tiket::whereId($tiket_id)->first();

        if (!$tiket) {
            return response()->json([
                'message' => 'Not Found!'
            ], 500);
        }

        // waiting
        $waiting = StatPros::where('user_id', auth()->id())->where('tiket_id', $tiket_id)->delete();
        if ($waiting) {
            return response()->json([
                'message' => 'Waiting Proses'
            ], 200);
        }

        // proses
        $proses = StatPros::create([
            'user_id' => auth()->id(),
            'tiket_id' => $tiket_id,

        ]);

        if ($proses) {
            return response()->json([
                'message' => 'On Process'
            ], 200);
        }
    }

    public function comment(Request $request, $tiket_id)
    {
        $request->validate([
            'body' => 'required'
        ]);

        $comment = Comment::create([
            'user_id' => auth()->id(),
            'tiket_id' => $tiket_id,
            'body' => $request->body
        ]);

        return response()->json([
            'message' => 'success'
        ], 201);
    }

    public function getComments($tiket_id)
    {
        $comments = Comment::with('tiket')->with('user')->whereTiketId($tiket_id)->latest()->get();

        return response()->json([
            'comments' => $comments
        ], 200);
    }
}
