//
//  ListView.swift
//  ToDoList
//
//  Created by Maraj Hossain on 8/17/23.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var searchText: String = ""
    @State private var filterSelection: TaskFilter = .all

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
                    filterSection

                    Section {
                        if filteredItems.isEmpty {
                            filteredEmptyState
                                .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                                .listRowBackground(Color.clear)
                        } else {
                            ForEach(filteredItems) { item in
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
                            .onDelete(perform: deleteFilteredItems)
                            .onMove(perform: moveFilteredItems)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                .animation(.easeInOut, value: listViewModel.items)
            }
        }
        .navigationTitle("Today")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !listViewModel.items.isEmpty {
                    EditButton()
                        .disabled(!canEditList)
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
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search tasks")
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

    private var filterSection: some View {
        Section {
            Picker("Filter", selection: $filterSelection) {
                ForEach(TaskFilter.allCases) { filter in
                    Text(filter.label)
                        .tag(filter)
                }
            }
            .pickerStyle(.segmented)

            if !searchText.isEmpty {
                Text("Showing results for \"\(searchText)\"")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Showing results for \(searchText)")
            }

            if !canEditList {
                Text("Reordering is available when viewing all items without filtering.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .listRowBackground(Color.clear)
    }

    private var filteredEmptyState: some View {
        Label("No tasks match your current filters.", systemImage: "line.3.horizontal.decrease.circle")
            .font(.body)
            .foregroundColor(.secondary)
    }

    private var normalizedSearchText: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var filteredItems: [ItemModel] {
        listViewModel.items
            .filter { filterSelection.includes($0) }
            .filter {
                guard !normalizedSearchText.isEmpty else { return true }
                return $0.title.localizedCaseInsensitiveContains(normalizedSearchText) ||
                $0.details.localizedCaseInsensitiveContains(normalizedSearchText)
            }
    }

    private var canEditList: Bool {
        filterSelection == .all && normalizedSearchText.isEmpty
    }

    private func deleteFilteredItems(at offsets: IndexSet) {
        let ids = offsets.compactMap { filteredItems.indices.contains($0) ? filteredItems[$0].id : nil }
        listViewModel.deleteItems(withIDs: ids)
    }

    private func moveFilteredItems(from source: IndexSet, to destination: Int) {
        guard canEditList else { return }
        listViewModel.moveItem(from: source, to: destination)
    }

    private enum TaskFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case active = "Active"
        case completed = "Completed"

        var id: Self { self }
        var label: String { rawValue }

        func includes(_ item: ItemModel) -> Bool {
            switch self {
            case .all:
                return true
            case .active:
                return !item.isCompleted
            case .completed:
                return item.isCompleted
            }
        }
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
