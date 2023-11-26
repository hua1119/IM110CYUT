//
//  AdjustView.swift
//  IM110CYUT
//
//  Created by Ｍac on 2023/11/26.
//

import SwiftUI

struct CustomRecipe {
    var name: String
    var ingredients: [CustomIngredient]
}

struct CustomIngredient {
    var name: String
    var quantity: String
}

struct ShoppingListView {
    var days: Int
    var recipes: [CustomRecipe]
}

struct IngredientRowView: View {
    var ingredient: CustomIngredient
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("食材名稱: \(ingredient.name)")
                Text("數量: \(ingredient.quantity)")
            }
            Spacer()
            Image(systemName: "minus.circle")
                .foregroundColor(.red)
        }
    }
}

struct RecipeItemView: View {
    @Binding var recipes: [CustomRecipe]
    var onRecipeSelected: (CustomRecipe) -> Void
//    var onDeleteRecipe: (CustomRecipe) -> Void
    
    var body: some View {
        if recipes.isEmpty {
            Text("目前無採買項目")
        } else {
            List {
                ForEach(Array(recipes.enumerated()), id: \.element.name) { index, recipe in
                    ForEach(recipe.ingredients.indices, id: \.self) { ingredientIndex in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("料理名稱: \(recipes[index].ingredients[ingredientIndex].name)")
                                Text("數量: \(recipes[index].ingredients[ingredientIndex].quantity)")
                            }
                            Spacer()
//                            Image(systemName: "minus.circle")
//                                .foregroundColor(.red)
//                                .onTapGesture {
//                                    // 刪除單個食材
//                                    recipes[index].ingredients.remove(at: ingredientIndex)
//
//                                    // 檢查食譜的食材數量，如果為零，則刪除整個食譜
//                                    if recipes[index].ingredients.isEmpty {
//                                        onDeleteRecipe(recipes[index])
//                                    }
//                                }
                        }
                    }
                    .onMove { indices, newOffset in
                        // 處理食材重新排序
                        recipes[index].ingredients.move(fromOffsets: indices, toOffset: newOffset)
                    }
//                    .onDelete { indices in
//                        // 實現食材刪除邏輯，使用 indices
//                        let originalIndices = indices.map { $0 }
//
//                        for originalIndex in originalIndices {
//                            recipes[index].ingredients.remove(at: originalIndex)
//                        }
//
//                        // 檢查食譜的食材數量，如果為零，則刪除整個食譜
//                        if recipes[index].ingredients.isEmpty {
//                            onDeleteRecipe(recipes[index])
//                        }
//                    }
                }
            }
        }
    }
}

struct AdjustView: View {
    @State private var selectedRecipe: CustomRecipe?
    @State private var shoppingList: ShoppingListView = ShoppingListView(days: 7, recipes: customRecipes)

    var body: some View {
        NavigationStack {
            VStack {
                RecipeItemView(recipes: $shoppingList.recipes, onRecipeSelected:
                            { recipe in
                    selectedRecipe = recipe
                }
//                               , onDeleteRecipe:
//                            { recipe in
//                    // 處理食譜刪除邏輯
//                    if let index = shoppingList.recipes.firstIndex(where: { $0.name == recipe.name }) {
//                        shoppingList.recipes.remove(at: index)
//                    }
//                }
                )
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("調整計畫")
                .navigationBarItems(trailing: EditButton())
            }
        }
    }

    // 添加相同食譜時進行檢查和疊加
    func addCustomRecipe(_ newRecipe: CustomRecipe) {
        if let existingIndex = shoppingList.recipes.firstIndex(where: { $0.name == newRecipe.name }) {
            // 食譜已存在，將其食材進行疊加
            for newIngredient in newRecipe.ingredients {
                if let existingIngredientIndex = shoppingList.recipes[existingIndex].ingredients.firstIndex(where: { $0.name == newIngredient.name }) {
                    // 食材已存在，進行數量疊加
                    shoppingList.recipes[existingIndex].ingredients[existingIngredientIndex].quantity += newIngredient.quantity
                } else {
                    // 食材不存在，直接添加
                    shoppingList.recipes[existingIndex].ingredients.append(newIngredient)
                }
            }
        } else {
            // 食譜不存在，直接添加
            shoppingList.recipes.append(newRecipe)
        }
    }
}

let customRecipes: [CustomRecipe] = [
    CustomRecipe(name: "義大利肉醬意大利麵", ingredients: [CustomIngredient(name: "義大利麵", quantity: "200克"), CustomIngredient(name: "碎牛肉", quantity: "300克")]),
    CustomRecipe(name: "烤雞", ingredients: [CustomIngredient(name: "雞腿", quantity: "4片"), CustomIngredient(name: "橄欖油", quantity: "2湯匙"), CustomIngredient(name: "迷迭香", quantity: "1茶匙")]),
    CustomRecipe(name: "水煮魚", ingredients: [CustomIngredient(name: "魚片", quantity: "500克"), CustomIngredient(name: "花椒", quantity: "适量"), CustomIngredient(name: "薑", quantity: "适量")]),
]

struct AdjustView_Previews: PreviewProvider {
    static var previews: some View {
        AdjustView()
    }
}
