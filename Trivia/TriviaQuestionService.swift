//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Shruti S on 7/8/25.
//

import Foundation

struct TriviaQuestion: Decodable {
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}

struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}

class TriviaQuestionService {
    func fetchQuestions(completion: @escaping ([(String, [String], Int)]?) -> Void) {
        let url = URL(string: "https://opentdb.com/api.php?amount=5&type=multiple")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { completion(nil); return }
            
            do {
                let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
                
                // Transform into (question, [answers], correctIndex)
                let result: [(String, [String], Int)] = decoded.results.map { q in
                    let allAnswers = ([q.correct_answer] + q.incorrect_answers).shuffled()
                    let correctIndex = allAnswers.firstIndex(of: q.correct_answer) ?? 0
                    return (q.question, allAnswers, correctIndex)
                }
                completion(result)
            } catch {
                print("Error decoding: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

