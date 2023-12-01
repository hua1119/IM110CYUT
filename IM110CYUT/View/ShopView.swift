//  text.swift
//  CYUTSHOP
//
//  Created by Mac on 2023/11/24.
//

import SwiftUI

// Recipe.swift
struct Recipe
{
    var name: String
    var ingredients: [Ingredient]
}

struct Ingredient
{
    var name: String
    var quantity: String
}

// ShoppingList.swift
struct ShoppingList 
{
    var days: Int
    var recipes: [Recipe]
}

struct IngredientRow: View 
{
    var ingredient: Ingredient
    
    var body: some View 
    {
        HStack
        {
            VStack(alignment: .leading)
            {
                Text("食材名稱: \(ingredient.name)")
                Text("數量: \(ingredient.quantity)")
            }
            Spacer()
            Image(systemName: "minus.circle")
                .foregroundColor(.red)
        }
    }
}

    struct RecipeView: View 
{
        @Binding var recipes: [Recipe]
        var onRecipeSelected: (Recipe) -> Void
        var onDeleteRecipe: (Recipe) -> Void  // 新增用於刪除整個食譜的回調函數

        var body: some View 
        {
            Text("採購")
            if recipes.isEmpty
            {
                Text("目前無採買項目")
            } else {
                List 
                {
                    ForEach(Array(recipes.enumerated()), id: \.element.name) { index, recipe in
                        ForEach(recipe.ingredients.indices, id: \.self) { ingredientIndex in
                            HStack {
                                VStack(alignment: .leading) 
                                {
                                    Text("食材名稱: \(recipes[index].ingredients[ingredientIndex].name)")
                                    Text("數量: \(recipes[index].ingredients[ingredientIndex].quantity)")
                                }
                                Spacer()
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .onTapGesture
                                {
                                        // 刪除單個食材
                                        recipes[index].ingredients.remove(at: ingredientIndex)
                                        
                                        // 檢查食譜的食材數量，如果為零，則刪除整個食譜
                                        if recipes[index].ingredients.isEmpty {
                                            onDeleteRecipe(recipes[index])
                                        }
                                    }
                            }
                        }
                        .onDelete 
                        { indices in
                            // 實現食材刪除邏輯，使用 indices
                            let originalIndices = indices.map { $0 }
                            
                            for originalIndex in originalIndices 
                            {
                                recipes[index].ingredients.remove(at: originalIndex)
                            }

                            // 檢查食譜的食材數量，如果為零，則刪除整個食譜
                            if recipes[index].ingredients.isEmpty 
                            {
                                onDeleteRecipe(recipes[index])
                            }
                        }
                    }
                }
            }
        }
    }




struct ShopView: View
{
    @State private var selectedRecipe: Recipe?
    @State private var shoppingList: ShoppingList = ShoppingList(days: 7, recipes: recipes)

    var body: some View 
    {
        NavigationStack 
        {
            VStack 
            {
                RecipeView(recipes: $shoppingList.recipes, onRecipeSelected:
                            { recipe in
                    selectedRecipe = recipe
                }, onDeleteRecipe:
                            { recipe in
                    // 處理食譜刪除邏輯
                    if let index = shoppingList.recipes.firstIndex(where: { $0.name == recipe.name }) {
                        shoppingList.recipes.remove(at: index)
                    }
                })
                .navigationTitle("採買")
            }
        }
    }
}

// 預設的食譜
let recipes: [Recipe] = [
    Recipe(name: "義大利肉醬意大利麵", ingredients: [Ingredient(name: "義大利麵", quantity: "200克"), Ingredient(name: "碎牛肉", quantity: "300克")]),
    Recipe(name: "烤雞", ingredients: [Ingredient(name: "雞腿", quantity: "4片"), Ingredient(name: "橄欖油", quantity: "2湯匙"), Ingredient(name: "迷迭香", quantity: "1茶匙")]),
    // 添加其他食譜
    Recipe(name: "水煮魚", ingredients: [Ingredient(name: "魚片", quantity: "500克"), Ingredient(name: "花椒", quantity: "适量"), Ingredient(name: "薑", quantity: "适量")]),
   
    // Add more recipes as needed
]

struct ShopView_Previews: PreviewProvider
{
    static var previews: some View 
    {
        ShopView()
    }
}
