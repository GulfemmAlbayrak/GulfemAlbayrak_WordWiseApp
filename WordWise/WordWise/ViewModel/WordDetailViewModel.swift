//
//  WordDetailViewModel.swift
//  WordWise
//
//  Created by Gülfem Albayrak on 27.05.2023.
//

import Foundation
import WordWiseAPI


class WordDetailViewModel {
    var meanings: [Meaning] = []
    var synonyms: [SynWordElement] = []
    var wordElement: WordElement?
    var partOfSpeechSet: Set<String> = Set<String>()
    
}
