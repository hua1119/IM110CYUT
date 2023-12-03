import SwiftUI

struct PlanView: View
{
    
    @State private var plans: [String: [String]] =
    {
        var initialPlans: [String: [String]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        for i in 0..<7
        {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: Date())
            {
                let formattedDate = dateFormatter.string(from: date)
                initialPlans[formattedDate] = []
            }
        }
        return initialPlans
    }()
    struct FoodOption
    {
        var name: String
        var backgroundImage: String
    }
    
    struct CustomButton: View
    {
        var imageName: String
        var buttonText: String
        var action: () -> Void
        
        var body: some View
        {
            Button(action: action)
            {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 150)
                    .cornerRadius(10)
                    .overlay(
                        Text(buttonText)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .font(.custom("按鈕", size: 60))
                            .padding()
                    )
                    .opacity(0.8)
            }
        }
    }
   
    struct FoodSelectionView: View {
        @Binding var isShowingDetail: Bool
        @Binding var editedPlan: String
        var foodOptions: [FoodOption]

        var body: some View {
            
            VStack {
                Text("選擇一個食物：")
                    .font(.title)
                    .padding()

                ScrollView {
                    ForEach(foodOptions, id: \.name) { foodOption in
                        Button(action: {
                            self.editedPlan = foodOption.name
                            self.isShowingDetail.toggle()
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.orange) // 背景色，你可以根據需要更改
                                    .frame(width: UIScreen.main.bounds.width - 40, height: 150)
                                    .cornerRadius(10)
                                    .opacity(0.8)
                                    .offset(y: 40)
                                    .font(.title)
                                
                                Image(foodOption.backgroundImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width - 40, height: 150)
                                    .cornerRadius(10)
                                    

                                VStack {
                                        Spacer()
                                        Label(foodOption.name, systemImage: "")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding()
                                        .offset(y: 45) //向下移動10個點，你可以根據需要調整這個值
                                                           }
                            }
                            
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        .padding(.bottom, 60)
                    }
                   
                }
                .scrollIndicators(.hidden)
            }
            .padding(20)
            
        }
    }

    
    struct EditPlanView: View
    {
        
        var day: String
        var planIndex: Int
        @Binding var plans: [String: [String]]
        @State private var searchText: String = ""
        @State private var editedPlan = ""
        @State private var isShowingDetail1 = false
        @State private var isShowingDetail2 = false
        @State private var isShowingDetail3 = false
        @State private var isShowingDetail4 = false
        @State private var isShowingDetail5 = false
        @State private var isShowingDetail6 = false
        @State private var isShowingDetail7 = false
        @Environment(\.presentationMode) var presentationMode
     
        //懶人選項
        let foodOptions1: [FoodOption] = [
               FoodOption(name: "泡麵", backgroundImage: "泡麵"),
               FoodOption(name: "蔥油餅", backgroundImage: "蔥油餅"),
               FoodOption(name: "炒菜豆", backgroundImage: "炒菜豆"),
               FoodOption(name: "番茄炒蛋", backgroundImage: "番茄炒蛋")
               // 添加更多食物選項及其相應的背景圖片
           ]
        //減肥選項
        let foodOptions2: [FoodOption] = [
               FoodOption(name: "青江菜", backgroundImage: "青江菜"),
               FoodOption(name: "炒蛋", backgroundImage: "炒蛋"),
               FoodOption(name: "雞胸肉", backgroundImage: "雞胸肉"),
               FoodOption(name: "花椰菜", backgroundImage: "花椰菜")
               // 添加更多食物選項及其相應的背景圖片
           ]
        //省錢選項
        let foodOptions3: [FoodOption] = [
               FoodOption(name: "泡麵", backgroundImage: "泡麵"),
               FoodOption(name: "懶惰蟲堡", backgroundImage: "懶惰蟲堡"),
               FoodOption(name: "懶惰蟲", backgroundImage: "懶惰蟲"),
               FoodOption(name: "懶惰", backgroundImage: "懶惰")
               // 添加更多食物選項及其相應的背景圖片
           ]
        //放縱選項
        let foodOptions4: [FoodOption] = [
               FoodOption(name: "泡麵", backgroundImage: "泡麵"),
               FoodOption(name: "懶惰蟲堡", backgroundImage: "懶惰蟲堡"),
               FoodOption(name: "懶惰蟲", backgroundImage: "懶惰蟲"),
               FoodOption(name: "懶惰", backgroundImage: "懶惰")
               // 添加更多食物選項及其相應的背景圖片
           ]
        //養生選項
        let foodOptions5: [FoodOption] = [
               FoodOption(name: "泡麵", backgroundImage: "泡麵"),
               FoodOption(name: "懶惰蟲堡", backgroundImage: "懶惰蟲堡"),
               FoodOption(name: "懶惰蟲", backgroundImage: "懶惰蟲"),
               FoodOption(name: "懶惰", backgroundImage: "懶惰")
               // 添加更多食物選項及其相應的背景圖片
           ]
        //今日推薦選項
        let foodOptions6: [FoodOption] = [
               FoodOption(name: "泡麵", backgroundImage: "泡麵"),
               FoodOption(name: "懶惰蟲堡", backgroundImage: "懶惰蟲堡"),
               FoodOption(name: "懶惰蟲", backgroundImage: "懶惰蟲"),
               FoodOption(name: "懶惰", backgroundImage: "懶惰")
               // 添加更多食物選項及其相應的背景圖片
           ]
        //聽天由命？？ 暫定
        let foodOptions7: [FoodOption] = [
               FoodOption(name: "泡麵", backgroundImage: "泡麵"),
               FoodOption(name: "懶惰蟲堡", backgroundImage: "懶惰蟲堡"),
               FoodOption(name: "懶惰蟲", backgroundImage: "懶惰蟲"),
               FoodOption(name: "懶惰", backgroundImage: "懶惰")
               // 添加更多食物選項及其相應的背景圖片
           ]
        
    
    
            
        var body: some View
        {
            VStack
            {
                Text("選擇的食物: \(editedPlan)")
                               .font(.title)
                               .padding(.top,30)
                               .opacity(editedPlan.isEmpty ? 0 : 1)
                               .offset(y: -18)
                HStack
                {
                }
            }
            .navigationBarItems(trailing: Button("保存")
                                {
                if var dayPlans = plans[day]
                {
                        dayPlans[planIndex] = editedPlan
                        plans[day] = dayPlans
                    }

                // 保存編輯計畫
                self.presentationMode.wrappedValue.dismiss()
            })
                NavigationStack
            {
                    ScrollView
                {
                        VStack(spacing:5)
                    {
                            HStack(spacing:-20)
                        {
                                TextField("搜尋食譜.....", text: $searchText)
                                    .padding()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                
                                Button(action:
                                        {
                                                       // 執行搜尋操作
                                                   })
                            {
                                                       Image(systemName: "magnifyingglass") // 放大鏡圖標
                                                           .padding()
                                                   }
                                               }
                            .padding(.top, 30)
                            
                            VStack (spacing:30)
                        {
                            //懶人按鍵
                                      CustomButton(imageName: "懶人", buttonText: "懶人")
                            {
                                          isShowingDetail1.toggle()
                                      }
                                      .sheet(isPresented: $isShowingDetail1)
                            {
                                          FoodSelectionView(isShowingDetail: $isShowingDetail1, editedPlan: $editedPlan, foodOptions: foodOptions1)
                                      }
                                  
                                                  

                                //減肥按鍵
                            CustomButton(imageName: "減肥", buttonText: "減肥")
                            {
                                          isShowingDetail2.toggle()
                                      }
                                      .sheet(isPresented: $isShowingDetail2)
                            {
                                          FoodSelectionView(isShowingDetail: $isShowingDetail2, editedPlan: $editedPlan, foodOptions: foodOptions2)
                                      }
                                //省錢按鍵
                            CustomButton(imageName: "省錢", buttonText: "省錢")
                            {
                                    // 按鈕的動作
                                isShowingDetail3.toggle()
                                }
                                
                                        .sheet(isPresented: $isShowingDetail3)
                                    {
                                FoodSelectionView(isShowingDetail: $isShowingDetail3, editedPlan: $editedPlan, foodOptions: foodOptions3)
                                        }
                                //放縱按鍵
                            CustomButton(imageName: "放縱", buttonText: "放縱")
                            {
                                    // 按鈕的動作
                                isShowingDetail4.toggle()
                                }
                            .sheet(isPresented: $isShowingDetail4)
                        {
                                FoodSelectionView(isShowingDetail: $isShowingDetail4, editedPlan: $editedPlan, foodOptions: foodOptions4)
                            }
                                //養生按鍵
                            CustomButton(imageName: "養生", buttonText: "養生")
                            {
                                    // 按鈕的動作
                                isShowingDetail5.toggle()
                                }
                            .sheet(isPresented: $isShowingDetail5)
                        {
                                FoodSelectionView(isShowingDetail: $isShowingDetail5, editedPlan: $editedPlan, foodOptions: foodOptions5)
                            }
                            CustomButton(imageName: "今日推薦", buttonText: "今日推薦")
                            {
                                    // 按鈕的動作
                                isShowingDetail6.toggle()
                                }
                            .sheet(isPresented: $isShowingDetail6)
                        {
                                FoodSelectionView(isShowingDetail: $isShowingDetail6, editedPlan: $editedPlan, foodOptions: foodOptions6)
                            }
                            CustomButton(imageName: "聽天由命", buttonText: "聽天由命")
                            {
                                    // 按鈕的動作
                                isShowingDetail7.toggle()
                                }
                            .sheet(isPresented: $isShowingDetail7)
                        {
                            FoodSelectionView(isShowingDetail: $isShowingDetail7, editedPlan: $editedPlan, foodOptions: foodOptions7)
                            }
                        }
                        .padding()
                    }
                }
                .scrollIndicators(.hidden)
             }
         }
      }
    
    
    var body: some View
    {
        NavigationStack
        {
            VStack
            {
                Text("計畫")
                List
                {
                    ForEach(Array(plans.keys.sorted(by: <)), id: \.self) { day in
                        Section(header:
                                    HStack
                                {
                            Text(day).font(.title)
                            Text(getDayLabelText(for: day)) // 顯示 "第一天" 到 "第七天" 的文本
                            Spacer()
                            Button(action:
                                    {
                                plans[day]?.append("新計畫")
                            })
                            {
                                Image(systemName: "plus.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }
                        }
                        )
                        {
                            if let dayPlans = plans[day]
                            {
                                ForEach(dayPlans.indices, id: \.self) { index in
                                    let plan = dayPlans[index]
                                    NavigationLink(destination: EditPlanView(day: day, planIndex: index, plans: $plans))
                                    {
                                        Text(plan).font(.headline)
                                    }
                                }
                                .onDelete
                                { indices in
                                    plans[day]?.remove(atOffsets: indices)
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .navigationBarTitle("計畫")
            }
        }
    }
    
    // 根據日期獲取 "第一天" 到 "第七天" 的文本
    private func getDayLabelText(for date: String) -> String
    {
        guard let index = Array(plans.keys.sorted(by: <)).firstIndex(of: date) else
        {
            return ""
        }
        let dayNumber = (index % 7) + 1
        return "第\(dayNumber)天"
    }
}

struct PlanView_Previews: PreviewProvider
{
    static var previews: some View
    {
        PlanView()
    }
}
