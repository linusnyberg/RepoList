//
//  ReposViewController.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-13.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import UIKit

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
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RepoCell")

		tableView.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let saveItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(ReposViewController.logoutAction(_:)))
		self.navigationController?.isToolbarHidden = false
		self.toolbarItems = [saveItem]
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

	@IBAction func logoutAction(_ sender: Any) {
		// TODO: Implement
		print("log out action!")
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
		let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for:indexPath)
		let repo = repos[indexPath.row]

		var names = Array<String>()
		if (repo.repoName.characters.count > 0) {
			names.append(repo.repoName)
		}
		if (names.count == 1) {
			cell.textLabel?.text = "\(names[0])"
		} else if (names.count == 2) {
			cell.textLabel?.text = "\(names[0]) (\(names[1]))"
		} else {
			cell.textLabel?.text = "?"
		}

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
