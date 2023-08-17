//
//  ItemModel.swift
//  ToDoList
//
//  Created by Maraj Hossain on 8/17/23.
//

import Foundation

struct ItemModel: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let isCompleted: Bool
}
