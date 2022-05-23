//
//  FilteredTaskListView.swift
//  iTasky
//
//  Created by Ronak Harkhani on 23/05/22.
//

import SwiftUI
import CoreData

struct FilteredTaskListView<Content: View, T>: View where T: NSManagedObject {
    
    @FetchRequest private var request: FetchedResults<T>
    let content: (T) -> Content
    
    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        var predicate: NSPredicate!
        if currentTab == "Today" {
            predicate = NSPredicate(
                format: "deadline >= %@ AND deadline < %@ AND isCompleted == %i",
                argumentArray: [today, tomorrow, 0]
            )
        } else if currentTab == "Upcoming" {
            predicate = NSPredicate(
                format: "deadline >= %@ AND deadline < %@ AND isCompleted == %i",
                argumentArray: [tomorrow, Date.distantFuture, 0]
            )
        } else if currentTab == "Failed" {
            predicate = NSPredicate(
                format: "deadline >= %@ AND deadline < %@ AND isCompleted == %i",
                argumentArray: [Date.distantPast, today, 0]
            )
        } else if currentTab == "Completed" {
            predicate = NSPredicate(
                format: "isCompleted == %i",
                argumentArray: [1]
            )
        }
        
        // TODO: Understand this
        _request = FetchRequest(
            entity: T.entity(),
            sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)],
            predicate: predicate
        )
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No Tasks Found!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    content(object)
                }
            }
        }
    }
}
