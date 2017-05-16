//
//  RepoTableViewCell.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-16.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

	@IBOutlet weak var repoNameLabel: UILabel!
	@IBOutlet weak var repoDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
