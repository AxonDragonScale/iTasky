//
//  ContentView.swift
//  iTasky
//
//  Created by Ronak Harkhani on 22/05/22.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        NavigationView {
            HomeView()
                .navigationBarTitle("iTasky")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
