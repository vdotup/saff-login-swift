//
//  Credentials.swift
//  saff-login-swift
//
//  Created by 7up ‘ on 07/03/1444 AH.
//

import Foundation

struct Credentials: Codable {
    
    var username: String?
    var password: String?
    
    func encode() -> String {
        let encoder = JSONEncoder()
        if let credentials = try? encoder.encode(self) {
            return String(data: credentials, encoding: .utf8) ?? ""
        }
        return ""
    }
    
    static func decode(credentials: String) -> Credentials? {
        let decoder = JSONDecoder()
        guard let jsonData = credentials.data(using: .utf8) else { return nil }
        guard let credentials = try? decoder.decode(Credentials.self, from: jsonData) else { return nil }
        return credentials
    }
}
