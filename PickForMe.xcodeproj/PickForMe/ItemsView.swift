//
//  ItemsView.swift
//  PickForMe
//
//  Created by Daniel Jochum on 12/9/25.
//

import SwiftUI
import CoreData

struct ItemsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>

    @State private var newItem = ""
    @State private var showingClearAlert = false

    // Color palette
    let blue = Color(red: 60/255, green: 90/255, blue: 255/255)
    let green = Color(red: 0/255, green: 180/255, blue: 90/255)
    let red = Color(red: 255/255, green: 80/255, blue: 70/255)
    let yellow = Color(red: 255/255, green: 220/255, blue: 80/255)

    var body: some View {
        NavigationView {
            VStack {

                // Input bar
                HStack {
                    TextField("Enter item", text: $newItem)
                        .padding()
                        .background(yellow.opacity(0.15))
                        .cornerRadius(12)

                    Button(action: {
                        if !newItem.isEmpty {
                            addItem(name: newItem)
                            saveContext()
                            newItem = ""
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(blue)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                }
                .padding(.horizontal)

                // List of items
                List {
                    ForEach(items) { item in
                        HStack {
                            Text(item.name ?? "")
                                .font(.body)

                            Spacer()

                            // Delete button
                            Button(action: {
                                deleteItem(item)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(red)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Delete All
                Button(role: .destructive) {
                    showingClearAlert = true
                } label: {
                    Text("Delete All Items")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .alert("Delete ALL items?", isPresented: $showingClearAlert) {
                    Button("Delete", role: .destructive) { deleteAllItems() }
                    Button("Cancel", role: .cancel) {}
                }

            }
            .navigationBarTitle("Manage Items")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Manage Items")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
    }

    // Core Data Helpers

    private func addItem(name: String) {
        let newItem = Item(context: viewContext)
        newItem.name = name
        newItem.timestamp = Date()
    }

    private func saveContext() {
        do { try viewContext.save() }
        catch { print("Error saving context: \(error.localizedDescription)") }
    }

    private func deleteItem(_ item: Item) {
        viewContext.delete(item)
        saveContext()
    }

    private func deleteAllItems() {
        for item in items {
            viewContext.delete(item)
        }
        saveContext()
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
