//
//  HistoryView.swift
//  otus_suffix
//
//  Created by Иван on 13.04.2025.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var jobScheduler: JobScheduler
    @State private var selectedJob: AnalysisJob?

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("История анализа")) {
                    ForEach(jobScheduler.history) { job in
                        Button(action: {
                            selectedJob = job
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(job.input)
                                    .font(.headline)
                                    .lineLimit(1)
                                if job.duration > 0 {
                                    Text("Время: \(String(format: "%.2f", job.duration)) сек")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("Выполняется...")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                }

                if !summary.isEmpty {
                    Section(header: Text("Сводка")) {
                        ForEach(summary.sorted(by: { $0.key < $1.key }), id: \ .key) { key, total in
                            HStack {
                                Text(key)
                                Spacer()
                                Text("\(total)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("История")
            .sheet(item: $selectedJob) { job in
                JobResultView(job: job)
            }
        }
    }

    private var summary: [String: Int] {
        let allSuffixes = jobScheduler.history.flatMap { $0.result }
        var grouped: [String: Int] = [:]
        for item in allSuffixes {
            grouped[item.text, default: 0] += item.count
        }
        return grouped
    }
}

