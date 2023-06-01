//
//  File.swift
//  
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

import Foundation
import Alamofire

public protocol WordServiceProtocol: AnyObject {
    func getWords(word: String, completion: @escaping (Result<[WordElement], Error>) -> Void)
}

public protocol SynonymServiceProtocol: AnyObject {
    func getSynonyms(word: String, completion: @escaping (Result<[SynWordElement], Error>) -> Void)
}

public class WordService: WordServiceProtocol {

    public init() { }
    
    public func getWords(word: String, completion: @escaping (Result<[WordElement], Error>) -> Void) {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(WordResponse.self, from: data)
                    completion(.success(response.results))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

public class SynonymService: SynonymServiceProtocol {

    public init() { }
    
    public func getSynonyms(word: String, completion: @escaping (Result<[SynWordElement], Error>) -> Void) {
        let urlString = "https://api.datamuse.com/words?rel_syn=\(word)"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let synonyms = try decoder.decode([SynWordElement].self, from: data)
                    completion(.success(synonyms))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


