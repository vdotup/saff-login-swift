//
//  Extensions.swift
//  saff-login-swift
//
//  Created by 7up ‘ on 07/03/1444 AH.
//

import SwiftUI
import CoreLocation

extension Color {
    static let saffGreen = Color.init(red: 16/255, green: 99/255, blue: 55/255, opacity: 1)
}

extension CLLocation {
    func string() -> String {
        return self.coordinate.latitude.formatted() + ", " + self.coordinate.longitude.formatted()
    }
}
