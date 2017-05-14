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

	func ensureAuthenticated() {
		if !Authenticator.authenticated {
			authenticate()
		} 
	}

	func authenticate() {
		// Read secrets from Plist file:
		//------------------------------
		let path = Bundle.main.path(forResource: "Secrets", ofType: "plist")
		let dict = NSDictionary(contentsOfFile: path!) as? [String: AnyObject]
		let clientID = dict!["GithubClientID"] as! String
		let clientSecret = dict!["GithubClientSecret"] as! String

		let oauthswift = OAuth2Swift(
			consumerKey:    clientID,
			consumerSecret: clientSecret,
			authorizeUrl:   "https://github.com/login/oauth/authorize",
			accessTokenUrl: "https://github.com/login/oauth/access_token",
			responseType:   "code"
		)
		oauthswift.authorizeURLHandler = getURLHandler(oauthswift: oauthswift)
		let state = generateState(withLength: 20)

		// Perform the login call
		//-----------------------
		let _ = oauthswift.authorize(
			withCallbackURL: URL(string: "repolist://oauth-callback/github")!, scope: "user,repo", state: state,
			success: { credential, response, parameters in
				// Success
				//--------
				print("oauth_token:\(credential.oauthToken)")

				// Let `OAuthSwiftAlamofire` configure an adapter that automatically adds the auth token to all requests:
				let sessionManager = SessionManager.default
				sessionManager.adapter = oauthswift.requestAdapter

				Authenticator.authenticated = true
			},
			failure: { error in
				print(error.description)
			}
		)
	}

	func getURLHandler(oauthswift: OAuth2Swift?) -> OAuthSwiftURLHandlerType {
		let handler = SafariURLHandler(viewController: self.viewController, oauthSwift: oauthswift!)
		handler.presentCompletion = {
			print("Safari presented")
		}
		handler.dismissCompletion = {
			print("Safari dismissed")
		}
		return handler
	}
}
