//
//  AnalysisJob.swift
//  otus_suffix
//
//  Created by Иван on 13.04.2025.
//

import Foundation

struct Suffix: Identifiable, Hashable {
    let id = UUID()
    let text: String
    var count: Int
}

struct AnalysisJob: Identifiable {
    let id = UUID()
    let input: String
    var result: [Suffix] = []
    var duration: TimeInterval = 0
    var timestamp: Date = Date()
}
