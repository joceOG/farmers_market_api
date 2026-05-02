<?php
namespace App\Http\Controllers\API;

use App\Models\Farmer;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class FarmerController extends Controller
{
    public function index()
    {
        return Farmer::with('debts')
            ->get()
            ->map(function ($farmer) {
                $farmer->total_debt = $farmer->debts
                    ->where('status', 'open')
                    ->sum('amount_fcfa');
                return $farmer;
            });
    }

    public function store(Request $request)
    {
        $request->validate([
            'identifier'   => 'required|unique:farmers',
            'firstname'    => 'required',
            'lastname'     => 'required',
            'phone'        => 'required',
            'credit_limit' => 'nullable|numeric',
            'village'      => 'nullable|string',
            'region'       => 'nullable|string',
        ]);

        return Farmer::create($request->all());
    }

    public function show($id)
    {
        $farmer = Farmer::with('debts')->findOrFail($id);
        $farmer->total_debt = $farmer->debts
            ->where('status', 'open')
            ->sum('amount_fcfa');
        return $farmer;
    }

    public function update(Request $request, $id)
    {
        $farmer = Farmer::findOrFail($id);
        $farmer->update($request->all());
        return $farmer;
    }

    public function destroy($id)
    {
        Farmer::destroy($id);
        return response()->json(['success' => true]);
    }

    public function search(Request $request)
    {
        $q = $request->q;
        $farmer = Farmer::with('debts')
            ->where('identifier', $q)
            ->orWhere('phone', $q)
            ->first();

        if ($farmer) {
            $farmer->total_debt = $farmer->debts
                ->where('status', 'open')
                ->sum('amount_fcfa');
        }

        return $farmer
            ? response()->json($farmer)
            : response()->json(['message' => 'Farmer non trouvé'], 404);
    }
}