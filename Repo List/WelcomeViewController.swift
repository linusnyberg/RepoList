//
//  WelcomeViewController.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-14.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import UIKit

/// The welcome/login screen.
class WelcomeViewController: UIViewController {

	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

		activityIndicator.isHidden = true
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		activityIndicator.isHidden = true
		activityIndicator.stopAnimating()

		let hasLoggedIn = RepoListDefaults.hasLoggedIn
		if (hasLoggedIn) {
			// Automatically go to the Repos screen.
			self.performSegue(withIdentifier: "showRepos", sender: self)
		}
	}

	// MARK: - User actions

	@IBAction func loginAction(_ sender: Any) {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()

		let authenticator = Authenticator(viewController: self)
		authenticator.authenticate(forced: true) { authenticated in
			if (authenticated) {
				RepoListDefaults.hasLoggedIn = true
				self.performSegue(withIdentifier: "showRepos", sender: self)
			}
		}
	}

}
