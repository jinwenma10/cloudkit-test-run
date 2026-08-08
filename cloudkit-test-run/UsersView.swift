//
//  UsersView.swift
//  cloudkit-test-run
//
//  Created by T Krobot on 8/8/26.
//

import SwiftUI
import SwiftData


struct UsersView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    @State private var isAddingPerson = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(users) { user in
                    HStack {
                        Text(user.name)

                        Spacer()

                        Text(String(user.unwrappedJobs.count))
                            .fontWeight(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                }
                .onDelete(perform: deleteUsers)
            }
            .navigationTitle("Users")
            .overlay {
                if users.isEmpty {
                    ContentUnavailableView("No people yet", systemImage: "person.slash", description: Text("Tap + to add someone."))
                }
            }
            .toolbar {
                Button("Add Person", systemImage: "plus") {
                    isAddingPerson = true
                }
            }
            .sheet(isPresented: $isAddingPerson) {
                PersonDetailsView()
            }
        }
    }
    
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> {user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
    }
    
    func deleteUsers(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(users[offset])
        }
    }
}

#Preview {
    UsersView(minimumJoinDate: .distantPast, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self, inMemory: true)
}
