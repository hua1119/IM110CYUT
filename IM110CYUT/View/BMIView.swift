import SwiftUI
import Charts

class BMIRecordViewModel: ObservableObject {
    @Published var bmiRecords: [BMIRecord]

    init(bmiRecords: [BMIRecord] = []) {
        self.bmiRecords = bmiRecords
    }
}

class TemperatureSensorViewModel: ObservableObject {
    @Published var allSensors: [TemperatureSensor]

    init(allSensors: [TemperatureSensor] = []) {
        self.allSensors = allSensors
    }
}

struct BMIRecord: Identifiable {
    var id = UUID()
    var height: Double
    var weight: Double
    var bmi: Double
    var date: Date

    init(height: Double, weight: Double) {
        self.height = height
        self.weight = weight
        self.bmi = weight / ((height / 100) * (height / 100))
        self.date = Date()
    }
}

struct TemperatureSensor: Identifiable {
    var id: String
    var records: [BMIRecord]
}

var allSensors: [TemperatureSensor] = [
    .init(id: "BMI", records: [])
]

private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd"
    return formatter.string(from: date)
}

struct BMIView: View {
    @State private var height: String = ""
    @State private var weight: String = ""

    @ObservedObject private var bmiRecordViewModel = BMIRecordViewModel()
    @ObservedObject private var temperatureSensorViewModel = TemperatureSensorViewModel(allSensors: [TemperatureSensor(id: "BMI", records: [])])

    @State private var isShowingList: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 30) {
                        Chart(temperatureSensorViewModel.allSensors) { sensor in
                            let groupedRecords = Dictionary(grouping: sensor.records, by: { formattedDate($0.date) })
                            let latestRecords = groupedRecords.mapValues { $0.last! }

                            ForEach(latestRecords.sorted(by: { $0.key < $1.key }), id: \.key) { date, record in
                                LineMark(
                                    x: .value("Day", date),
                                    y: .value("Value", record.bmi)
                                )
                                .lineStyle(.init(lineWidth: 5))

                                PointMark(
                                    x: .value("Day", date),
                                    y: .value("Value", record.bmi)
                                )
                                .annotation(position: .top) {
                                    Text("\(record.bmi, specifier: "%.2f")")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color("textcolor"))
                                }
                            }

                            .foregroundStyle(by: .value("Location", sensor.id))
                            .symbol(by: .value("Sensor Location", sensor.id))
                            .symbolSize(100)
                        }
                        .chartForegroundStyleScale(["BMI": .orange])

                        .frame(width: 350, height: 200)
                    }
                    .padding()
                }

                VStack(spacing: 10) {
                    Text("BMI計算")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .foregroundColor(Color("textcolor"))

                    VStack(spacing: -5) {
                        TextField("請輸入身高（公分）", text: $height)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 330)
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { _ in
                                height = height.filter { "0123456789.".contains($0) }
                            }

                        TextField("請輸入體重（公斤）", text: $weight)
                            .padding()
                            .offset(y: 0)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 330)
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { _ in
                                weight = weight.filter { "0123456789.".contains($0) }
                            }
                    }

                    Button(action: {
                        if let heightValue = Double(height), let weightValue = Double(weight) {
                            let newRecord = BMIRecord(height: heightValue, weight: weightValue)
                            bmiRecordViewModel.bmiRecords.append(newRecord)

                            if let existingSensorIndex = temperatureSensorViewModel.allSensors.firstIndex(where: { $0.id == "BMI" }) {
                                temperatureSensorViewModel.allSensors[existingSensorIndex].records.append(newRecord)
                            } else {
                                let newSensor = TemperatureSensor(id: "BMI", records: [newRecord])
                                temperatureSensorViewModel.allSensors.append(newSensor)
                            }

                            height = ""
                            weight = ""
                        }
                    }) {
                        Text("計算BMI")
                            .foregroundColor(Color("textcolor"))
                            .padding(10)
                            .frame(width: 300, height: 50)
                            .background(Color(hue: 0.031, saturation: 0.803, brightness: 0.983))
                            .cornerRadius(100)
                            .font(.title3)
                    }
                    .padding()
                    .offset(y: -20)
                    .navigationTitle("BMI紀錄")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isShowingList.toggle()
                            }) {
                                Image(systemName: "list.dash")
                                    .font(.title)
                                    .foregroundColor(Color(hue: 0.031, saturation: 0.803, brightness: 0.983))
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingList) {
                        BMIRecordsListView(records: $bmiRecordViewModel.bmiRecords, temperatureSensorViewModel: temperatureSensorViewModel)
                    }
                }
            }
        }
    }
}

struct BMIRecordsListView: View {
    @Binding var records: [BMIRecord]
    @ObservedObject var temperatureSensorViewModel: TemperatureSensorViewModel

    init(records: Binding<[BMIRecord]>, temperatureSensorViewModel: TemperatureSensorViewModel) {
        self._records = records
        self.temperatureSensorViewModel = temperatureSensorViewModel
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(records) { record in
                    NavigationLink(destination: BMIRecordDetailView(record: record)) {
                        Text("\(formattedDate(record.date)): \(record.bmi, specifier: "%.2f")")
                    }
                }
                .onDelete(perform: deleteRecord)
            }
            .navigationTitle("BMI紀錄列表")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    // 刪除
    private func deleteRecord(at offsets: IndexSet) {
        records.remove(atOffsets: offsets)

        // 更新TemperatureSensor的records
        if let sensorIndex = temperatureSensorViewModel.allSensors.firstIndex(where: { $0.id == "BMI" }) {
            temperatureSensorViewModel.allSensors[sensorIndex].records = records
        }
    }
}

struct BMIRecordDetailView: View {
    var record: BMIRecord

    var body: some View {
        VStack {
            Text("身高: \(record.height) 公分")
            Text("體重: \(record.weight) 公斤")
            Text("你的BMI為: \(record.bmi)")

            Text("BMI分類: \(bmiCategory)")
                .foregroundColor(categoryColor)
                .font(.headline)
        }
        .navigationTitle("BMI 詳細資訊")
    }

    private var bmiCategory: String {
        switch record.bmi {
        case ..<18.5:
            return "過瘦"
        case 18.5..<24:
            return "標準"
        case 24..<27:
            return "過重"
        case 27..<30:
            return "輕度肥胖"
        case 30..<35:
            return "中度肥胖"
        default:
            return "重度肥胖"
        }
    }

    private var categoryColor: Color {
        switch record.bmi {
        case ..<18.5:
            return .blue
        case 18.5..<24:
            return .green
        case 24..<27:
            return .yellow
        case 27..<30:
            return .orange
        case 30..<35:
            return .orange
        default:
            return .red
        }
    }
}


struct BMIView_Previews: PreviewProvider {
    static var previews: some View {
        BMIView()
    }
}
