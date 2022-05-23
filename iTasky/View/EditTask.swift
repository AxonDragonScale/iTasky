//
//  EditTask.swift
//  iTasky
//
//  Created by Ronak Harkhani on 22/05/22.
//

import SwiftUI

struct EditTask: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.self) var env
    
    @Namespace var animation
    
    var body: some View {
        VStack {
            Text("Edit Task")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button(action: { env.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
                .overlay(alignment: .trailing) {
                    Button(action: {
                        if let editTask = taskViewModel.editTask {
                            env.managedObjectContext.delete(editTask)
                            try? env.managedObjectContext.save()
                            env.dismiss()
                        }
                    }) {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                    .opacity(taskViewModel.editTask == nil ? 0 : 1)
                }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                let colors = ["Yellow", "Green", "Blue", "Purple", "Red", "Orange"] // TODO: Move to model/constants class
                HStack(spacing: 15) {
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .fill(Color(color))
                            .frame(width: 25, height: 25)
                            .background {
                                if taskViewModel.taskColor == color {
                                    Circle()
                                        .strokeBorder(.gray, lineWidth: 1.1)
                                        .padding(-3)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                taskViewModel.taskColor = color
                            }
                    }
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
            
            Divider()
                .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Deadline")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(taskViewModel.taskDeadline.formatted(date: .abbreviated, time: .shortened))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    taskViewModel.showDatePicker = true
                }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }
            }
            
            Divider()
                .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("Title", text: $taskViewModel.taskTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
            }
            
            Divider()
                .padding(.vertical, 10)
            
            let taskTypes = ["Basic", "Urgent", "Important"]
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Type")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    ForEach(taskTypes, id: \.self) { type in
                        Text(type)
                            .font(.callout)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(taskViewModel.taskType == type ? .white : .black)
                            .background {
                                if taskViewModel.taskType == type {
                                    Capsule()
                                        .fill(.black)
                                        .matchedGeometryEffect(id: "TYPE", in: animation)
                                } else {
                                    Capsule()
                                        .strokeBorder(.black)
                                }
                            }
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation { taskViewModel.taskType = type }
                            }
                    }
                }
                .padding(.top, 8)
            }
            
            Divider()
                .padding(.vertical, 14)
            
            VStack {
                Spacer()
                        
                Button(action: {
                    if taskViewModel.addTask(context: env.managedObjectContext) {
                        env.dismiss()
                    }
                }) {
                    Text("Save")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background {
                            Capsule()
                                .fill(.black)
                        }
                        .padding(.bottom, 10)
                        .disabled(taskViewModel.taskTitle == "")
                        .opacity(taskViewModel.taskTitle == "" ? 0.6 : 1)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .overlay {
            ZStack {
                if taskViewModel.showDatePicker {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            taskViewModel.showDatePicker = false
                        }
                    
                    DatePicker.init(
                        "",
                        selection: $taskViewModel.taskDeadline,
                        in: Date.now...Date.distantFuture
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding()
                    .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding()
                }
            }
            .animation(.easeInOut, value: taskViewModel.showDatePicker)
        }
    }
}

struct EditTask_Previews: PreviewProvider {
    static var previews: some View {
        EditTask()
            .environmentObject(TaskViewModel())
    }
}
