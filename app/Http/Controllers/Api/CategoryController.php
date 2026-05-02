<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreCategoryRequest;
use App\Models\Category;
use Illuminate\Http\JsonResponse;

class CategoryController extends Controller
{
    // GET /categories (arbre complet)
    public function index(): JsonResponse
    {
        $categories = Category::whereNull('parent_id')
            ->with('childrenRecursive')
            ->get();

        return response()->json(['data' => $categories]);
    }

    // GET /categories/{id}
    public function show(Category $category): JsonResponse
    {
        return response()->json(['data' => $category->load('children', 'parent', 'products')]);
    }

    // POST /categories
    public function store(StoreCategoryRequest $request): JsonResponse
    {
        $category = Category::create($request->validated());
        return response()->json(['data' => $category], 201);
    }

    // PUT /categories/{id}
    public function update(StoreCategoryRequest $request, Category $category): JsonResponse
    {
        $category->update($request->validated());
        return response()->json(['data' => $category]);
    }

    // DELETE /categories/{id}
    public function destroy(Category $category): JsonResponse
    {
        if ($category->children()->exists() || $category->products()->exists()) {
            return response()->json([
                'message' => 'Impossible de supprimer une catégorie avec des sous-catégories ou des produits.',
            ], 422);
        }

        $category->delete();
        return response()->json(['message' => 'Catégorie supprimée.']);
    }
}