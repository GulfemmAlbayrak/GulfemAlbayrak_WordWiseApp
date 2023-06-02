//
//  WordDetailCell.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 27.05.2023.
//

import UIKit
import WordWiseAPI

class WordDetailCell: UITableViewCell {

    @IBOutlet weak var partOfSpeechLbl: UILabel!
    @IBOutlet weak var deffinationLbl: UILabel!
    @IBOutlet weak var exampleTitle: UILabel!
    @IBOutlet weak var exampleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(meaning: Meaning) {
        partOfSpeechLbl.text = meaning.partOfSpeech?.capitalized
        deffinationLbl.text = meaning.definitions?.first?.definition

        if let example = meaning.definitions?.first?.example {
            exampleTitle.isHidden = false
            exampleTitle.text = "Example"
            exampleLbl.text = example
        } else {
            exampleTitle.isHidden = true
            exampleTitle.text = nil
            exampleLbl.text = nil
        }
    }
}
