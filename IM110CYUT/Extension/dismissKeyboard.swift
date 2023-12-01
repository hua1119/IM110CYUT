//
//  dismissKeyboard.swift
//  IM110CYUT
//
//  Created by Ｍac on 2023/11/26.
//

import SwiftUI

extension View
{
    func dismissKeyboard()
    {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
