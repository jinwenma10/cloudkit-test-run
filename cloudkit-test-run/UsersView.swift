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
    var body: some View {
        NavigationStack {
            List(users) { user in
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
            .navigationTitle("Users")
            .overlay {
                if users.isEmpty {
                    ContentUnavailableView("No users yet", systemImage: "person.slash", description: Text("Tap + to add a sample user."))
                }
            }
            .toolbar {
                Button("Add Sample", systemImage: "plus", action: addSample)
            }
        }
    }
    
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> {user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
    }
    
    func addSample() {
        let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
        let job1 = Job(name: "Organise shelf", priority: 3)
        let job2 = Job(name: "Eat lunch", priority: 4)
        
        modelContext.insert(user1)
        modelContext.insert(job1)
        modelContext.insert(job2)

        job1.owner = user1
        job2.owner = user1
    }
}

#Preview {
    UsersView(minimumJoinDate: .distantPast, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self, inMemory: true)
}
