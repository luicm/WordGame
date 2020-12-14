//
//  AppState.swift
//  WordGame
//
//  Created by Luisa Cruz Molina on 08.12.20.
//

import Foundation
import ComposableArchitecture


enum LearningLanguage: String, CaseIterable, Identifiable  {
    case spanish
    case english
    
    var id: String { self.rawValue }
}

enum GameResult {
    case winner
    case looser
    case unknown
}



/// Controls states and actions that concern logic or modification  of the app globally
struct AppState: Equatable {
    var words: [Word] = []
    var learningLanguage: LearningLanguage = .spanish // language we want to learn
    var score = 0 //points accumulated by the user
    let maxScore = 300 // once user reach 300 he/she will win the game.
    let maxNumberWordsGamed = 35
    var wordsGamedCount = 0
    var isAWinner: GameResult = .unknown
    
    var wrongTranslationsCount = 0 // counter that controls how many wrong translations have been shown
    var wrongTranslationsLimit = 3 // max number of wrong translation that can appear in a row
    
    var wordState = WordState()
}

enum AppAction: Equatable {
    case loadWords
    case loadWordsResponse(Result<[Word], WordClient.Failure>)
    case changeCurrentWord
    case correctButtonTapped
    case wrongButtonTapped
    case selectLanguage(LearningLanguage)
    case checkGameEnded
    case gameOver(winner: GameResult)
    case resetGame
    case wordAction(WordAction)
}

struct AppEnvironment {
    var wordClient: WordClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    wordReducer.pullback(
        state: \.wordState,
        action: /AppAction.wordAction,
        environment: { _ in WordEnvironment() }
    ),
    Reducer { (state, action, enviroment) in
        switch action {
        
        case .loadWords:
            return enviroment.wordClient
                .requestWords()
                .catchToEffect()
                .map(AppAction.loadWordsResponse)
            
        case let .loadWordsResponse(.success(words)):
            state.words = words
            return Effect(value: .changeCurrentWord)
            
        case .loadWordsResponse(.failure):
            return .none
            
        case .changeCurrentWord:
            guard
                let word = state.words.randomElement(),
                let translation = state.words.randomElement()
            else { return .none }

            //managed random
            if state.wordState.isTranslationCorrect {
                state.wrongTranslationsCount = 0
                state.wrongTranslationsLimit = Int.random(in: 1...4)
                
            } else {
                state.wrongTranslationsCount += 1
            }
            
            state.wordState.mainWord = word
            let forceCorrectTranslation = (state.wrongTranslationsCount == state.wrongTranslationsLimit)
            state.wordState.translation = forceCorrectTranslation ? word : translation
            
            state.wordsGamedCount += 1
            
            return .none
            
        case .correctButtonTapped:
            return Effect(value: .wordAction(.validate(answer: .correct)))
            
        case .wrongButtonTapped:
            return Effect(value: .wordAction(.validate(answer: .wrong)))
            
        case .selectLanguage(let language):
            state.learningLanguage = language
            return .none
            
        case .checkGameEnded:
            
            if state.score >= state.maxScore {
                return Effect(value: .gameOver(winner: .winner))
            }
            
            if state.wordsGamedCount < state.maxNumberWordsGamed {
                return Effect(value: .changeCurrentWord)
            } else {
                return Effect(value: .gameOver(winner: .looser))
            }
            
            
        case .gameOver( let winner):
            state.isAWinner = winner
            return .none
            
        case .resetGame:
            state.score = 0
            state.wordsGamedCount = 0
            state.wrongTranslationsCount = 0
            return .none
            
        case .wordAction(.validate):
            //managed score
            switch state.wordState.isAnswerCorrect {
            case .correct:
                state.score += 10
            case .wrong:
                state.score -= 5
            case .skip:
                state.score -= 1
            }
            return Effect(value: .checkGameEnded)
            
            
//        case .wordAction(_):
//            return .none
        }
    }.debug()
)

struct WordClient {
    var requestWords: () -> Effect<[Word], Failure>
    struct Failure: Error, Equatable {}
}


extension WordClient {
    static let local = WordClient(
        requestWords: {
            .result {
                let fileUrl = Bundle.main.url(forResource: "words", withExtension: "json")!
                let result = Result<[Word], Error> {
                    let data = try Data(contentsOf: fileUrl)
                    let words = try JSONDecoder().decode([Word].self, from: data)
                    return words
                }
                
                return result.mapError { _ in WordClient.Failure() }
            }
        }
    )
}
