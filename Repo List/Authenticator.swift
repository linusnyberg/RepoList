//
//  Authenticator.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-13.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import Foundation
import OAuthSwift
import Alamofire
import OAuthSwiftAlamofire

/// Performs the authentication with Github.
class Authenticator {

	static var authenticated: Bool = false
	var viewController: UIViewController

	init(viewController: UIViewController) {
		self.viewController = viewController
	}

	/// Checks if the user has authenticated before (during the app's current lifetime), and otherwise tries to authenticate.
	func ensureAuthenticated(completionHandler:@escaping (Bool) -> ()) {
		if !Authenticator.authenticated {
			authenticate(forced: false, completionHandler: completionHandler)
		} else {
			completionHandler(true)
		}
	}

	/// Tries to authenticate, either by reading a token from the keychain or by starting the oauth flow.
	/// - parameter forced: If true, the keychain is ignored and it goes straight to the oauth flow.
	func authenticate(forced: Bool, completionHandler: @escaping (Bool) -> ()) {
		
		// Read secrets from Plist file:
		//------------------------------
		let oauthswift = makeOAuth2SwiftObject()

		// Check if there's a token stored in the keychain
		//------------------------------------------------
		if (!forced) {
			// Check the keychain for a previous token, and use that:
			let keychain = TokenKeychain()
			if (keychain.readCredentialsFromKeychain(useValues: { (outhToken: String, oauthTokenSecret: String) in
				oauthswift.client.credential.oauthToken = outhToken
				oauthswift.client.credential.oauthTokenSecret = oauthTokenSecret
			})) {
				print("Using stored token for session.")
				self.completeLogin(oauthswift: oauthswift)
				completionHandler(true)
				return
			}
		}

		oauthswift.authorizeURLHandler = makeURLHandler(oauthswift: oauthswift)
		let state = generateState(withLength: 20)

		// Perform the login call
		//-----------------------
		let _ = oauthswift.authorize(
			withCallbackURL: URL(string: "repolist://oauth-callback/github")!, scope: "user,repo", state: state,
			success: { credential, response, parameters in
				// Success
				//--------
				print("Logged into Github. oauthToken:\(credential.oauthToken)")

				// Save the credentials to keychain
				let keychain = TokenKeychain()
				keychain.saveToKeychain(oauthToken: credential.oauthToken, oauthTokenSecret: credential.oauthTokenSecret)

				self.completeLogin(oauthswift: oauthswift)
				completionHandler(true)
			},
			failure: { error in
				print(error.description)
				completionHandler(false)
			}
		)
	}

	/// Creates an "OAuth2Swift" object, configured for Github access.
	func makeOAuth2SwiftObject() -> OAuth2Swift {
		let path = Bundle.main.path(forResource: "Secrets", ofType: "plist")
		let dict = NSDictionary(contentsOfFile: path!) as? [String: AnyObject]
		let clientID = dict!["GithubClientID"] as! String
		let clientSecret = dict!["GithubClientSecret"] as! String

		return OAuth2Swift(
			consumerKey:    clientID,
			consumerSecret: clientSecret,
			authorizeUrl:   "https://github.com/login/oauth/authorize",
			accessTokenUrl: "https://github.com/login/oauth/access_token",
			responseType:   "code"
		)
	}

	/// Creates a URL handler that presents the authorization page to the user.
	func makeURLHandler(oauthswift: OAuth2Swift?) -> OAuthSwiftURLHandlerType {
		let handler = SafariURLHandler(viewController: self.viewController, oauthSwift: oauthswift!)
		handler.presentCompletion = {
			print("Safari presented")
		}
		handler.dismissCompletion = {
			print("Safari dismissed")
		}
		return handler
	}

	/// Finalizes the login procedure.
	func completeLogin(oauthswift: OAuth2Swift) {
		// Let `OAuthSwiftAlamofire` configure an adapter that automatically adds the auth token to all requests:
		let sessionManager = SessionManager.default
		sessionManager.adapter = oauthswift.requestAdapter

		Authenticator.authenticated = true
	}
}
