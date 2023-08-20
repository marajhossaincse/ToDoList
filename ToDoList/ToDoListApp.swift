//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Maraj Hossain on 8/17/23.
//

import SwiftUI

@main
struct ToDoListApp: App {
    @StateObject var listViewModel: ListViewModel = .init()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListView()
            }
            .environmentObject(listViewModel)
        }
    }
}
