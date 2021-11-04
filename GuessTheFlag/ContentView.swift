//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Peter Molnar on 14/10/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var userScore = 0
    @State private var userSelected = 0
    
    @State private var rotationDegree = 0.0
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
                            self.flagTapped()
                        }
                       
                    }) {
                        FlagImage(countryName: self.countries[number])
                    }
                    .rotation3DEffect(number == userSelected ? .degrees(rotationDegree) : .zero, axis: (x: 0, y: 1, z: 0))
                    .opacity(number == userSelected ? 1.0 : notSelectedOpacity)
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
        notSelectedOpacity = 1.0
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
