//
//  Forum.swift
//  
//
//
//

import Foundation

//論壇結構
struct Forum: Hashable {
    //ID
    let id: String
    //標題
    let title: String
    //內容
    let text: String
    //隱私
    let secure: Bool
    //作者
    let author: String
}
