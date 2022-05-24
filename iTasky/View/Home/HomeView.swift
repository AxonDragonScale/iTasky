//
//  Home.swift
//  iTasky
//
//  Created by Ronak Harkhani on 22/05/22.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.self) var env
    
    @StateObject var viewModel: ViewModel = ViewModel()
    @Namespace var animation
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)],
        predicate: nil,
        animation: .easeInOut
    )
    var tasks: FetchedResults<Task>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Today's Update")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                
                SegregatedSelectionTabBar()
                    .padding(.top, 5)
                
                TaskListView()
                    .padding(.top, 10)
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            Button(action: {
                viewModel.showEditTask.toggle()
            }) {
                Label(title: {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                }, icon: {
                    Image(systemName: "plus.app.fill")
                })
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(
                    colors: [
                        .white.opacity(0.05),
                        .white.opacity(0.4),
                        .white.opacity(0.7),
                        .white
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
        }
        .fullScreenCover(
            isPresented: $viewModel.showEditTask,
            onDismiss: {
                viewModel.taskToEdit = nil
            }, content: {
                EditTaskView(taskToEdit: viewModel.taskToEdit)
            })
    }
    
    @ViewBuilder
    func TaskListView() -> some View {
        LazyVStack(spacing: 20) {
            FilteredTaskListView(currentTab: viewModel.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }
    }
    
    @ViewBuilder
    func TaskRowView(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.4))
                    }
                
                Spacer()
                
                if !task.isCompleted && viewModel.currentTab != .Failed {
                    Button(action: {
                        viewModel.taskToEdit = task
                        viewModel.showEditTask = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                }
            }
            
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical, 10)
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label(title: {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    }, icon: {
                        Image(systemName: "calendar")
                    })
                    
                    Label(title: {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    }, icon: {
                        Image(systemName: "clock")
                    })
                }
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !task.isCompleted && viewModel.currentTab != .Failed {
                    Button(action: {
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    }) {
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? TaskColor.Yellow.rawValue))
        }
    }
    
    @ViewBuilder
    func SegregatedSelectionTabBar() -> some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.8)
                    .foregroundColor(viewModel.currentTab == tab ? .white : .black)
                    .padding(8)
                    .background {
                        if viewModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            viewModel.currentTab = tab
                        }
                    }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
