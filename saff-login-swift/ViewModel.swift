//
//  ViewModel.swift
//  saff-login-swift
//
//  Created by 7up ‘ on 07/03/1444 AH.
//

import SwiftUI
import LocalAuthentication
import SwiftKeychainWrapper
import CoreLocation

class ViewModel: NSObject, ObservableObject {
    
    static let shared = ViewModel()
    
    private let locationManager = CLLocationManager()
    
    @Published public var saffLocation: CLLocation = .init(latitude: 24.830718089079713, longitude: 46.63728652666813)
    @Published public var userLocation: CLLocation?
    
    @Published public var showingWrongCredentialsAlert: Bool = false
    @Published public var showingNotInLocationAlert: Bool = false
    
    @Published public var loggedIn: Bool = false
    
    @Published public var username: String = ""
    @Published public var password: String = ""
    
    @AppStorage("biometricsEnabled") public var biometricsEnabled: Bool = false
    
    public func login() {
        if username != "saff" || password != "saff" {
            DispatchQueue.main.async {
                self.showingWrongCredentialsAlert.toggle()
                self.username = ""
                self.password = ""
            }
        } else {
            DispatchQueue.main.async {
                self.loggedIn = true
                self.username = ""
                self.password = ""
                self.startLocationUpdate()
            }
        }
    }
    
    public func biometricsLogin() {
        DispatchQueue.main.async {
            BiometricsManager.shared.authenticateWithBiometrics { success, error in
                if success {
                    if let credentials = KeyChainStorage.getCredentials() {
                        DispatchQueue.main.async {
                            self.username = credentials.username ?? ""
                            self.password = credentials.password ?? ""
                            self.login()
                        }
                        
                    }
                }
            }
        }
    }
    
    public func logout() {
        loggedIn = false
    }
    
    public func enableBiometrics() {
        BiometricsManager.shared.authenticateWithBiometrics { success, error in
            if success {
                let credentials = Credentials(username: self.username, password: self.password)
                KeyChainStorage.saveCredentials(credentials: credentials)
                self.biometricsEnabled = true
            }
        }
    }
    
    public func punchIn() {
        guard let distance = calcDistance() else {
            return
        }
        if distance <= 10 {
            print("punched in")
        } else {
            print("too big")
            showingNotInLocationAlert.toggle()
        }
    }
    
    public func punchOut() {
        guard let distance = calcDistance() else {
            return
        }
        print(distance)
        if distance <= 10 {
            print("punched put")
        } else {
            print("too big")
            showingNotInLocationAlert.toggle()
        }
    }
    
    public func calcDistance() -> Double? {
        guard let userLocation = userLocation else {
            return nil
        }
        return saffLocation.distance(from: userLocation)
    }
    
}

struct KeyChainStorage {
    
    static var key = "credentials"
    
    static func getCredentials() -> Credentials? {
        if let credentials = KeychainWrapper.standard.string(forKey: key) {
            return Credentials.decode(credentials: credentials)
        }
        return nil
    }
    static func saveCredentials(credentials: Credentials) {
        KeychainWrapper.standard.set(credentials.encode(), forKey: key)
    }
}

extension ViewModel: CLLocationManagerDelegate {
    
    func startLocationUpdate() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var statusString: String = ""
        switch status {
        case .notDetermined: statusString = "notDetermined"
        case .restricted: statusString = "restricted"
        case .denied: statusString = "denied"
        case .authorizedAlways: statusString = "authorizedAlways"
        case .authorizedWhenInUse: statusString = "authorizedWhenInUse"
        case .authorized: statusString = "authorized"
        default: statusString = "other"
        }
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        print(#function, location)
    }
}
