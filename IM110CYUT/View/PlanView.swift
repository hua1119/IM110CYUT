import SwiftUI

struct PlanView: View {
    
    @State private var plans: [String: [String]] = {
        var initialPlans: [String: [String]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        for i in 0..<7 {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: Date()) {
                let formattedDate = dateFormatter.string(from: date)
                initialPlans[formattedDate] = []
            }
        }
        return initialPlans
    }()
    
    struct EditPlanView: View {
        var day: String
        var planIndex: Int
        @Binding var plans: [String: [String]]
        @State private var searchText: String = ""
        @State private var editedPlan: String

        @Environment(\.presentationMode) var presentationMode

        init(day: String, planIndex: Int, plans: Binding<[String: [String]]>) {
            self.day = day
            self.planIndex = planIndex
            self._plans = plans
            self._editedPlan = State(initialValue: plans.wrappedValue[day]?[planIndex] ?? "")
            
        }

        var body: some View {
            VStack{
                HStack {
                }
            }
            .navigationBarItems(trailing: Button("保存") {
                // 保存編輯計畫
                self.presentationMode.wrappedValue.dismiss()
            })
                NavigationView {
                    ScrollView {
                        VStack(spacing:5) {
                            HStack(spacing:-10) {
                                TextField("搜尋食譜.....", text: $searchText)
                                    .padding()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button(action: {
                                                       // 執行搜尋操作
                                                   }) {
                                                       Image(systemName: "magnifyingglass") // 放大鏡圖標
                                                           .padding()
                                                   }
                                               }
                            .padding(.top, -40)
                            
                            VStack (spacing:30){
                                Button(action: {
                                    // 按鈕 1 的動作
                                }) {
                                    Image("1") // 替換 "button_image_1" 為你的圖片名稱
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("懶人")
                                                .foregroundColor(.black)
                                                .font(.title)
                                                .padding()
                                        )
                                        .opacity(0.8)
                                }
                                Button(action: {
                                    // 按鈕 1 的動作
                                }) {
                                    Image("1") // 替換 "button_image_1" 為你的圖片名稱
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("減肥")
                                                .foregroundColor(.black)
                                                .font(.title)
                                                .padding()
                                        )
                                        .opacity(0.8)
                                }
                                Button(action: {
                                    // 按鈕 1 的動作
                                }) {
                                    Image("1") // 替換 "button_image_1" 為你的圖片名稱
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("省錢")
                                                .foregroundColor(.black)
                                                .font(.title)
                                                .padding()
                                        )
                                        .opacity(0.8)
                                }
                                Button(action: {
                                    // 按鈕 1 的動作
                                }) {
                                    Image("1") // 替換 "button_image_1" 為你的圖片名稱
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("放縱")
                                                .foregroundColor(.black)
                                                .font(.title)
                                                .padding()
                                        )
                                        .opacity(0.8)
                                }
                                Button(action: {
                                    // 按鈕 1 的動作
                                }) {
                                    Image("1") // 替換 "button_image_1" 為你的圖片名稱
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("養生")
                                                .foregroundColor(.black)
                                                .font(.title)
                                                .padding()
                                        )
                                        .opacity(0.8)
                                }
                                Button(action: {
                                    // 按鈕 1 的動作
                                }) {
                                    Image("1") // 替換 "button_image_1" 為你的圖片名稱
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("今日推薦")
                                                .foregroundColor(.black)
                                                .font(.title)
                                                .padding()
                                        )
                                        .opacity(0.8)
                                }
                                Button(action: {
                                    // 按鈕 1 的動作
                                }) {
                                    Image("1") // 替換 "button_image_1" 為你的圖片名稱
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text("聽天由命")
                                                .foregroundColor(.black)
                                                .font(.title)
                                                .padding()
                                        )
                                        .opacity(0.8)
                                }
                            }
                            .padding()
                        }
                    }
                               }
                           }
                       }
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(plans.keys.sorted(by: <)), id: \.self) { day in
                    Section(header:
                        HStack {
                            Text(day).font(.title)
                            Text(getDayLabelText(for: day)) // 顯示 "第一天" 到 "第七天" 的文本
                            Spacer()
                            Button(action: {
                                plans[day]?.append("新計畫")
                            }) {
                                Image(systemName: "plus.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }
                        }
                    ) {
                        if let dayPlans = plans[day] {
                            ForEach(dayPlans.indices, id: \.self) { index in
                                let plan = dayPlans[index]
                                NavigationLink(destination: EditPlanView(day: day, planIndex: index, plans: $plans)) {
                                    Text(plan).font(.headline)
                                }
                            }
                            .onDelete { indices in
                                plans[day]?.remove(atOffsets: indices)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("週計畫")
        }
    }
    
    // 根據日期獲取 "第一天" 到 "第七天" 的文本
    private func getDayLabelText(for date: String) -> String {
        guard let index = Array(plans.keys.sorted(by: <)).firstIndex(of: date) else {
            return ""
        }
        let dayNumber = (index % 7) + 1
        return "第\(dayNumber)天"
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}
