//
//  ExtrasView.swift
//  PickForMe
//
//  Created by Daniel Jochum on 12/9/25.
//

import SwiftUI

struct ExtrasView: View {

    @State private var d6Result: Int? = nil
    @State private var d20Result: Int? = nil
    @State private var d100Result: Int? = nil
    @State private var coinResult: String? = nil

    // RNG
    @State private var minInput: String = ""
    @State private var maxInput: String = ""
    @State private var rngResult: Int? = nil
    @State private var showRangeError = false

    var body: some View {
        NavigationView {
            List {

                // Dice Section
                Section(header: Text("Dice").foregroundColor(.blue)) {

                    DiceRow(buttonText: "Roll D6",
                            result: $d6Result,
                            range: 1...6,
                            tint: .blue)

                    DiceRow(buttonText: "Roll D20",
                            result: $d20Result,
                            range: 1...20,
                            tint: .blue)

                    DiceRow(buttonText: "Roll D100",
                            result: $d100Result,
                            range: 1...100,
                            tint: .blue)
                }
                .listRowBackground(Color.blue.opacity(0.10))

                // Coin Flip Section
                Section(header: Text("Coin Flip").foregroundColor(.yellow)) {
                    VStack(spacing: 12) {

                        Button("Flip Coin") {
                            coinResult = Bool.random() ? "Heads" : "Tails"
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.yellow)

                        if let coinResult = coinResult {
                            Text("Result: \(coinResult)")
                                .font(.title2)
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.yellow.opacity(0.10))

                // RNG Section
                Section(header: Text("Random Number Generator").foregroundColor(.green)) {
                    VStack(spacing: 12) {

                        HStack {
                            TextField("Min", text: $minInput)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            TextField("Max", text: $maxInput)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        Button("Generate") {
                            generateRandomNumber()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)

                        if let rngResult = rngResult {
                            Text("Result: \(rngResult)")
                                .font(.title2)
                                .foregroundColor(.green)
                        }

                        if showRangeError {
                            Text("⚠️ Invalid range")
                                .foregroundColor(.red)
                                .font(.callout)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.green.opacity(0.10))
            }
            .navigationBarTitle("Extras")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Extras")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }        }
    }

    private func generateRandomNumber() {
        guard let min = Int(minInput),
              let max = Int(maxInput),
              min <= max else {
            showRangeError = true
            rngResult = nil
            return
        }

        showRangeError = false
        rngResult = Int.random(in: min...max)
    }
}

// Dice Row View
struct DiceRow: View {
    let buttonText: String
    @Binding var result: Int?
    let range: ClosedRange<Int>
    let tint: Color     

    var body: some View {
        VStack(spacing: 12) {
            Button(buttonText) {
                result = Int.random(in: range)
            }
            .buttonStyle(.borderedProminent)
            .tint(tint)

            if let result = result {
                Text("Result: \(result)")
                    .font(.title2)
                    .foregroundColor(tint)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ExtrasView_Previews: PreviewProvider {
    static var previews: some View {
        ExtrasView()
    }
}
