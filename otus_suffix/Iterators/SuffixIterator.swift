//
//  SuffixIterator.swift
//  otus_suffix
//
//  Created by Иван on 13.04.2025.
//

import Foundation

struct SuffixIterator: Sequence, IteratorProtocol {
    private let word: String
    private var currentIndex: String.Index

    init(word: String) {
        self.word = word
        self.currentIndex = word.startIndex
    }

    mutating func next() -> String? {
        guard currentIndex < word.endIndex else { return nil }
        let suffix = String(word[currentIndex..<word.endIndex])
        currentIndex = word.index(after: currentIndex)
        return suffix
    }
}
