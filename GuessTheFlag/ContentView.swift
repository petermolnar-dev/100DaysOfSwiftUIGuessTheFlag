//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Peter Molnar on 14/10/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var userScore = 0
    @State private var userSelected = 0
    
    @State private var rotationDegree = 0.0
    @State private var notSelectedScaleAmount = 1.0
    @State private var notSelectedOpacity = 1.0
    
    var alertMessage: String {
        if isCorrectAnswer {
            return "Your score is: \(userScore)"
        } else {
            return "That’s the flag of \(countries[userSelected])"
        }
    }
    
    var isCorrectAnswer: Bool {
        userSelected == correctAnswer
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                Spacer()
                ForEach(0 ..< 3) { number in
                    Button (action: {
                        userSelected = number
                        withAnimation(
                            Animation.easeInOut(duration: 0.75)) {
                                self.rotationDegree += 360
                                self.notSelectedOpacity = 0.25
                                self.notSelectedScaleAmount = 0.45
                                self.flagTapped()
                            }
                        
                    }) {
                        FlagImage(countryName: self.countries[number])
                            .accessibilityLabel(labels[countries[number], default: "Unknown country"])
                    }
                    .rotation3DEffect(number == userSelected ? .degrees(rotationDegree) : .zero, axis: (x: 0, y: 1, z: 0))
                    .opacity(number == userSelected ? 1.0 : notSelectedOpacity)
                    .scaleEffect(number != userSelected ? notSelectedScaleAmount : 1.0)
                    
                }
                Spacer()
                Text("Your score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Spacer()
            }
            
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(alertMessage), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    
    func flagTapped() {
        if isCorrectAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong!"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        withAnimation(
            Animation.easeInOut(duration: 0.75)) {
                notSelectedScaleAmount = 1.0
                notSelectedOpacity = 1.0
            }
        
    }
}

struct FlagImage: View {
    var countryName: String
    
    var body: some View {
        Image(countryName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}
