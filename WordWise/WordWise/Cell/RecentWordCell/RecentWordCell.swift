//
//  RecentWordCell.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

import UIKit
import WordWiseAPI

class RecentWordCell: UITableViewCell {

    @IBOutlet weak var recentWordLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(word: String) {
        recentWordLbl.text = word.lowercased().capitalized
    }
}
