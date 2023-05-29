//
//  File.swift
//  
//
//  Created by Gülfem Albayrak on 26.05.2023.
//

import Foundation

// MARK: - WordElement
public struct WordElement: Decodable {
    public let word: String?
    public let phonetic: String?
    public let phonetics: [Phonetic]?
    public let meanings: [Meaning]?
}

// MARK: - Meaning
public struct Meaning: Decodable {
    public let partOfSpeech: String?
    public let definitions: [Definition]?
}

// MARK: - Definition
public struct Definition: Decodable {
    public let definition: String?
    public let example: String?
}

// MARK: - Phonetic
public struct Phonetic: Decodable {
    public let text: String?
    public let audio: String?
}


