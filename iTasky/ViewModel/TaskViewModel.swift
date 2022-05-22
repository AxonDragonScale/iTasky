//
//  TaskViewModel.swift
//  iTasky
//
//  Created by Ronak Harkhani on 22/05/22.
//

import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab = "Today"
    
    // New Task
    @Published var editTask: Task?
    @Published var showEditTask = false
    @Published var taskTitle = ""
    @Published var taskColor = "Yellow"
    @Published var taskType = "Basic"
    @Published var taskDeadline = Date()
    @Published var showDatePicker = false
    
    func addTask(context: NSManagedObjectContext) -> Bool {
        var task: Task!
        if let editTask = editTask {
            task = editTask
        } else {
            task = Task(context: context)
        }
        
        task.title = taskTitle
        task.type = taskType
        task.color = taskColor
        task.deadline = taskDeadline
        task.isCompleted = false

        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    func setupTask() {
        if let editTask = editTask {
            taskTitle = editTask.title ?? ""
            taskType = editTask.type ?? "Basic"
            taskDeadline = editTask.deadline ?? Date()
            taskColor = editTask.color ?? "Yellow"
        }
    }
    
    func resetTask() {
        taskTitle = ""
        taskType = "Basic"
        taskColor = "Yellow"
        taskDeadline = Date()
    }
}
