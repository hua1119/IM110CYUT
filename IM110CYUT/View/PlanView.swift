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

        @State private var editedPlan: String

        @Environment(\.presentationMode) var presentationMode

        init(day: String, planIndex: Int, plans: Binding<[String: [String]]>) {
            self.day = day
            self.planIndex = planIndex
            self._plans = plans
            self._editedPlan = State(initialValue: plans.wrappedValue[day]?[planIndex] ?? "")
        }

        var body: some View {
            VStack {
                Text("Edit Plan for \(day)")
                    .font(.title)

                TextField("Enter Plan", text: $editedPlan)

                Button("Save") {
                    plans[day]?[planIndex] = editedPlan
                    presentationMode.wrappedValue.dismiss() // 关闭当前视图
                }
                .padding()
            }
            .padding()
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(Array(plans.keys.sorted(by: <)), id: \.self) { day in
                    Section(header:
                        HStack {
                            Text(day).font(.title)
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
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}
