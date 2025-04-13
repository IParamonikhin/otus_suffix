//
//  Sheduler.swift
//  otus_suffix
//
//  Created by Иван on 13.04.2025.
//

import Foundation
import Combine

@MainActor
class JobScheduler: ObservableObject {
    @Published var history: [AnalysisJob] = []

    private var isProcessing = false
    private var timer: Timer?

    init() {
        startScheduler()
    }

    func startScheduler() {
        timer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { [weak self] _ in
            Task { await self?.processJobs() }
        }
    }

    func addJob(text: String) {
        let job = AnalysisJob(input: text)
        history.insert(job, at: 0)
        Task { await processJobs() }
    }

    func processJobs() async {
        guard !isProcessing else { return }
        isProcessing = true

        for index in history.indices where history[index].result.isEmpty {
            let start = Date()
            let result = await SuffixAnalyzer.analyze(text: history[index].input)
            let duration = Date().timeIntervalSince(start)

            history[index].result = result
            history[index].duration = duration
            history[index].timestamp = Date()
        }

        isProcessing = false
    }
}
