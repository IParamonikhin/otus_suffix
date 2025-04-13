//
//  SearchView.swift
//  otus_suffix
//
//  Created by Иван on 13.04.2025.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var jobScheduler: JobScheduler
    @State private var inputText: String = ""
    @State private var searchQuery: String = ""
    @State private var sortAsc: Bool = true
    @State private var pickerSelection: Int = 0

    var filteredSuffixes: [Suffix] {
        guard let current = jobScheduler.history.first(where: { $0.input == inputText && !$0.result.isEmpty }) else { return [] }
        let base: [Suffix] = pickerSelection == 0
            ? current.result
            : Array(current.result.filter { $0.text.count == 3 }.sorted { $0.count > $1.count }.prefix(10))
        return searchQuery.isEmpty
            ? sortSuffixes(base)
            : sortSuffixes(base.filter { $0.text.contains(searchQuery.lowercased()) })
    }

    var body: some View {
        VStack {
            TextField("Введите текст...", text: $inputText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: inputText) { jobScheduler.addJob(text: inputText) }

            Picker("Выбор режима", selection: $pickerSelection) {
                Text("Все суффиксы").tag(0)
                Text("Топ-10 (3 буквы)").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            if pickerSelection == 0 {
                HStack {
                    TextField("Поиск суффиксов...", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: { sortAsc.toggle() }) {
                        Image(systemName: sortAsc ? "arrow.up" : "arrow.down")
                    }
                }
                .padding(.horizontal)
            }

            List(filteredSuffixes) { suffix in
                HStack {
                    Text(suffix.text)
                    Spacer()
                    Text("\(suffix.count)")
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private func sortSuffixes<S: Sequence>(_ seq: S) -> [Suffix] where S.Element == Suffix {
        seq.sorted { sortAsc ? $0.text < $1.text : $0.text > $1.text }
    }
}
