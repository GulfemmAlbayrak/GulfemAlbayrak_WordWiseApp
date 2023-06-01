////
////  SearchViewModel.swift
////  WordWise
////
////  Created by Gülfem Albayrak on 27.05.2023.
////
//
import Foundation
import WordWiseAPI

class SearchViewModel {
    
    var meanings: [Meaning] = []
    var synonyms: [SynWordElement] = []
    
    private let wordService: WordServiceProtocol
    private let synonymService: SynonymServiceProtocol
    
    init(wordService: WordServiceProtocol = WordService(), synonymService: SynonymServiceProtocol = SynonymService()) {
        self.wordService = wordService
        self.synonymService = synonymService
    }
    
    func fetchWordDataAndSynonyms(word: String, completion: @escaping (Result<WordElement, Error>) -> Void) {
        wordService.getWords(word: word) { [weak self] result in
            switch result {
            case .success(let wordElements):
                if let wordElement = wordElements.first {
                    self?.meanings = wordElement.meanings ?? []
                    self?.fetchSynonyms(for: word) { result in
                        switch result {
                        case .success(let synonyms):
                            self?.synonyms = synonyms
                            completion(.success(wordElement))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchSynonyms(for word: String, completion: @escaping (Result<[SynWordElement], Error>) -> Void) {
        synonymService.getSynonyms(word: word) { result in
            switch result {
            case .success(let synonyms):
                completion(.success(synonyms))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
