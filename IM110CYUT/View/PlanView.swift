import SwiftUI

struct PlanView: View
{
    // 保存所有七天的計畫
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

    var body: some View
    {
        NavigationStack
        {
            List
            {
                ForEach(Array(plans.keys.sorted(by: <)), id: \.self)
                { day in
                    Section(header:
                        HStack
                            {
                            Text(day).font(.title)
                            Spacer()
                            Button(action:
                                    {
                                // 新增計畫
                                plans[day]?.append("New Plan")
                            }) {
                                Image(systemName: "plus.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }
                        }
                    ) {
                        ForEach(plans[day]!.sorted(), id: \.self)
                        { plan in
                            NavigationLink(destination: EditPlanView(day: day, plan: plan, plans: $plans)) {
                                Text(plan).font(.headline)
                            }
                        }
                        .onDelete
                        { indices in
                            plans[day]?.remove(atOffsets: indices)
                        }
                        .onMove
                        { indices, newOffset in
                            plans[day]?.move(fromOffsets: indices, toOffset: newOffset)
                        }
                    }
                }
            }
            .navigationBarTitle("Meal Plans")
            .navigationBarItems(trailing:
                EditButton()
            )
        }
    }
}

struct EditPlanView: View
{
    var day: String
    @State var plan: String  // 使用 @State 來追蹤 TextField 的值
    @Binding var plans: [String: [String]]

    var body: some View
    {
        VStack
        {
            Text("Edit Plan for \(day)")
                .font(.title)

            TextField("Enter Plan", text: $plan)

            Button("Save")
            {
                // 更新計畫
                if let index = plans[day]?.firstIndex(of: plan)
                {
                    plans[day]?[index] = plan
                }
            }
            .padding()
        }
        .padding()
    }
}

struct PlavView_Previews: PreviewProvider
{
    static var previews: some View
    {
        PlanView()
    }
}
