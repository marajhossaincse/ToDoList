//
//  ListRowView.swift
//  ToDoList
//
//  Created by Maraj Hossain on 8/17/23.
//

import SwiftUI

struct ListRowView: View {
    let title: String

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle")
            Text(title)
            Spacer()
        }
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(title: "This is the first title")
    }
}
