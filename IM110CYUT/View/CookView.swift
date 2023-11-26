//
//  CookView.swift
//  IM110CYUT
//
//  Created by Ｍac on 2023/11/26.
//

import SwiftUI

struct Plan {
    var day: Int
    var title: String
}

struct CookView: View {
    @State private var fakePlans: [Plan] = []

    init() {
        let numberOfDishes = (1...7).map { _ in Int.random(in: 1...3) }
        var plans: [Plan] = []
        for (index, count) in numberOfDishes.enumerated() {
            for dishIndex in 1...count {
                plans.append(Plan(day: index + 1, title: "料理\(dishIndex)"))
            }
        }
        _fakePlans = State(initialValue: plans)
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: AdjustView()) {
                        Text("調整計畫")
                            .padding()
                    }
                }

                List {
                    ForEach(0..<7, id: \.self) { dayIndex in
                        VStack(alignment: .leading, spacing: 10) {
                            let currentDate = Calendar.current.dateComponents([.month, .day], from: Date())
                            if let firstPlan = fakePlans.first(where: { $0.day == dayIndex + 1 }) {
                                if let targetDate = Calendar.current.date(byAdding: .day, value: dayIndex, to: Date()) {
                                    let targetDateComponents = Calendar.current.dateComponents([.month, .day], from: targetDate)
                                    Text("\(targetDateComponents.month ?? 0)/\(targetDateComponents.day ?? 0) 第 \(dayIndex + 1) 天")
                                        .font(.headline)
                                        .padding(.bottom, 5)
                                }
                            }

                            ForEach(fakePlans.filter { $0.day == dayIndex + 1 }, id: \.day) { plan in
                                Text("- \(plan.title)")
                                    .padding(.leading, 20)
                            }
                        }
                    }
                }
                .padding(.top, -20)
                .scrollIndicators(.hidden)

                Button(action: {
                    // 實現 "立即煮" 功能
                }) {
                    Text("立即煮")
                        .padding()
                }
            }
        }
    }
}

struct CookView_Previews: PreviewProvider {
    static var previews: some View {
        CookView()
    }
}
