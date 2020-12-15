//
//  BoardView.swift
//  WordGame
//
//  Created by Luisa Cruz Molina on 08.12.20.
//

import SwiftUI
import ComposableArchitecture

struct BoardView: View {
    
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack{
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "crown.fill").font(.largeTitle)
                            .foregroundColor(Color("Flame"))
                        
                        Text("\(viewStore.score)").font(.largeTitle)
                            .fontWeight(.black)
                            .transition(.scale)
                            .id("Score-\(viewStore.score)" )
                    }
                    .padding(.trailing, 33)
                    .padding(.top, 100)
                    
                    Spacer()
                    Text("\((viewStore.learningLanguage == .spanish ? viewStore.wordState.mainWord?.spanish : viewStore.wordState.mainWord?.english) ?? "--")")
                        .fontWeight(.heavy)
                        .font(.title)
                        .padding()
                    
                    Text("\((viewStore.learningLanguage == .spanish ? viewStore.wordState.translation?.english : viewStore.wordState.translation?.spanish) ?? "--")").padding()
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            viewStore.send(.correctButtonTapped)
                        }, label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 77.0, weight: .bold))
                                .foregroundColor(Color("Correct"))
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            viewStore.send(.wrongButtonTapped)
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 77.0, weight: .bold))
                                .foregroundColor(Color("Incorrect"))
                        })
                    }.padding([.leading, .trailing, .bottom], 33)
                    
                }
                .background(Color("Bone"))
                .ignoresSafeArea(edges: .top)
                .onAppear { viewStore.send(.loadWords) }
                .foregroundColor(Color("Raisin Black"))
                
                if viewStore.isAWinner == .winner {
                    Image(systemName: "hands.sparkles.fill")
                        .font(.system(size: 200, weight: .bold))
                        .foregroundColor(Color("Correct"))
                } else if viewStore.isAWinner == .looser {
                    Image(systemName: "hand.thumbsdown.fill")
                        .font(.system(size: 200, weight: .bold))
                        .foregroundColor(Color("Incorrect"))
                }
                            }
            
        }.ignoresSafeArea(edges: [.top, .bottom])

    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(
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
