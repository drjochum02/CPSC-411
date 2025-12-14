//
//  WheelView.swift
//  PickForMe
//
//  Created by Daniel Jochum on 12/10/25.
//

import SwiftUI
import CoreData

struct WheelView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default
    )
    private var items: FetchedResults<Item>

    @State private var selectedIndex = 0
    @State private var lastSelected: String? = nil

    // Color Palette
    let redColor     = Color(red: 0.90, green: 0.20, blue: 0.20)
    let blueColor    = Color(red: 0.20, green: 0.40, blue: 0.90)
    let greenColor   = Color(red: 0.20, green: 0.75, blue: 0.35)
    let yellowColor  = Color(red: 0.95, green: 0.85, blue: 0.25)

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {

                // Wheel
                Picker("Items", selection: $selectedIndex) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Text(items[index].name ?? "")
                            .foregroundColor(blueColor)
                            .tag(index)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 200)
                .clipped()
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(yellowColor.opacity(0.6), lineWidth: 3)
                )
                .padding(.horizontal)

                // Selected Item
                if let lastSelected = lastSelected {
                    Text("Selected: \(lastSelected)")
                        .font(.title2)
                        .bold()
                        .padding(.top, 4)
                        .foregroundColor(greenColor)
                }

                // Spin Button
                Button(action: spinWheel) {
                    Text("Spin")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(blueColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: blueColor.opacity(0.4), radius: 4)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .navigationBarTitle("Picker Wheel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Picker Wheel")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }            .foregroundColor(blueColor)
        }
    }

    // Spin Logic
    private func spinWheel() {
        guard items.count > 0 else { return }

        let finalIndex = Int.random(in: 0..<items.count)
        spinAnimation(to: finalIndex)
    }

    private func spinAnimation(to target: Int) {
        let totalTicks = 25
        let maxDelay = 0.12
        let minDelay = 0.02

        for i in 0..<totalTicks {
            let progress = Double(i) / Double(totalTicks)
            let delay = minDelay + (maxDelay - minDelay) * progress

            DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(i)) {

                if items.count > 0 {
                    selectedIndex = (selectedIndex + 1) % items.count
                }

                if i == totalTicks - 1 {
                    selectedIndex = target
                    lastSelected = items[target].name
                }
            }
        }
    }
}

struct WheelView_Previews: PreviewProvider {
    static var previews: some View {
        WheelView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
