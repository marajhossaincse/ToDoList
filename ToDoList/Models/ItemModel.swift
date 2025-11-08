//
//  ItemModel.swift
//  ToDoList
//
//  Created by Maraj Hossain on 8/17/23.
//

import Foundation

struct ItemModel: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let details: String
    let isCompleted: Bool
    
    init(
        id: String = UUID().uuidString,
        title: String,
        details: String = "",
        isCompleted: Bool
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.isCompleted = isCompleted
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, details, isCompleted
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        details = try container.decodeIfPresent(String.self, forKey: .details) ?? ""
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, details: details, isCompleted: !isCompleted)
    }
}
