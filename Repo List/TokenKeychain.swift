//
//  TokenKeychain.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-15.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import Foundation
import KeychainSwift

/// Utility that saves and loads oauth tokens from the keychain.
class TokenKeychain {

	static let keyChainOAuthTokenKey = "RepoListOauthToken"
	static let keyChainOAuthTokenSecretKey = "RepoListOauthTokenSecret"

	func saveToKeychain(oauthToken: String, oauthTokenSecret: String) {
		print("Storing token in keychain")
		let keychain = KeychainSwift()
		keychain.set(oauthToken, forKey: TokenKeychain.keyChainOAuthTokenKey)
		keychain.set(oauthTokenSecret, forKey: TokenKeychain.keyChainOAuthTokenSecretKey)
	}

	func readCredentialsFromKeychain(useValues: (_ oauthToken: String, _ oauthTokenSecret: String) -> Void) -> Bool {
		print("Reading token from keychain")
		let keychain = KeychainSwift()

		guard let oauthToken = keychain.get(TokenKeychain.keyChainOAuthTokenKey), let oauthTokenSecret = keychain.get(TokenKeychain.keyChainOAuthTokenSecretKey) else {
			return false
		}

		useValues(oauthToken, oauthTokenSecret)

		return true
	}

	func clearCredentials() {
		print("Clearing keychain")
		let keychain = KeychainSwift()
		keychain.delete(TokenKeychain.keyChainOAuthTokenKey)
		keychain.delete(TokenKeychain.keyChainOAuthTokenSecretKey)
	}

}
