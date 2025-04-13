//
//  JobResultsView.swift
//  otus_suffix
//
//  Created by Иван on 13.04.2025.
//

import SwiftUI

struct JobResultView: View {
    let job: AnalysisJob

    var body: some View {
        VStack(alignment: .leading) {
            Text("Результаты для: \(job.input)")
                .font(.headline)
                .padding()

            List(job.result) { item in
                HStack {
                    Text(item.text)
                    Spacer()
                    Text("\(item.count)")
                }
            }
        }
    }
}
