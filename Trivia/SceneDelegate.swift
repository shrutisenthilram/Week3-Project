//
//  SceneDelegate.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    class QuizState {
        var currentQuestionIndex = 0
        var score = 0
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let triviaService = TriviaQuestionService()
        
        triviaService.fetchQuestions { questions in
            guard let questions = questions else { return }
            
            DispatchQueue.main.async {
                let quizState = QuizState()
                let rootVC = UIViewController()
                rootVC.view.backgroundColor = .white
                
                let progressLabel = UILabel()
                progressLabel.textAlignment = .center
                progressLabel.font = UIFont.systemFont(ofSize: 16)
                
                let questionLabel = UILabel()
                questionLabel.numberOfLines = 0
                questionLabel.textAlignment = .center
                questionLabel.font = UIFont.boldSystemFont(ofSize: 24)
                
                var buttons: [UIButton] = []
                for i in 0..<4 {
                    let button = UIButton(type: .system)
                    button.tag = i
                    button.backgroundColor = .systemBlue
                    button.setTitleColor(.white, for: .normal)
                    button.layer.cornerRadius = 8
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                    buttons.append(button)
                    rootVC.view.addSubview(button)
                }
                
                rootVC.view.addSubview(progressLabel)
                rootVC.view.addSubview(questionLabel)
                
                self.window?.rootViewController = UINavigationController(rootViewController: rootVC)
                self.window?.makeKeyAndVisible()
                
                let screenBounds = windowScene.screen.bounds
                
                progressLabel.frame = CGRect(x: 20, y: 60, width: screenBounds.width - 40, height: 20)
                questionLabel.frame = CGRect(x: 20, y: 90, width: screenBounds.width - 40, height: 100)
                
                let buttonWidth: CGFloat = 250
                let buttonHeight: CGFloat = 50
                let buttonSpacing: CGFloat = 15
                var buttonY = questionLabel.frame.maxY + 30
                
                for button in buttons {
                    button.frame = CGRect(
                        x: (screenBounds.width - buttonWidth) / 2,
                        y: buttonY,
                        width: buttonWidth,
                        height: buttonHeight
                    )
                    buttonY += buttonHeight + buttonSpacing
                }
                
                func showQuestion() {
                    if quizState.currentQuestionIndex < questions.count {
                        let (q, answers, _) = questions[quizState.currentQuestionIndex]
                        progressLabel.text = "Question \(quizState.currentQuestionIndex + 1) of \(questions.count)"
                        questionLabel.text = q
                        
                        for i in 0..<buttons.count {
                            buttons[i].setTitle(answers[i], for: .normal)
                            buttons[i].isHidden = false
                        }
                    } else {
                        progressLabel.text = "Quiz Complete"
                        questionLabel.text = "You scored \(quizState.score) out of \(questions.count)!"
                        for i in 0..<buttons.count {
                            buttons[i].isHidden = (i != 0)
                        }
                        buttons[0].setTitle("Restart Quiz", for: .normal)
                    }
                }
                
                for button in buttons {
                    button.addAction(UIAction(handler: { _ in
                        if quizState.currentQuestionIndex < questions.count {
                            let correctIndex = questions[quizState.currentQuestionIndex].2
                            if button.tag == correctIndex {
                                quizState.score += 1
                            }
                            quizState.currentQuestionIndex += 1
                            showQuestion()
                        } else {
                            quizState.currentQuestionIndex = 0
                            quizState.score = 0
                            showQuestion()
                        }
                    }), for: .touchUpInside)
                }
                
                showQuestion()
            }
        }
    }
}
