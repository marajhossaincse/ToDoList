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

    var body: some View {
        Form {
            Section(header: Text("Task details")) {
                TextField("e.g., Submit expense report", text: $textFieldText)
                    .focused($isTextFieldFocused)
                    .submitLabel(.done)
                    .textInputAutocapitalization(.sentences)
            }

            Section(footer: Text("Keep the title short and actionable. Minimum 3 characters.")) {
                Button(action: saveButtonPressed) {
                    Label("Save Task", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
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
        listViewModel.addItem(title: trimmedText)
        dismiss()
    }

    private var trimmedText: String {
        textFieldText.trimmingCharacters(in: .whitespacesAndNewlines)
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
