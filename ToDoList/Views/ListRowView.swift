//
//  ListRowView.swift
//  ToDoList
//
//  Created by Maraj Hossain on 8/17/23.
//

import SwiftUI

struct ListRowView: View {
    let item: ItemModel

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title3.weight(.semibold))
                .foregroundColor(item.isCompleted ? .green : .secondary)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(3)

                if !item.details.isEmpty {
                    Text(item.details)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                } else {
                    Text("No additional details")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            if item.isCompleted {
                Image(systemName: "sparkles")
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Task completed")
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .contentShape(Rectangle())
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var item1 = ItemModel(
        title: "First item",
        details: "Remember to attach the PDF before sending.",
        isCompleted: false
    )
    static var item2 = ItemModel(
        title: "Second item",
        details: "Already reviewed; just archive if no feedback comes in.",
        isCompleted: true
    )

    static var previews: some View {
        Group {
            ListRowView(item: item1)
            ListRowView(item: item2)
        }
        .previewLayout(.sizeThatFits)
    }
}
