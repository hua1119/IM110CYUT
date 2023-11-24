//
//  MenuView.swift
//  Graduation_Project
//
//  Created by Mac on 2023/9/13.
//

import SwiftUI

struct MenuView: View
{
    var body: some View
    {
        //滑動功能
        ScrollView
        {
            VStack(spacing: 10)
            {
                // MARK: 資料庫食譜照片
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 240)
                
                // MARK: 資料庫食譜名稱
                Text("番茄炒蛋")
                    .bold()
                    .font(.title)
                    .foregroundColor(.orange)
                
                // MARK: 食材
                HStack
                {
                    Text(String(repeating: "-", count: 4))
                        .font(.system(size: 24))
                    Text("食材")
                        .bold()
                        .font(.system(size: 22))
                    Text(String(repeating: "-", count: 4))
                        .font(.system(size: 24))
                }
                .foregroundColor(.brown)
                
                VStack
                {
                    Text("番茄 2顆")
                        .font(.body)
                        .font(.system(size: 24))
                    Text("雞蛋 1顆")
                        .font(.body)
                        .font(.system(size: 24))
                }
                // MARK: 料理方式
                HStack
                {
                    Text(String(repeating: "-", count: 4))
                        .font(.system(size: 24))
                    
                    Text("步驟")
                        .bold()
                        .font(.system(size: 22))
                    
                    Text(String(repeating: "-", count: 4))
                        .font(.system(size: 24))
                }
                .foregroundColor(.brown)
                
                VStack
                {
                    Text("1.將雞蛋打散加入牛奶和鹽，攪拌均勻，一定要把蛋打散，這樣蛋的口感才會更鮮嫩。")
                        .font(.body)
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 20)
                    
                    Text("5.喜歡口味重的，可以撒上一些黑胡椒，特別注意的是，使用的炒鍋一定要用不沾鍋，不然蛋汁很容易沾黏到鍋上，就容易焦，炒的速度要快，可以輕微攪動蛋汁，最後用鍋的餘溫把雞蛋燜熟。")
                        .font(.body)
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 20)
                    
                    Text("7.淋上芥末醬或番茄醬，依照個人喜歡的都可以。")
                        .font(.body)
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
            }
        }
    }
}


struct MenuView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MenuView()
    }
}
