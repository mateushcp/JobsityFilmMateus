//
//  AuthenticationViewModel.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 21/06/25.
//

import Foundation
import LocalAuthentication

final class AuthenticationViewModel {
    var onAuthenticationResult: ((Bool) -> Void)?

    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            onAuthenticationResult?(false)
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Autentique para acessar o Filmcity") { success, _ in
            DispatchQueue.main.async { self.onAuthenticationResult?(success) }
        }
    }

    func authenticate(withPin pin: String) {
        let stored = KeychainHelper.standard.readPin()
        let ok = (pin == stored)
        onAuthenticationResult?(ok)
    }
}
