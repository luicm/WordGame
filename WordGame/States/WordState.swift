//
//  WordState.swift
//  WordGame
//
//  Created by Luisa Cruz Molina on 10.12.20.
//

import Foundation
import ComposableArchitecture

enum Answer {
    case correct
    case wrong
    case skip
}


/// Holds the logic related to the word that is going to be translated
struct WordState: Equatable {
    
    var mainWord: Word?
    var translation: Word?
    var isTranslationCorrect: Bool {
        guard
            mainWord != nil,
            translation != nil else { return false }
        return mainWord == translation
    }
    var isAnswerCorrect: Answer = .skip
}

enum WordAction: Equatable {
    case validate(answer: Answer)
}

struct WordEnvironment {}

let wordReducer: Reducer<WordState, WordAction, WordEnvironment> = Reducer { (state, action, _) in
    switch action {
    
    case .validate(let answer):
        switch answer {
        
        case .correct:
            state.isAnswerCorrect = state.isTranslationCorrect
                ? .correct
                : .wrong
            
        case .wrong:
            state.isAnswerCorrect = state.isTranslationCorrect
                ? .wrong
                : .correct
            
        case .skip:
            state.isAnswerCorrect = .skip
        }
        return .none
    }
}

