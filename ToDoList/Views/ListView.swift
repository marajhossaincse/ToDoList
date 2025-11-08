//
//  ListView.swift
//  ToDoList
//
//  Created by Maraj Hossain on 8/17/23.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            if listViewModel.items.isEmpty {
                NoItemsView()
                    .transition(.opacity)
            } else {
                List {
                    summarySection

                    Section {
                        ForEach(listViewModel.items) { item in
                            ListRowView(item: item)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        listViewModel.updateItem(item: item)
                                    }
                                }
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                .animation(.easeInOut, value: listViewModel.items)
            }
        }
        .navigationTitle("Today")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !listViewModel.items.isEmpty {
                    EditButton()
                }
            }

            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    AddView()
                } label: {
                    Label("Add Task", systemImage: "plus.circle.fill")
                        .labelStyle(.titleAndIcon)
                }
            }
        }
    }

    private var completionSummary: (completed: Int, remaining: Int, progress: Double) {
        let completed = listViewModel.items.filter(\.isCompleted).count
        let remaining = listViewModel.items.count - completed
        let progress = listViewModel.items.isEmpty ? 0 : Double(completed) / Double(listViewModel.items.count)
        return (completed, remaining, progress)
    }

    private var summarySection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Progress")
                        .font(.headline)
                    Spacer()
                    Text("\(completionSummary.completed)/\(listViewModel.items.count) complete")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                }

                ProgressView(value: completionSummary.progress)
                    .tint(.accentColor)

                Text(completionSummary.remaining == 0 ? "Everything is wrapped up. Great job!" : "You have \(completionSummary.remaining) more item\(completionSummary.remaining == 1 ? "" : "s") to finish.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .listRowBackground(Color.clear)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
        }
        .environmentObject(ListViewModel())
    }
}
