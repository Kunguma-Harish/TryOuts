//
//  UserDefaults.swift
//  swiftUITryOut
//
//  Created by kunguma-14252 on 07/04/23.
//
import Foundation

extension UserDefaults {
    static func setItem(item: TabItem) {
        UserDefaults.standard.set(item.rawValue, forKey: "lastSelectedTab")
        print("Kungu : Saved in User Default")
    }
    static func setItem(toggle: Bool, key: String) {
        UserDefaults.standard.set(toggle, forKey: key)
        print("Kungu : Saved in User Default")
    }
    
    static func getItem() -> Int {
        UserDefaults.standard.integer(forKey: "lastSelectedTab")
    }
    
    static func getItem(key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
}

// t1,t2,t3
