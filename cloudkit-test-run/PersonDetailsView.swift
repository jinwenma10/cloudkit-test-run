//
//  PersonDetailsView.swift
//  cloudkit-test-run
//
//  Created by T Krobot on 8/8/26.
//

import SwiftUI
import SwiftData

struct PersonDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var city = ""
    @State private var joinDate = Date.now

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)

                TextField("City", text: $city)

                DatePicker("Join date", selection: $joinDate, displayedComponents: .date)
            }
            .navigationTitle("Add Person")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(trimmedName.isEmpty)
                }
            }
        }
    }

    func save() {
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)

        let person = User(
            name: trimmedName,
            city: trimmedCity.isEmpty ? "Unknown" : trimmedCity,
            joinDate: joinDate
        )

        modelContext.insert(person)
        dismiss()
    }
}

#Preview {
    PersonDetailsView()
        .modelContainer(for: User.self, inMemory: true)
}
