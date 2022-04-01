//
//  Dictionary+Extension.swift
//  Tenant
//
//  Created by samsha on 2021/2/9.
//

import Foundation

public extension Dictionary {
    func toJson() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []), let str = String(data: data, encoding: String.Encoding.utf8) else { return "" }
        return str
    }
}
