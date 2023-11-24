//
//  BMIView.swift
//  Graduation_Project
//
//  Created by Mac on 2023/8/24.
//
import SwiftUI
import Charts

//BMI紀錄

struct BMIRecord: Identifiable
{
    var id = UUID()
    var height: Double
    var weight: Double
    var bmi: Double
    var date: Date
    
    init(height: Double, weight: Double)
    {
        self.height = height
        self.weight = weight
        self.bmi = weight / ((height / 100) * (height / 100))
        self.date = Date()
    }
}


//含ID和BMI相關紀錄數組

struct TemperatureSensor: Identifiable
{
    var id: String
    var records: [BMIRecord]
}

//存取TemperatureSensor[所有]數據

var allSensors: [TemperatureSensor] =
[
    .init(id: "BMI", records: [])
]

struct BMIView: View
{
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var bmiRecords: [BMIRecord] = []
    
    var body: some View
    {
        VStack(spacing: 30)
        {
            //list
            //            ForEach(bmiRecords)
            //            {
            //                record in
            //                HStack
            //                {
            //                    Text("\(record.bmi, specifier: "%.2f")")
            //                    Spacer()
            //                    Text("\(formattedDate(record.date))")
            //                        .foregroundColor(.gray)
            //                }
            //            }
            
            //MARK: 折線圖
            Chart(allSensors)
            {
                sensor in
                
                //依照日期對紀錄進行分組
                let groupedRecords = Dictionary(grouping: sensor.records, by:
                                                    {
                    formattedDate($0.date)
                })
                
                //只保留每天的最新數據
                let latestRecords = groupedRecords.mapValues
                {
                    $0.last!
                }
                
                ForEach(latestRecords.sorted(by: { $0.key < $1.key }), id: \.key)
                {
                    date, record in
                    
                    LineMark(
                        x: .value("Day", date),
                        y: .value("Value", record.bmi)
                    )
                    .lineStyle(.init(lineWidth: 5))
                    
                    PointMark(
                        x: .value("Day", date),
                        y: .value("Value", record.bmi)
                    )
                    .annotation(position: .top)
                    {
                        Text("\(record.bmi, specifier: "%.2f")")
                            .font(.system(size: 12))
                            .foregroundColor(Color("textcolor"))
                    }
                }
                
                // 使用 sensor.id
                .foregroundStyle(by: .value("Location", sensor.id))
                // 使用 sensor.id
                .symbol(by: .value("Sensor Location", sensor.id))
                .symbolSize(100)
            }
            .chartForegroundStyleScale([
                "BMI":.orange
            ])
            .frame(width: 300, height: 200)
            
            
            //MARK: BMI計算
            
            Text("BMI計算")
                .font(.system(size: 20, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .foregroundColor(Color("textcolor"))
            
            //MARK: 使用者輸入And送出區塊
            
            VStack(spacing: -5)
            {
                TextField("請輸入身高（公分）", text: $height)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                //只允許輸入數字
                    .keyboardType(.numberPad)
                    .frame(width: 330)
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification))
                {
                    _ in
                    //輸入非數字，會幫你直接清空
                    height = height.filter
                    {
                        "0123456789.".contains($0)
                    }
                }
                
                TextField("請輸入體重（公斤）", text: $weight)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                //只允許輸入數字
                    .keyboardType(.numberPad)
                    .frame(width: 330)
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification))
                {
                    _ in
                    //輸入非數字，會幫你直接清空
                    weight = weight.filter { "0123456789.".contains($0)
                    }
                }
            }
            
            Button(action:
                    {
                if let heightValue = Double(height), let weightValue = Double(weight)
                {
                    let newRecord = BMIRecord(height: heightValue, weight: weightValue)
                    
                    if let existingSensorIndex = allSensors.firstIndex(where:
                                                                        {
                        $0.id == "BMI"
                        
                    }) {
                        allSensors[existingSensorIndex].records.append(newRecord)
                    }
                    else
                    {
                        let newSensor = TemperatureSensor(id: "BMI", records: [newRecord])
                        allSensors.append(newSensor)
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
        }
    }
    
    
    //MARK: 日期func
    private func formattedDate(_ date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter.string(from: date)
    }
}

struct BMIView_Previews: PreviewProvider
{
    static var previews: some View
    {
        BMIView()
    }
}
