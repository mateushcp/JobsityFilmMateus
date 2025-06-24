//
//  KeychainHelper.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import Foundation
import Security

final class KeychainHelper {
    static let standard = KeychainHelper()
    private init() {}

    private let service = "com.filmcity.pin"

    /// Salva (ou atualiza) o PIN no Keychain
    func savePin(_ pin: String) {
        guard let data = pin.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]

        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]

        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        if status == errSecItemNotFound {
            var addQuery = query
            addQuery[kSecValueData as String] = data
            SecItemAdd(addQuery as CFDictionary, nil)
        }
    }

    /// Lê o PIN (se existir) do Keychain
    func readPin() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let pin = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        return pin
    }
}
