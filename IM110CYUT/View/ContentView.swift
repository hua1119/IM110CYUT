//
//  ContentView.swift
//
//
//
//

import SwiftUI

struct ContentView: View {
    //存取登入狀態
    @AppStorage("logIn") private var logIn: Bool=false
    // 切換深淺模式
    @State var isDarkMode: Bool = false
    // TabView選擇的頁面
    @State private var showSide: Bool = false
    // 跟蹤標籤頁
    @State private var select: Int = 0
    @State private var information: Information = Information(name: "vc", gender: "女性", birthday:Date(), height: 161, weight: 50, BMI: 19.68)

    //    @StateObject private var cameraManagerViewModel = CameraManagerViewModel()
        
    
    var body: some View {
//        NavigationStack {
//            //已登入
//            if(self.logIn) {
//                HomeView().transition(.opacity)//原ForumView_231020
//            //未登入
//            } else {
//                SigninView(textselect: .constant(0)).transition(.opacity)
//            }
//        }
//        .ignoresSafeArea(.all)
        ZStack
        {
            TabView(selection: self.$select)
            {
                //                  HomeView(select: self.$select)

                DyenamicView()
                    .tag(0)
                    .tabItem
                {
                    Label("主頁", systemImage: "house.fill")
                }
                //MARK: ForumView
                DynamicView()
                    .tag(1)
                    .tabItem
                {
                    Label("論壇", systemImage: "globe")
                }
                
//                CameraContentView(cameraManagerViewModel: self.cameraManagerViewModel)
                    .tag(2)
                    .tabItem
                {
                    Label("AI", systemImage: "camera")
                }
                
                DynamicView()
                    .tag(3)
                    .tabItem
                {
                    Label("動態", systemImage: "chart.xyaxis.line")
                }
                
                MyView(select: self.$select, information: self.$information)
                    .tag(4)
                    .tabItem
                {
                    Label("設置", systemImage: "gearshape.fill")
                }
            }
            // 點選後的顏色
            .tint(.orange)
            
        }
    }
}
struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationStack {
            ContentView()
        }
    }
}
