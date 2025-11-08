//
//  NoItemsView.swift
//  ToDoList
//
//  Created by Maraj Hossain on 8/22/23.
//

import SwiftUI

struct NoItemsView: View {
    @State var animate: Bool = false
    let secondaryAccentColor = Color("SecondaryAccentColor")

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundColor(secondaryAccentColor)
                    .padding(.bottom, 4)

                VStack(spacing: 8) {
                    Text("Plan your next move")
                        .font(.title2.weight(.semibold))

                    Text("Capture a few quick tasks to keep your day on track. Short, focused lists are easier to complete.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)

                NavigationLink {
                    AddView()
                } label: {
                    Label("Add a task", systemImage: "plus")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(animate ? secondaryAccentColor : Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal, animate ? 24 : 32)
                .shadow(
                    color: animate ? secondaryAccentColor.opacity(0.7) : Color.accentColor.opacity(0.7),
                    radius: animate ? 30 : 10,
                    x: 0.0,
                    y: animate ? 50 : 30
                )
                .scaleEffect(animate ? 1.1 : 1.0)
                .offset(y: animate ? -7 : 0)

                Text("Tip: You can always reorganize items later with Edit in the top-left corner.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: 400)
            .padding(40)
//            .onAppear(perform: addAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}

struct NoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoItemsView()
                .navigationTitle("Title")
        }
    }
}
