//
//  EditTask.swift
//  iTasky
//
//  Created by Ronak Harkhani on 22/05/22.
//

import SwiftUI

struct EditTaskView: View {
        
    @Namespace var animation
    @Environment(\.self) var env
    
    private var taskToEdit: Task?
    @ObservedObject private var viewModel: ViewModel
    
    init(taskToEdit: Task?) {
        self.taskToEdit = taskToEdit
        self.viewModel = ViewModel(taskToEdit: self.taskToEdit)
    }
    
    var body: some View {
        VStack {
            NavBar()
            
            TaskColorPicker()
            
            TaskDeadlinePicker()
            
            TaskTitleInput()
            
            SegmentedTaskTypeSelector()
            
            VStack {
                Spacer()
                        
                CapsuleSaveButton()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .overlay {
            ZStack {
                if viewModel.showDatePicker {
                    DatePickerView()
                }
            }
            .animation(.easeInOut, value: viewModel.showDatePicker)
        }
    }
    
    @ViewBuilder
    func NavBar() -> some View {
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
                    if let taskToEdit = taskToEdit {
                        env.managedObjectContext.delete(taskToEdit)
                        try? env.managedObjectContext.save()
                        env.dismiss()
                    }
                }) {
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                .opacity(taskToEdit == nil ? 0 : 1)
            }
    }
    
    @ViewBuilder
    func TaskColorPicker() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Task Color")
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 15) {
                ForEach(TaskColor.allCases, id: \.self) { color in
                    Circle()
                        .fill(Color(color.rawValue))
                        .frame(width: 25, height: 25)
                        .background {
                            if viewModel.taskColor == color {
                                Circle()
                                    .strokeBorder(.gray, lineWidth: 1.1)
                                    .padding(-3)
                            }
                        }
                        .contentShape(Circle())
                        .onTapGesture {
                            viewModel.taskColor = color
                        }
                }
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 30)
        .padding(.bottom, 5)
        
        Divider()
            .padding(.vertical, 10)
    }
    
    @ViewBuilder
    func TaskDeadlinePicker() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Task Deadline")
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(viewModel.taskDeadline.formatted(date: .abbreviated, time: .shortened))
                .font(.callout)
                .fontWeight(.semibold)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                viewModel.showDatePicker = true
            }) {
                Image(systemName: "calendar")
                    .foregroundColor(.black)
            }
        }
        
        Divider()
            .padding(.vertical, 10)
    }
    
    @ViewBuilder
    func TaskTitleInput() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Task Title")
                .font(.caption)
                .foregroundColor(.gray)
            
            TextField("Title", text: $viewModel.taskTitle)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
        }
        
        Divider()
            .padding(.vertical, 10)
    }
    
    @ViewBuilder
    func SegmentedTaskTypeSelector() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Task Type")
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 12) {
                ForEach(TaskType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                        .font(.callout)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(viewModel.taskType == type ? .white : .black)
                        .background {
                            if viewModel.taskType == type {
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
                            withAnimation { viewModel.taskType = type }
                        }
                }
            }
            .padding(.top, 8)
        }
        
        Divider()
            .padding(.vertical, 14)
    }
    
    @ViewBuilder
    func CapsuleSaveButton() -> some View {
        Button(action: {
            if viewModel.addTask(context: env.managedObjectContext) {
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
                .disabled(viewModel.taskTitle == "")
                .opacity(viewModel.taskTitle == "" ? 0.6 : 1)
        }
    }
    
    @ViewBuilder
    func DatePickerView() -> some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
            .onTapGesture {
                viewModel.showDatePicker = false
            }
        
        DatePicker.init(
            "",
            selection: $viewModel.taskDeadline,
            in: Date.now...Date.distantFuture
        )
        .datePickerStyle(.graphical)
        .labelsHidden()
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding()
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskView(taskToEdit: nil)
    }
}
