//
//  EditTask+ViewModel.swift
//  iTasky
//
//  Created by Ronak Harkhani on 24/05/22.
//

import Foundation
import CoreData

extension EditTaskView {
    class ViewModel: ObservableObject {
        var taskToEdit: Task?
        
        @Published var showDatePicker = false

        @Published var taskTitle = ""
        @Published var taskColor: TaskColor = .Yellow
        @Published var taskType: TaskType = .Basic
        @Published var taskDeadline = Date()
        
        init(taskToEdit: Task?) {
            self.taskToEdit = taskToEdit
            
            if let taskToEdit = taskToEdit {
                taskTitle = taskToEdit.title ?? ""
                taskType = TaskType.init(rawValue: taskToEdit.type ?? TaskType.Basic.rawValue)!
                taskDeadline = taskToEdit.deadline ?? Date()
                taskColor = TaskColor.init(rawValue: taskToEdit.color ?? TaskColor.Yellow.rawValue)!
            }
        }
        
        func addTask(context: NSManagedObjectContext) -> Bool {
            var task: Task!
            if let taskToEdit = taskToEdit {
                task = taskToEdit
            } else {
                task = Task(context: context)
            }
            
            task.title = taskTitle
            task.type = taskType.rawValue
            task.color = taskColor.rawValue
            task.deadline = taskDeadline
            task.isCompleted = false

            if let _ = try? context.save() {
                return true
            }
            return false
        }
    }
}
