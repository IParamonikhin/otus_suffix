//
//  ContentView.swift
//  otus_suffix
//
//  Created by Иван on 15.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var sharedScheduler = JobScheduler()

    var body: some View {
        TabView {
            Tab("Search", systemImage: "magnifyingglass.circle") {
                SearchView(jobScheduler: sharedScheduler)
            }
            Tab("History", systemImage: "list.bullet.circle") {
                HistoryView(jobScheduler: sharedScheduler)
            }
        }
    }
}

#Preview {
    ContentView()
}
