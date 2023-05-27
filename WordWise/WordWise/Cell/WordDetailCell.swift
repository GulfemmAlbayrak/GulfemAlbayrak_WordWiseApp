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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(meaning: Meaning) {
        partOfSpeechLbl.text = meaning.partOfSpeech
        deffinationLbl.text = meaning.definitions?.first?.definition
        exampleLbl.text = meaning.definitions?.first?.example
    }
    
}
