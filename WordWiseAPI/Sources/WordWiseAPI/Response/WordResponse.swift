//
//  File.swift
//  
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

// MARK: - WordResponse
public struct WordResponse: Decodable {
    public let results: [WordElement]
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var results = [WordElement]()
        
        while !container.isAtEnd {
            if let wordElement = try? container.decode(WordElement.self) {
                results.append(wordElement)
            } else {
                _ = try? container.decode(EmptyResponse.self) // Skip empty response if any
            }
        }
        
        self.results = results
    }
}

// MARK: - EmptyResponse
private struct EmptyResponse: Decodable {}
