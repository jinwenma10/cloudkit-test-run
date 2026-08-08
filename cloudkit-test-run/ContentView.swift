//
//  ContentView.swift
//  cloudkit-test-run
//
//  Created by T Krobot on 11/7/26.
//

import SwiftUI
import CloudKit
import SwiftData

// 1. Define the CloudKit-backed Schema
@Model
final class SharedItem {
    var text: String
    var timestamp: Date
    
    init(text: String, timestamp: Date = Date()) {
        self.text = text
        self.timestamp = timestamp
    }
}

let myContainer = CKContainer(identifier: "iCloud.com.challenge2.cloudkitproject")


// 2. The Main View
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SharedItem.timestamp, order: .reverse) private var items: [SharedItem]
    
    @State private var userInput: String = ""

    var body: some View {
        VStack(spacing: 16) {
            // Input and Save
            HStack {
                TextField("Type to share...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Save & Sync") {
                    addItem()
                }
            }
            .padding()

            // Display List of shared data
            List(items) { item in
                VStack(alignment: .leading) {
                    Text(item.text)
                        .font(.body)
                    Text(item.timestamp, format: .dateTime.hour().minute().second())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(minWidth: 400, minHeight: 300)
        .padding()
    }

    private func addItem() {
        guard !userInput.isEmpty else { return }
        let newItem = SharedItem(text: userInput)
        modelContext.insert(newItem)
        userInput = "" // Clear input
        
        // Save to iCloud
        do {
            try modelContext.save()
        } catch {
            print("Failed to save item: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
