//
//  StockView.swift
//  IM110CYUT
//
//  Created by Ｍac on 2023/12/17.
//

import SwiftUI

// MARK: 庫存食材格式
struct StockIngredient: Identifiable
{
    var id = UUID()
    var name: String
    var quantity: Int
    var isSelectedForDeletion: Bool = false
}

// MARK: 新增食材
struct AddIngredients: View
{
    @State private var newIngredientName: String = ""
    @State private var newIngredientQuantity: String = ""
    var onAdd: (StockIngredient) -> Void
    @Binding var isSheetPresented: Bool
    
    var body: some View
    {
        NavigationStack
        {
            Form
            {
                Section(header: Text("新增食材內容"))
                {
                    TextField("請輸入食材名稱", text: $newIngredientName)
                    TextField("請輸入食材數量", text: $newIngredientQuantity)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("新增食材")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button("新增")
                    {
                        if let quantity = Int(newIngredientQuantity), !newIngredientName.isEmpty
                        {
                            let newIngredient = StockIngredient(name: newIngredientName, quantity: quantity)
                            onAdd(newIngredient)
                            isSheetPresented = false
                        }
                    }
                }
            }
        }
    }
}

// MARK: 庫存主介面
struct StockView: View
{
    @State private var ingredients: [StockIngredient]
    @State private var isAddSheetPresented = false
    @State private var isEditing: Bool = false
    
    init()
    {
        let ingredientNames = ["食材1", "食材2", "食材3", "食材4", "食材5"]
        _ingredients = State(initialValue: ingredientNames.map { StockIngredient(name: $0, quantity: Int.random(in: 1...10)) })
    }
    
    var body: some View
    {
        NavigationStack
        {
            VStack
            {
                Text("庫存")
                    .font(.title)
                    .padding()
                // MARK: 庫存清單
                List {
                    ForEach(ingredients.indices, id: \.self)
                    { index in
                        HStack
                        {
                            // 編輯功能
                            if isEditing
                            {
                                Button(action:
                                        {
                                    toggleSelection(index)
                                }) {
                                    Image(systemName: ingredients[index].isSelectedForDeletion ? "checkmark.square" : "square")
                                }
                                .buttonStyle(BorderlessButtonStyle()) // 非編輯模式下點擊按鈕不觸發滑動刪除
                            }
                            
                            Text("\(ingredients[index].name): \(ingredients[index].quantity)")
                                .foregroundColor(ingredients[index].isSelectedForDeletion ? .gray : .primary)
                            
                            Spacer()
                            
                            if isEditing
                            {
                                TextField("數量", value: $ingredients[index].quantity, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 50)
                            }
                        }
                    }
                }
                .padding()
                
                // Move the buttons outside the List
                HStack
                {
                    if isEditing
                    {
                        Button("新增食材")
                        {
                            isAddSheetPresented.toggle()
                        }
                        .padding()
                    }
                }
                .padding()
                
                // MARK: 新增食材的SHEET
                .sheet(isPresented: $isAddSheetPresented)
                {
                    AddIngredients(onAdd: { newIngredient in
                        ingredients.append(newIngredient)
                    }, isSheetPresented: $isAddSheetPresented)
                }
            }
            .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    HStack
                    {
                        if !isEditing
                        {
                            Button("編輯")
                            {
                                isEditing.toggle()
                            }
                        } else {
                            Button(action:
                                    {
                                // Check if any item is selected for deletion
                                let selectedItemsCount = ingredients.filter { $0.isSelectedForDeletion }.count
                                if selectedItemsCount > 0
                                {
                                    // Perform deletion logic here
                                    deleteSelectedIngredients()
                                } else {
                                    // Cancel editing mode
                                    isEditing.toggle()
                                }
                            }) {
                                Text(ingredients.contains { $0.isSelectedForDeletion } ? "刪除" : "取消")
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: 編輯方法
    private func toggleSelection(_ index: Int)
    {
        ingredients[index].isSelectedForDeletion.toggle()
    }
    // MARK: 刪除方法
    private func deleteSelectedIngredients()
    {
        // Filter out the selected indices and convert them to IndexSet
        let indexSet = IndexSet(ingredients.indices.filter { ingredients[$0].isSelectedForDeletion })
        ingredients.remove(atOffsets: indexSet)
        
        // Exit editing mode after deletion
        isEditing = false
    }
}

struct StockView_Previews: PreviewProvider
{
    static var previews: some View
    {
        StockView()
    }
}
