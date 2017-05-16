//
//  ReposViewController.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-13.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import UIKit
import SafariServices

/// The list of saved repos
class ReposViewController: UITableViewController {

	// MARK: - Properties

	var repos: [Repo] = []

	lazy var reposDataLoader: ReposDataLoader? = {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return nil
		}

		return ReposDataLoader(delegate: self, viewController: self, persistentContainer: appDelegate.persistentContainer)
	}()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Repos"
		tableView.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
		tableView.estimatedRowHeight = 86

		tableView.delegate = self

		navigationItem.hidesBackButton = true
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let logoutItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(ReposViewController.logoutAction(_:)))
		self.navigationController?.isToolbarHidden = false
		self.toolbarItems = [logoutItem]
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		performFirstLoad()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		self.navigationController?.isToolbarHidden = true
	}

	// MARK: - Actions

	func logoutAction(_ sender: Any) {

		// Open Github's logout page to perform the actual logout:
		let urlString = "https://github.com/logout"
		if let url = URL(string: urlString) {
			let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
			vc.delegate = self
			present(vc, animated: true)
		}
	}

	// MARK: - Helpers

	func performFirstLoad() {
		guard let reposDataLoader = reposDataLoader else {
			return
		}
		if (reposDataLoader.loadingState == .neverLoaded) {
			reposDataLoader.startLoadingData(allowCache: true)
		}
	}

}

// MARK: - DataLoaderDelegate
extension ReposViewController: DataLoaderDelegate {
	func dataLoaderDidLoadData(dataLoader: DataLoader) {
		guard let reposDataLoader = reposDataLoader else {
			return
		}
		repos = reposDataLoader.repos
		print("Loaded repos:")
		for repo in repos {
			print("- \(repo.repoName)")
		}
		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource
extension ReposViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return repos.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for:indexPath) as! RepoTableViewCell

		let repo = repos[indexPath.row]

		cell.repoNameLabel.text = repo.repoName
		cell.repoDescriptionLabel.text = repo.repoDescription

		return cell
	}

	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
}

// MARK: - UITableViewDelegate
extension ReposViewController{
/*
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let navigationController = self.navigationController else {
			return
		}

		let repo = repos[indexPath.row]
		let repoViewModel = RepoViewModel(repo: repo)

		let repoViewController = RepoViewController(viewModel: repoViewModel)
		navigationController.pushViewController(repoViewController, animated: true)
	}
*/
}

// MARK: - SFSafariViewControllerDelegate
extension ReposViewController: SFSafariViewControllerDelegate {
	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
		print("Safari view controller dismissed")

		// TODO: We don't actually know if the user chose to log out once inside the safari view controller. Figure out how to deal with that...

		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		// Clear the table:
		repos = []
		tableView.reloadData()

		// Completely empty the local store:
		appDelegate.deleteAllData()

		// Clear the flag from userdefaults
		RepoListDefaults.hasLoggedIn = false

		// Clear the keychain
		let keychain = TokenKeychain()
		keychain.clearCredentials()

		// Go to welcome screen
		navigationController?.popViewController(animated: true)
	}
}
