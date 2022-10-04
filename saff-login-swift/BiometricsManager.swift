//
//  BiometricsManager.swift
//  saff-login-swift
//
//  Created by 7up ‘ on 07/03/1444 AH.
//

import Foundation
import LocalAuthentication

class BiometricsManager {
    
    static let shared: BiometricsManager = BiometricsManager()
    
    var context = LAContext()
    var error: NSError?
    
    lazy var biometricType: LABiometryType = context.biometryType
    
    var authenticationTypeReason: String {
        switch biometricType {
        case .faceID:
            return "Log in with Face ID"
        case .touchID:
            return "Log in with Touch ID"
        case .none:
            return ""
        @unknown default:
            return ""
        }
    }
    
    func checkForBiometricsPermission(completion: @escaping((Bool) -> Void)) {
        context.localizedCancelTitle = "Enter Username/Password"
        var error: NSError?
        let permission = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        permission ? completion(true) : completion(false)
    }
    
//    func authenticate() {
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "Allow Face ID or Touch ID for faster login."
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
//                guard success, error == nil else {
//                    print("fail")
//                    return
//                }
//
//                print("success")
//                DispatchQueue.main.async {
//                    self.loggedIn = true
//                }
//            }
//        } else {
//            print("can not use")
//        }
//    }
    
    func authenticateWithBiometrics(completion: @escaping((Bool, String?) -> Void)) {
        checkForBiometricsPermission { permission in
            if permission {
                self.context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: self.authenticationTypeReason) { success, error in
                    if success, error == nil {
                        completion(true, nil)
                    } else {
                        if let err = error {
                            completion(false, self.getErrorDetails(error: err as NSError))
                        }
                        else {
                            completion(false, nil)
                        }
                    }
                }
            }
            else {
                completion(false, nil)
            }
        }
    }
    
    private func getErrorDetails(error: NSError) -> String {
        // If error is an instance of LAError
        if let code = LAError.Code(rawValue: error.code) {
            switch code {
            case .appCancel:
                return "Authentication was canceled by application."
            case .authenticationFailed:
                return "Authentication was not successful because user failed to provide valid credentials."
            case .invalidContext:
                return "The LAContext was invalid"
            case .notInteractive:
                return "Authentication failed because it would require showing UI which has been forbidden"
            case .passcodeNotSet:
                return "Authentication could not start because passcode is not set on the device"
            case LAError.Code.systemCancel:
                return "Authentication was canceled by system (e.g. another application went to foreground)"
            case LAError.Code.userCancel:
                return "Authentication was canceled by user (e.g. tapped Cancel button)."
            case LAError.Code.userFallback:
                return "Authentication was canceled because the user tapped the fallback button (Enter Password)."
            case LAError.Code.biometryLockout:
                return "Authentication was not successful because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID"
            case LAError.Code.biometryNotAvailable:
                return "Authentication could not start because Touch ID is not available on the device."
            case LAError.Code.biometryNotEnrolled:
                return "Authentication could not start because Touch ID has no enrolled fingers."
            case .touchIDNotAvailable:
                return "Authentication could not start because Touch ID is not available on the device."
            case .touchIDNotEnrolled:
                return "Authentication could not start because Touch ID has no enrolled fingers."
            case .touchIDLockout:
                return "Authentication was not successful because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID"
            @unknown default:
                return "Unknown Error Occurred"
            }
        }
        return "Unknown Error Occurred"
    }
    
    private init() {}
}


