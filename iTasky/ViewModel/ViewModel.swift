//
//  TaskViewModel.swift
//  iTasky
//
//  Created by Ronak Harkhani on 22/05/22.
//

import Foundation
import CoreData

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var currentTab = Tab.Today
        
        @Published var taskToEdit: Task?
        @Published var showEditTask = false
    }
}
