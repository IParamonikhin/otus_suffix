//
//  SuffixAnalyzer.swift
//  otus_suffix
//
//  Created by Иван on 13.04.2025.
//

import Foundation

struct SuffixAnalyzer {
    static func analyze(text: String) async -> [Suffix] {
        let words = text.lowercased().split(whereSeparator: { !$0.isLetter })
        var suffixCountDict: [String: Int] = [:]

        for word in words {
            guard word.count >= 3 else { continue }
            var iterator = SuffixIterator(word: String(word))
            while let suffix = iterator.next() {
                guard suffix.count >= 3 else { continue }
                for length in 3...suffix.count {
                    let subSuffix = String(suffix.prefix(length))
                    suffixCountDict[subSuffix, default: 0] += 1
                }
            }
        }

        return suffixCountDict.map { Suffix(text: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }
}
