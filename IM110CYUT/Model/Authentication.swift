//
//  Authentication.swift
//
//
//
//

import Foundation
import FirebaseAuth

//Firebase Authentication
struct Authentication
{
    private let authentication: Auth //Authentication環境
    
    //MARK: 初始化
    init()
    {
        self.authentication=Auth.auth()
    }
    
    //MARK: 刪除
    func delete() //刪除當前使用者在Authentication的資料
    {
        if let user=self.authentication.currentUser //確認當前使用者有登入
        {
            user.delete() //刪除
        }
    }
    
    //MARK: 登入
    func signin(account: String, password: String, completion: @escaping (Bool, Error?) -> Void) //當前使用者登入
    {
        self.authentication.signIn(withEmail: account, password: password) //登入
        { (_, error) in
            if let error=error
            {
                completion(false, error) //登入失敗 -> (失敗, 錯誤資訊)
            } else {
                completion(true, nil) //登入成功 -> (成功, 空值)
            }
        }
    }
    
    //MARK: 註冊
    func signup(account: String, password: String, completion: @escaping (Bool, Error?) -> Void)
    {
        self.authentication.createUser(withEmail: account, password: password) //註冊
        {(_, error) in
            if let error=error
            {
                completion(false, error) //註冊失敗 -> (失敗, 錯誤資訊)
            } else {
                completion(true, nil) //註冊失敗 -> (成功, 空值)

            }
        }
    }
}

