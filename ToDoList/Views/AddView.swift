//
//  AddView.swift
//  ToDoList
//
//  Created by Maraj Hossain on 8/17/23.
//

import SwiftUI

struct AddView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool

    @State private var textFieldText: String = ""
    @State private var detailText: String = ""

    var body: some View {
        Form {
            Section(header: Text("Task details")) {
                TextField("e.g., Submit expense report", text: $textFieldText)
                    .focused($isTextFieldFocused)
                    .submitLabel(.done)
                    .textInputAutocapitalization(.sentences)
            }

            Section(header: Text("Description")) {
                ZStack(alignment: .topLeading) {
                    if detailText.isEmpty {
                        Text("Add context, subtasks, or references (optional)")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                    }
                    TextEditor(text: $detailText)
                        .frame(minHeight: 96)
                        .accessibilityLabel("Task description")
                }
            }

            Section(footer: Text("Keep the title short and actionable. Minimum 3 characters.")) {
                Button(action: saveButtonPressed) {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .symbolRenderingMode(.monochrome)
                            .foregroundColor(canSave ? Color.accentColor : Color.white)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(canSave ? Color.white : Color.white.opacity(0.3))
                            )

                        Text("Save Task")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .background(
                    Group {
                        if canSave {
                            LinearGradient(
                                colors: [
                                    Color.accentColor,
                                    Color.accentColor.opacity(0.5)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else {
                            Color(.systemGray5)
                        }
                    }
                )
                .cornerRadius(10)
                .shadow(
                    color: canSave ? Color.accentColor.opacity(0.35) : Color.clear,
                    radius: 12,
                    x: 0,
                    y: 6
                )
                .disabled(!canSave)
            }
        }
        .navigationTitle("New Item")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveButtonPressed()
                }
                .disabled(!canSave)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isTextFieldFocused = true
            }
        }
    }

    func saveButtonPressed() {
        guard canSave else { return }
        listViewModel.addItem(title: trimmedText, details: trimmedDetails)
        dismiss()
    }

    private var trimmedText: String {
        textFieldText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedDetails: String {
        detailText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        trimmedText.count >= 3
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView()
        }
        .environmentObject(ListViewModel())
    }
}
