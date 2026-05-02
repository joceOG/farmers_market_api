<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreProductRequest;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use App\Models\Category;

class ProductController extends Controller
{
    // GET /products
public function index(Request $request): JsonResponse
{
    $query = Product::with('category');

    if ($request->has('category_id')) {
        $categoryId = $request->category_id;

        // Récupère les IDs des sous-catégories enfants
        $childIds = Category::where('parent_id', $categoryId)
            ->pluck('id')
            ->toArray();

        // Cherche dans la catégorie ET ses enfants
        $ids = array_merge([$categoryId], $childIds);
        $query->whereIn('category_id', $ids);
    }

    if ($request->has('search')) {
        $query->where('name', 'like', '%' . $request->search . '%');
    }

    return response()->json(['data' => $query->paginate(20)]);
}

    // GET /products/{id}
    public function show(Product $product): JsonResponse
    {
        return response()->json(['data' => $product->load('category.parent')]);
    }

        // POST /products
    public function store(StoreProductRequest $request): JsonResponse
    {
        if (!in_array($request->user()->role, ['admin', 'supervisor'])) {
            return response()->json(['message' => 'Accès refusé'], 403);
        }  
        $product = Product::create($request->validated());
        return response()->json(['data' => $product->load('category')], 201);
    }

    // PUT /products/{id}
    public function update(StoreProductRequest $request, Product $product): JsonResponse
    {
        $product->update($request->validated());
        return response()->json(['data' => $product->load('category')]);
    }

    // DELETE /products/{id}
    public function destroy(Product $product): JsonResponse
    {
        $product->delete();
        return response()->json(['message' => 'Produit supprimé.']);
    }
}