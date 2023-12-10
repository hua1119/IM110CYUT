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
    //刪除當前使用者在Realtime中的所有資料
    func deleteUser(id: String)
    {
        self.reference
        //指定User節點
            .child("User")
        //指定id節點
            .child(id)
        //刪除
            .removeValue()
    }
    //MARK: 查詢
    func getUser(account: String, completion: @escaping ([String]?, Error?) -> Void)
    {
        var id: String=""
        
        //查詢當前使用者在Realtime中的ID
        self.getUserID(account: account) {(result, error) in
            //有查到當前使用者ID
            if let result=result
            {
                id=result
                self.reference
                //指定User節點
                    .child("User")
                //指定ID節點
                    .child(id)
                //查詢該ID節點中的所有資料
                    .observeSingleEvent(of: .value, with: {data in
                        //將資料轉換成NSDictionary結構 以方便查詢
                        if let value=data.value as? NSDictionary
                        {
                            //存進completion以提供呼叫的View使用
                            completion(
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
                                //錯誤為空值
                                nil
                            )
                        }
                    }) {error in
                        //查詢失敗 -> (空值, 錯誤資訊)
                        completion(nil, error)
                    }
            } else if let error=error{
                //查詢失敗 -> (空值, 錯誤資訊)
                completion(nil, error)
            }
        }
    }
    //MARK: 查詢ID
    func getUserID(account: String, completion: @escaping (String?, Error?) -> Void)
    {
        self.reference
        //指定User節點
            .child("User")
        //取得當前節點中的所有資料
            .getData {(error, result) in
                //有查到資料
                if let result=result
                {
                    //遍歷資料中的所有節點中的所有資料
                    for i in result.children.allObjects
                    {
                        //將當前資料轉換成String結構 以方便操作
                        var describe: String=String(describing: i)
                        //當前資料中 存在當前使用者的帳號
                        if(describe.contains(account))
                        {
                            //切割字串擷取出使用者的ID
                            describe=String(describe[describe.firstIndex(of: "(")!..<describe.firstIndex(of: ")")!])
                            //切割字串擷取出使用者的ID
                            describe=describe[1..<describe.count]
                            //存進completion以提供呼叫的View使用
                            completion(describe, nil)
                        }
                    }
                } else if let error=error{
                    //查詢失敗 -> (空值, 錯誤資訊)
                    completion(nil, error)
                }
            }
    }
    //MARK: 註冊
    func signup(account: String, password: String, name: String, gender: String, birthday: String, height: String, weight: String ,like1: String,like2: String,like3: String,like4: String)
    {
        //隨機產生ID
        let id: String=UUID().uuidString
        self.reference
        //指定User節點
            .child("User")
        //指定ID節點
            .child(id)
        //寫入ID資料 Account資料 Password資料 Name資料
            .setValue(["ID": id, "Account": account, "Password": password, "Name": name,"gender": gender,"birthday":birthday,"height": height,"weight": weight, "like1":like1, "like2":like2, "like3":like3, "like4":like4]) {(error, success) in
                //寫入失敗
                if let error=error
                {
                    print("Realtime sign up error: \(error.localizedDescription)")
                    //寫入成功
                } else{
                    print("Realtime sign up success.")
                }
            }
    }
    //MARK: 修改姓名
    func updateUserNameAndDelete(id: String, name: String, completion: @escaping () -> Void) {
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
