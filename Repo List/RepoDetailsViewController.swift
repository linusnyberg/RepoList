//
//  RepoDetailsViewController.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-16.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import UIKit

/// The Details view controller for a Repo. Shows the name and other details for a single Repo.
class RepoDetailsViewController: UIViewController {

	var viewModel: RepoDetailsViewModel

	var repoNameLabel: UILabel! = {
		let repoNameLabel = UILabel()
		repoNameLabel.textAlignment = .center
		repoNameLabel.font = UIFont.boldSystemFont(ofSize: 19.0)
		return repoNameLabel
	}()

	var repoUrlLabel: UILabel! = {
		let repoUrlLabel = UILabel()
		repoUrlLabel.textAlignment = .center
		repoUrlLabel.font = UIFont.systemFont(ofSize: 12.0)
		return repoUrlLabel
	}()

	var repoDescriptionLabel: UILabel! = {
		let repoDescriptionLabel = UILabel()
		repoDescriptionLabel.textAlignment = .left
		repoDescriptionLabel.font = UIFont.systemFont(ofSize: 12.0)
		repoDescriptionLabel.numberOfLines = 2
		return repoDescriptionLabel
	}()

	var repoLanguageLabel: UILabel! = {
		let repoLanguageLabel = UILabel()
		repoLanguageLabel.textAlignment = .left
		repoLanguageLabel.font = UIFont.systemFont(ofSize: 12.0)
		repoLanguageLabel.numberOfLines = 2
		return repoLanguageLabel
	}()

	let defaultVerticalMargin: CGFloat = 20.0
	let defaultLeadingMargin: CGFloat = 10.0
	let defaultTrailingMargin: CGFloat = 10.0

	// MARK: - Lifecycle

	init(viewModel: RepoDetailsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.viewModel = RepoDetailsViewModel(repo: Repo())
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = UIColor.white

		// Name
		//-----
		self.view.addSubview(repoNameLabel)
		repoNameLabel.translatesAutoresizingMaskIntoConstraints = false
		repoNameLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 30.0).isActive = true
		repoNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: defaultLeadingMargin).isActive = true
		repoNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -defaultTrailingMargin).isActive = true
		repoNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true

		// URL
		//----
		self.view.addSubview(repoUrlLabel)
		repoUrlLabel.translatesAutoresizingMaskIntoConstraints = false
		repoUrlLabel.topAnchor.constraint(equalTo: repoNameLabel.bottomAnchor, constant: defaultVerticalMargin).isActive = true
		repoUrlLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: defaultLeadingMargin).isActive = true
		repoUrlLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -defaultTrailingMargin).isActive = true
		repoUrlLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true

		let separatorLine1 = makeLine(under: repoUrlLabel)

		// Stackview with the rest of the labels
		//--------------------------------------
		let stackView = UIStackView(arrangedSubviews: [repoDescriptionLabel, repoLanguageLabel])
		stackView.axis = .vertical
		stackView.spacing = 10.0

		self.view.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.topAnchor.constraint(equalTo: separatorLine1.bottomAnchor, constant: defaultVerticalMargin).isActive = true
		stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: defaultLeadingMargin).isActive = true
		stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -defaultTrailingMargin).isActive = true

		updateUI()
	}

	// MARK: - Updating the UI

	/// Creates a horizonal line below the given view, including constraints.
	func makeLine(under topView:UIView) -> UIView {
		let lineView = UIView()
		lineView.backgroundColor = UIColor.darkGray
		self.view.addSubview(lineView)
		lineView.translatesAutoresizingMaskIntoConstraints = false
		lineView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: defaultVerticalMargin).isActive = true
		lineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: defaultLeadingMargin).isActive = true
		lineView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -defaultTrailingMargin).isActive = true
		lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
		return lineView
	}

	/// Propagates values from the view model to the UI
	func updateUI() {

		// Name
		//-----
		repoNameLabel.text = viewModel.repoName

		// URL
		//----
		let urlAttributedString = NSAttributedString(string: viewModel.repoHtmlURL, attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName: UIColor.blue])
		repoUrlLabel.attributedText = urlAttributedString
		let tap = UITapGestureRecognizer(target: self, action: #selector(RepoDetailsViewController.openRepoUrlAction))
		repoUrlLabel.isUserInteractionEnabled = true
		repoUrlLabel.addGestureRecognizer(tap)

		// Description
		//------------
		repoDescriptionLabel.text = viewModel.repoDescription
		if (viewModel.repoDescription.isEmpty) {
			repoDescriptionLabel.isHidden = true
		} else {
			repoDescriptionLabel.isHidden = false
		}

		// Language
		//---------
		repoLanguageLabel.text = String.localizedStringWithFormat(NSLocalizedString("Language: %@", comment: "Repo Details screen: Language label"), viewModel.repoLanguage)
		if (viewModel.repoLanguage.isEmpty) {
			repoLanguageLabel.isHidden = true
		} else {
			repoLanguageLabel.isHidden = false
		}

	}

	// MARK: - User actions

	/// Opens the repository on Github in the browser
	func openRepoUrlAction(sender: UITapGestureRecognizer) {
		guard let url = URL(string: viewModel.repoHtmlURL) else {
			print("Not a proper URL: \(viewModel.repoHtmlURL)")
			return
		}
		UIApplication.shared.open(url)
	}

}
