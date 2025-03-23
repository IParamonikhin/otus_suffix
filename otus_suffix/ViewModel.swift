//
//  ViewModel.swift
//  otus_suffix
//
//  Created by Иван on 23.03.2025.
//

import Foundation
import Combine

struct Suffix: Identifiable {
    let id = UUID()
    let text: String
    var count: Int
}

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

class SuffixArrayViewModel: ObservableObject {
    @Published var inputText: String = "" {
        didSet { buildSuffixArray() }
    }

    @Published var searchQuery: String = ""
    @Published var sortAsc: Bool = true
    @Published var pickerSelection: Int = 0

    @Published var suffixes: [Suffix] = []
    @Published var topSuffixes: [Suffix] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.filterSuffixes(by: query)
            }
            .store(in: &cancellables)
    }

    private func buildSuffixArray() {
        let words = inputText.lowercased().split(whereSeparator: { !$0.isLetter })
        var suffixCountDict = [String: Int]()

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

        suffixes = suffixCountDict
            .map { Suffix(text: $0.key, count: $0.value) }
            .sorted { sortAsc ? $0.text < $1.text : $0.text > $1.text }

        topSuffixes = suffixes
            .filter { $0.text.count == 3 }
            .sorted { $0.count > $1.count }
            .prefix(10)
            .map { $0 }
    }

    func toggleSort() {
        sortAsc.toggle()
        suffixes.sort { sortAsc ? $0.text < $1.text : $0.text > $1.text }
    }

    private func filterSuffixes(by query: String) {
        if query.isEmpty {
            buildSuffixArray()
        } else {
            suffixes = suffixes.filter { $0.text.contains(query.lowercased()) }
        }
    }
}
