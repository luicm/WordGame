//
//  ContentView.swift
//  WordGame
//
//  Created by Luisa Cruz Molina on 07.12.20.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    let store: Store<AppState, AppAction>
    @State var showGame = false
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Color("Bone").ignoresSafeArea(edges: [.top, .bottom])
                
                VStack {
                    Spacer()
                    Text("Word Game")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(red: 212/255, green: 100/255, blue: 53/255))
                    Spacer()
                    Group {
                        
                        Text("Play fast and answer if word and translation are a correct match!.")
                        Text("Win the game by reaching 300 points in less than 35 words")
                        Text("Loose the game when you reach 35 words without the needed points")
                        Text("You have 4 seconds per word")
                        Text("Good luck!!").bold()
                        Rectangle()
                            .frame(width: 200, height: 1, alignment: .center)
                            .foregroundColor(Color("Raisin Black"))
                        Text("""
    Correct answer: + 10 points
    Incorrect answer: - 5 points
    Skip answer: - 5 points
    """).padding(.bottom, 12)
                    }
                    .padding([.leading, .trailing], 24)
                    .padding(.bottom, 4)
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    
                    Text("I want to learn:")
                        .font(.title2).bold()
                        .padding(.bottom, 8)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showGame.toggle()
                            viewStore.send(.selectLanguage(.spanish))
                        }) {
                            Text("Spanish").bold()
                        }.sheet(isPresented: $showGame, onDismiss: {
                            viewStore.send(.resetGame)
                        }) {
                            BoardView(store: store)
                        }.buttonStyle(StartButtonStyle())
                        
                        Spacer()
                        
                        Button(action: {
                            self.showGame.toggle()
                            viewStore.send(.selectLanguage(.english))
                        }) {
                            Text("English").bold()
                        }.sheet(isPresented: $showGame, onDismiss: {
                            viewStore.send(.resetGame)
                        }) {
                            BoardView(store: store)
                        }
                        .buttonStyle(StartButtonStyle())
                        Spacer()
                    }
                    .padding(.bottom, 12)
                    Spacer()
                    Text("Note: If you close the game, it will restart").bold()
                }
                .onAppear { viewStore.send(.loadWords) }
                .foregroundColor(Color("Raisin Black"))
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: AppState(),
                reducer: appReducer,
                environment: AppEnvironment(
                    wordClient: .local,
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}


struct StartButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 25)
            .background(Color("Cadet Blue"))
            .cornerRadius(7.0)
    }
}

