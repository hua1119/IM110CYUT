//
//  SpinnerView.swift
//  Graduation_Project
//
//  Created by Mac on 2023/10/27.
//


import SwiftUI

struct TrianglePointer: View
{
    @Binding var selectedFood: String
    
    var body: some View
    {
        Triangle()
            .fill(Color.red)
            .frame(width: 20, height: 50)
        // 調整三角形指針的位置
            .offset(x: 0, y: 580)
            .rotationEffect(.degrees(180))
    }
}


// MARK: 主頁畫面設計

struct SpinnerView: View
{
    // 存儲轉盤的當前角度，在開始轉的時候此數字會增加
    @State private var rotationAngle: Double = 1.0
    // 控制是否應該重置轉盤的狀態
    @State private var shouldResetRotation = false
    // 指示立即重置轉盤的狀態，初始設置為 false，當設置為 true 時，立即觸發轉盤的重置
    @State private var resetRotationNow = false
    // 用於控制旋轉按鈕是否可用，初始設置為 true，當按下旋轉按鈕時，設置為 false 以禁用按鈕
    @State private var isButtonEnabled = true
    // 用於控制彈出視窗是否顯示
    @State private var isShowingAlert = false
    // 用於控制轉盤是否正在旋轉，在開始旋轉時設置為true
    @State private var isRotating = false
    // 用於存儲選定的食物名稱，初始設置為空字符串，當轉盤選定一個食物時，它會被更新為該食物的名稱
    @State private var selectedFood = ""
    @Environment(\.presentationMode) var presentationMode
    
    // 用來判斷跟存放目前有幾項食物
    let foodNames = ["披薩", "漢堡", "壽司", "義大利麵", "沙拉", "牛排", "吐司", "冰淇淋", "魚排", "麵線", "雞塊", "蛋糕"]
    
    
    var body: some View
    {
        VStack
        {
            
            Text("食物轉盤")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.orange)
                .fontWeight(.bold)
                .shadow(color: .gray, radius: 0, x: 0, y: 3)
            
            // 這段是定義指令，且無法更改位置，會影響版面
            OrangeWhiteSpinner(isRotating: $isRotating, stopRotation: $isRotating, selectedFood: $selectedFood, rotationAngle: $rotationAngle)
            
            Button(action: { isButtonEnabled = false; startRotation() })
            {
                Text("旋轉")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            // 根據狀態變量禁用按鈕
            .disabled(!isButtonEnabled)
            .padding()
            //三角形指針的呈現與判斷
            TrianglePointer(selectedFood: $selectedFood)
        }
        
        // 彈出視窗
        .alert(isPresented: $isShowingAlert)
        {
            Alert(
                title: Text("選擇的食物是："),
                message: Text(selectedFood),
                dismissButton: .default(Text("關閉"))
                {
                    // 在按下關閉按鈕時執行的操作
                    // 啟用按钮
                    isButtonEnabled = true
                    // 切換 resetRotationNow 為 true，觸發重置
                    resetRotationNow.toggle()
                    // 重置轉盤
                    rotationAngle = 0
                    // 動畫完成後設置為 false，以便下次可以再次執行動畫
                    self.isRotating = false
                }
            )
            
        }
       
    }
    
    // MARK: 動畫與圈數設置
    func startRotation()
    {
        // 設置的圈數角度介於1000~3000，之後會因為下方的計算而加大，這些只是基礎值
        let randomRotation = Double.random(in: 1000...3000)
        
        // 動畫結束的秒數，目前設置5秒
        withAnimation(.easeInOut(duration: 5.0))
        {
            self.rotationAngle += 3600 + randomRotation
            self.isRotating.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0)
        {
            let detectedFood = self.foodNameForAngle(self.rotationAngle + 180)
            print("Current Angle: \(self.rotationAngle)")
            self.selectedFood = detectedFood
            
            // 在選定食物後設定 isShowingAlert 為 true，觸發彈出視窗的顯示
            self.isShowingAlert =  true
        }
    }
    
    private func foodNameForAngle(_ angle: Double) -> String
    {
        let angleIncrement = 360.0 / Double(foodNames.count)
        let normalizedAngle = (angle + 360.0).truncatingRemainder(dividingBy: 360.0)
        let index = Int(normalizedAngle / angleIncrement)
        
        if index >= 0 && index < foodNames.count
        {
            return foodNames[index]
        }
        else
        {
            return "Unknown"
        }
    }
}

// MARK: 動畫內容程式
struct OrangeWhiteSpinner: View
{
    @Binding var isRotating: Bool
    // 接收停止旋轉的狀態
    @Binding var stopRotation: Bool
    @Binding var selectedFood: String
    @Binding var rotationAngle: Double
    
    // 讀取食物內容
    let foodNames = ["披薩", "漢堡", "壽司", "義大利麵", "沙拉", "牛排", "吐司", "冰淇淋", "麥當當", "麵線", "雞塊", "蛋糕"]
    
    // 食物位置角度計算
    private func angleForSelectedFood() -> Angle
    {
        let angleIncrement = 360.0 / Double(foodNames.count)
        if let selectedIndex = foodNames.firstIndex(of: selectedFood)
        {
            let angle = Angle(degrees: Double(selectedIndex) * angleIncrement)
            return angle
        }
        return .zero
    }
    
    var body: some View
    {
        // 轉盤格數
        let numberOfItems = 12
        let angleIncrement = 360  / Double(numberOfItems)
        
        // 判斷圈數
        func foodNameForAngle(_ angle: Angle) -> String
        {
            let angleIncrement = 360.0 / Double(foodNames.count)
            let normalizedAngle = (angle.degrees + 360.0).truncatingRemainder(dividingBy: 360.0)
            let index = Int(normalizedAngle / angleIncrement)
            
            if index >= 0 && index < foodNames.count
            {
                return foodNames[index]
            }
            else
            {
                return "Unknown"
            }
        }
        
        return ZStack
        {
            // 轉盤呈現樣式
            Circle()
                .fill(Color.orange)
                .overlay(Circle().stroke(Color.black, lineWidth: 5))
                .rotationEffect(angleForSelectedFood())
            
            
            ForEach(0..<12)
            { index in
                let angle = Angle(degrees: Double(index) * angleIncrement)
                let color = index % 2 == 0 ? Color.orange : Color.white
                
                // 硬文字樣式，這裡有很大的改正空間，假如增加格數後，這些字就無法再使用
                SwiftUI.Group
                {
                    Text("義大利麵")
                        .rotationEffect(.degrees(80))
                        .offset(x:150, y: -40)
                        .zIndex(1)
                    Text("沙拉")
                        .rotationEffect(.degrees(45))
                        .offset(x: 110, y: -110)
                    Text("吐司")
                        .rotationEffect(.degrees(-15))
                        .offset(x: -40, y: -150)
                    Text("牛排")
                        .rotationEffect(.degrees(20))
                        .offset(x: 40, y: -150)
                    Text("冰淇淋")
                        .rotationEffect(.degrees(-45))
                        .offset(x:-110, y: -110)
                    Text("麵線")
                        .rotationEffect(.degrees(-105))
                        .offset(x:-150, y: 40)
                    Text("雞塊 ")
                        .rotationEffect(.degrees(-135))
                        .offset(x: -110, y: 110)
                    Text("魚排")
                        .rotationEffect(.degrees(-70))
                        .offset(x:-150, y: -40)
                    Text("蛋糕")
                        .rotationEffect(.degrees(195))
                        .offset(x: -40, y: 150)
                    Text("披薩")
                        .rotationEffect(.degrees(165))
                        .offset(x: 40, y: 150)
                }
                Text("漢堡")
                    .rotationEffect(.degrees(140))
                    .offset(x:110, y: 110)
                Text("壽司")
                    .rotationEffect(.degrees(105))
                    .offset(x:150, y: 40)
                FanShape(startAngle: angle, endAngle: Angle(degrees: angle.degrees + angleIncrement))
                    .foregroundColor(color)
            }
            .foregroundColor(Color.black)
            .rotationEffect(.degrees(isRotating ? rotationAngle : 0))
        }
    }
}

// MARK: 定義圓型樣式
struct FanShape: Shape
{
    // 起始角度
    var startAngle: Angle
    // 結束角度
    var endAngle: Angle
    
    // 定義形狀在指定矩形區域的路徑
    func path(in rect: CGRect) -> Path
    {
        var path = Path()
        // 將路徑的起點設置為矩形中心
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        // 添加一個以矩形中心為中心、半徑為矩形寬度一半的扇形
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        // 封閉路徑，形成一個完整的扇形
        path.closeSubpath()
        return path
    }
}

// MARK: 三角形的定義，與指針指向食物的判斷方式有關聯
struct Triangle: Shape
{
    // 定義形狀在指定矩形區域的路徑
    func path(in rect: CGRect) -> Path
    {
        var path = Path()
        // 移動到三角形的起點，位於矩形的上中心
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        // 添加一條線到矩形的左下角
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        // 再添加一條線到矩形的右下角
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // 封閉路徑，形成一個完整的三角形
        path.closeSubpath()
        return path
    }
}

struct SpinnerView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SpinnerView()
    }
}
