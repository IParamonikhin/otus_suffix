//
//  ContentView.swift
//  otus_suffix
//
//  Created by Иван on 15.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = SuffixArrayViewModel()

    var body: some View {
        VStack {
            TextField("Введите текст...", text: $viewModel.inputText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Выбор режима", selection: $viewModel.pickerSelection) {
                Text("Все суффиксы").tag(0)
                Text("Топ-10 (3 буквы)").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            if viewModel.pickerSelection == 0 {
                HStack {
                    TextField("Поиск суффиксов...", text: $viewModel.searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: viewModel.toggleSort) {
                        Image(systemName: viewModel.sortAsc ? "arrow.up" : "arrow.down")
                    }
                }
                .padding(.horizontal)

                List(viewModel.suffixes) { suffix in
                    HStack {
                        Text(suffix.text)
                        Spacer()
                        Text("\(suffix.count)")
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                List(viewModel.topSuffixes) { suffix in
                    HStack {
                        Text(suffix.text)
                        Spacer()
                        Text("\(suffix.count)")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
