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
    @IBOutlet weak var stackView: UIStackView!
    
    static let defaultHeight: CGFloat = 44.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(meaning: Meaning) {
        partOfSpeechLbl.text = meaning.partOfSpeech?.capitalized
        deffinationLbl.text = meaning.definitions?.first?.definition
        exampleTitle.isHidden = meaning.definitions?.first?.example == nil
        exampleTitle.text = "Example"
        exampleLbl.text = meaning.definitions?.first?.example
        
        deffinationLbl.numberOfLines = 0
        exampleLbl.numberOfLines = 0
        stackView.distribution = .fill
        
        deffinationLbl.invalidateIntrinsicContentSize()
        exampleLbl.invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
    
    static func heightForCell(meaning: Meaning, width: CGFloat) -> CGFloat {
        let cell = WordDetailCell(style: .default, reuseIdentifier: nil)
        cell.contentView.frame.size.width = width // Güncelleme: contentView'in genişliği ayarlanıyor
        cell.configure(meaning: meaning)
        cell.layoutIfNeeded()

        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let estimatedSize = cell.contentView.systemLayoutSizeFitting(targetSize,
                                                                     withHorizontalFittingPriority: .required,
                                                                     verticalFittingPriority: .fittingSizeLevel)

        return max(estimatedSize.height, defaultHeight)
    }
}
