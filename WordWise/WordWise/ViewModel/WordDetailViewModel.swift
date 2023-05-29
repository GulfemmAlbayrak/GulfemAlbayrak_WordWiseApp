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
    
    func fetchWordData(word: String, completion: @escaping (Result<WordElement, Error>) -> Void) {
        let wordService: WordServiceProtocol = WordService()
        wordService.getWords(word: word) { result in
            switch result {
            case .success(let wordElements):
                if let wordElement = wordElements.first {
                    self.meanings = wordElement.meanings ?? []
                    completion(.success(wordElement))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSynonyms(word: String, completion: @escaping (Result<[SynWordElement], Error>) -> Void) {
        let synonymService: SynonymServiceProtocol = SynonymService()
        synonymService.getSynonyms(word: word) { result in
            switch result {
            case .success(let synonyms):
                self.synonyms = synonyms
                completion(.success(synonyms))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
