////
////  SearchViewModel.swift
////  WordWise
////
////  Created by Gülfem Albayrak on 27.05.2023.
////
//
import Foundation
import WordWiseAPI
import CoreData


 class SearchViewModel {
     var words: [String] = []
     var meanings: [Meaning] = []
     var synonyms: [SynWordElement] = []

     func addWord(_ word: String) {
           if !words.contains(word) {
               words.insert(word, at: 0)
           }
    }

//     func addWordToCoreData(_ word: String) {
//         if !words.contains(word) {
//             words.insert(word, at: 0)
//
//             // Core Data'ya yeni bir Word kaydedin
//             let newWord = Words(context: context)
//             newWord.word = word
//
//             do {
//                 // Değişiklikleri kaydedin
//                 try context.save()
//             } catch {
//                 // Hata durumunda işlemleri yönetin
//                 print("Core Data save error: \(error)")
//             }
//         }
//     }
     

    func fetchWordDataAndSynonyms(word: String, completion: @escaping (Result<WordElement, Error>) -> Void) {
        let wordService: WordServiceProtocol = WordService()
        let synonymService: SynonymServiceProtocol = SynonymService()

        wordService.getWords(word: word) { [weak self] result in
            switch result {
            case .success(let wordElements):
                if let wordElement = wordElements.first {
                    self?.meanings = wordElement.meanings ?? []

                    synonymService.getSynonyms(word: word) { [weak self] result in
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
}
