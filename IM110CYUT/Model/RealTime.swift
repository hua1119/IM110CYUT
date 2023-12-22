//
//  RealTime.swift
//
//
//
//

import Foundation
import FirebaseDatabase

//Firebase Realtime
struct RealTime
{
    //Realtime環境
    private let reference: DatabaseReference
    
    //MARK: 初始化
    init()
    {
        self.reference=Database.database().reference()
    }
    //MARK: 刪除
    func deleteUser(id: String) //刪除當前使用者在Realtime中的所有資料
    {
        self.reference
            .child("User") //指定User節點
            .child(id) //指定id節點
            .removeValue() //刪除
    }
    // MARK: 查詢
    func getUser(account: String, completion: @escaping ([String]?, Error?) -> Void)
    {
        var id: String=""
        
        self.getUserID(account: account) //查詢當前使用者在Realtime中的ID
        {(result, error) in
            if let result=result //如果有查到當前使用者ID
            {
                id=result
                self.reference
                    .child("User") //指定User節點
                    .child(id) //指定ID節點
                    .observeSingleEvent(of: .value, with: {data in //查詢該ID節點中的所有資料
                        if let value=data.value as? NSDictionary //將資料轉換成NSDictionary結構 以方便查詢
                        {
                            completion( //存進completion以提供呼叫的View使用

                                [
                                    value["ID"] as! String,
                                    value["Account"] as! String,
                                    value["Password"] as! String,
                                    value ["Name"] as! String ,
                                    value ["gender"] as! String ,
                                    value["birthday"] as! String,
                                    value ["height"] as! String,
                                    value ["weight"] as! String,
                                    value ["like1"] as! String,
                                    value ["like2"] as! String,
                                    value ["like3"] as! String,
                                    value ["like4"] as! String
                                ],
                                nil //錯誤為空值
                            )
                        }
                    }) {error in
                        completion(nil, error) //查詢失敗 -> (空值, 錯誤資訊)
                    }
            } else if let error=error //查詢失敗 -> (空值, 錯誤資訊)
            {
                completion(nil, error)
            }
        }
    }
    // MARK: 查詢ID
    func getUserID(account: String, completion: @escaping (String?, Error?) -> Void)
    {
        self.reference
            .child("User") //指定User節點
            .getData {(error, result) in //取得當前節點中的所有資料
                if let result=result  //如果有查到資料
                {
                    // MARK: 遍歷資料中的所有節點中的所有資料
                    for i in result.children.allObjects
                    {
                        //將當前資料轉換成String結構 以方便操作
                        var describe: String=String(describing: i)
                        if(describe.contains(account)) //如果當前資料中，存在當前使用者的帳號
                        {
                            describe=String(describe[describe.firstIndex(of: "(")!..<describe.firstIndex(of: ")")!]) //切割字串擷取出使用者的ID
                            describe=describe[1..<describe.count] //切割字串擷取出使用者的ID
                            completion(describe, nil) //存進completion以提供呼叫的View使用
                        }
                    }
                } else if let error=error //查詢失敗 -> (空值, 錯誤資訊)
                {
                    completion(nil, error)
                }
            }
    }
    // MARK: 註冊
    func signup(account: String, password: String, name: String, gender: String, birthday: String, height: String, weight: String ,like1: String,like2: String,like3: String,like4: String)
    {
        let id: String=UUID().uuidString //隨機產生ID
        self.reference
            .child("User") //指定User節點
            .child(id) //指定ID節點
        
        // MARK: 寫入ID資料 Account資料 Password資料 Name資料
            .setValue(["ID": id, "Account": account, "Password": password, "Name": name,"gender": gender,"birthday":birthday,"height": height,"weight": weight, "like1":like1, "like2":like2, "like3":like3, "like4":like4]) {(error, success) in
                
                if let error=error //寫入失敗
                {
                    print("Realtime sign up error: \(error.localizedDescription)")
                } else{ //寫入成功
                    print("Realtime sign up success.")
                }
            }
    }
    
    // MARK: 修改姓名
    func updateUserNameAndDelete(id: String, name: String, completion: @escaping () -> Void)
    {
        self.reference
            .child("User")
            .child(id)
            .child("Name")
            .setValue(name)
        {(error, reference) in
            if let error
            {
                print(error.localizedDescription)
            }
            completion()
        }
    }
}
