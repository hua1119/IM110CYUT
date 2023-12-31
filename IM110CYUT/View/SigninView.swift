//
//  SigninView.swift
//  IM110CYUT
//
//  Created by Ｍac on 2023/11/24.
//

// MARK: 登入View
import SwiftUI

// MARK: 登入
struct SigninView: View
{
    @AppStorage("signin") private var signin: Bool=false //存取登入狀態

    @State private var result: (Bool, String)=(false, "") //執行結果Alert
    @State private var information: (String, String)=("", "") //帳號密碼
    @State private var forget: Bool=false //開啟「忘記密碼」的狀態
    @State private var remember: Bool=false //手機儲存「記住我」狀態，之後要改

    @EnvironmentObject private var user: User //提供所有View使用的User結構

    
    // MARK: 使用者登入
    private func signIn() async
    {
        // Authentication
        Authentication().signin(account: self.information.0, password: self.information.1)
        { (_, error) in
            if let error = error //登入失敗

            {
                self.result.1 = error.localizedDescription
                self.result.0.toggle()
            } else
            {
                // Realtime Database
                RealTime().getUser(account: self.information.0)
                { (result, error) in
                    if let result = result //登入成功回傳的使用者資料
                    {
                        let dateFormatter = DateFormatter() //格式化生日日期字符串為日期
                        dateFormatter.dateFormat = "yyyy-MM-dd" //根據你的日期格式调整
                        
                        // MARK: 存進User
                        self.user.setUser(
                            id: result[0],
                            account: result[1],
                            password: result[2],
                            name: result[3],
                            gender: result[4],
                            birthday: result[5] ?? "", //使用轉換後的日期對象
                            height: result[6],
                            weight: result[7],
                            like1: result[8],
                            like2: result[9],
                            like3: result[10],
                            like4: result[11]
                        )
                        self.result.1 = "歡迎! \(self.user.name)"
                        self.result.0.toggle()
                        self.signin=true
//                        if dateFormatter.date(from: result[5]) != nil {
//
//                        } else {
//                            // 日期格式不匹配，处理错误
//                            self.result.1 = "日期格式不匹配"
//                            self.result.0.toggle()
//                        }
                        
                    }
                    else if let error = error  //登入失敗
                    {
                        self.result.1 = error.localizedDescription
                        self.result.0.toggle()
                    }
                }
            }
        }
    }

    
    var body: some View
    {
        NavigationStack
        {
            if(self.signin)
            {
                
                ContentView().transition(.opacity)
            }
            else
            {
                VStack(spacing: 20)
                {
                    //MARK: logo
//                                        Image("bitter")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 150)
//                                            .background(.gray)
//                                            .clipShape(Circle())
//                                            .padding(.bottom, 50)
//                    
                    Circle()
                        .fill(.gray)
                        .scaledToFit()
                        .frame(width: 150)
                        .padding(.bottom, 50)
                    
                    VStack(spacing: 30)
                    {
                        // MARK: 帳號
                        TextField("帳號...", text: self.$information.0)
                            .scrollContentBackground(.hidden)
                            .padding()
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                        
                        // MARK: 密碼
                        SecureField("密碼...", text: self.$information.1)
                            .scrollContentBackground(.hidden)
                            .padding()
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                    }
                    .font(.title3)
                    
                    NavigationLink(destination:SignupView(textselect: .constant(0)))
                    {
                        Text("尚未註冊嗎？請點擊我")
                            .font(.body)
                            .foregroundColor(Color(red: 0.574, green: 0.609, blue: 0.386))
                            .colorMultiply(.gray)
                    }
                    HStack
                    {
                        // MARK: 記住我
                        HStack
                        {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 20)
                                .overlay
                            {
                                Circle()
                                    .fill(.blue)
                                    .padding(5)
                                    .opacity(self.remember ? 1:0)
                            }
                            .onTapGesture
                            {
                                withAnimation(.easeInOut)
                                {
                                    self.remember.toggle()
                                }
                            }
                            
                            Text("記住我").font(.callout)
                        }
                        
                        Spacer()
                        
                        // MARK: 忘記密碼
                        Button("忘記密碼？")
                        {
                            self.forget.toggle()
                        }
                        .font(.callout)
                    }
                    .sheet(isPresented: self.$forget)
                    {
                        ForgetPasswordView()
                            .presentationDetents([.medium])
                            .presentationCornerRadius(30)
                    }
                    // MARK: 登入
                    Button
                    {
                        Task {
                            await self.signIn() //登入
                        }
                    }
                label:
                    {
                        Text("登入")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.828, green: 0.249, blue: 0.115))
                            .clipShape(Capsule())
                    }
                    
                    // MARK: Circle
                    HStack
                    {
                        ForEach(0..<3)
                        {index in
                            Circle()
                                .fill(Color(.systemGray3))
                                .scaledToFit()
                                .frame(height: 50)
                            
                            if(index<2)
                            {
                                Spacer()
                            }
                        }
                    }
                }
                .onTapGesture {
                    self.dismissKeyboard()
                }
                .padding(.horizontal, 50)
                .transition(.opacity)
                .ignoresSafeArea(.keyboard)
            }
                
        }
        // MARK: 結果Alert
        .alert(self.result.1, isPresented: self.$result.0)
        {
            Button("完成", role: .cancel)
            {
                if(self.result.1.hasPrefix("歡迎"))
                {
                    withAnimation(.easeInOut.speed(2))
                    {
                        self.signin=true
                    }
                }
            }
        }
    }
        
}
    


struct SigninView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SigninView()
    }
}
