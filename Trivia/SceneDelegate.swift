//
//  SceneDelegate.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

      func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
                 options connectionOptions: UIScene.ConnectionOptions) {
          
          guard let windowScene = (scene as? UIWindowScene) else { return }
          
          window = UIWindow(windowScene: windowScene)
          
          let questions = [
              ("What is 2 + 2?", ["1", "2", "3", "4"], 3),
              ("What color is the sky?", ["Blue", "Red", "Green", "Yellow"], 0),
              ("Which is a fruit?", ["Carrot", "Apple", "Potato", "Celery"], 1)
          ]
          
          class QuizState {
              var currentQuestionIndex = 0
              var score = 0
          }
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
          
          window?.rootViewController = UINavigationController(rootViewController: rootVC)
          window?.makeKeyAndVisible()
          
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
        func sceneDidDisconnect(_ scene: UIScene) {
            // Called as the scene is being released by the system.
            // This occurs shortly after the scene enters the background, or when its session is discarded.
            // Release any resources associated with this scene that can be re-created the next time the scene connects.
            // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        }
        
        func sceneDidBecomeActive(_ scene: UIScene) {
            // Called when the scene has moved from an inactive state to an active state.
            // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        }
        
        func sceneWillResignActive(_ scene: UIScene) {
            // Called when the scene will move from an active state to an inactive state.
            // This may occur due to temporary interruptions (ex. an incoming phone call).
        }
        
        func sceneWillEnterForeground(_ scene: UIScene) {
            // Called as the scene transitions from the background to the foreground.
            // Use this method to undo the changes made on entering the background.
        }
        
        func sceneDidEnterBackground(_ scene: UIScene) {
            // Called as the scene transitions from the foreground to the background.
            // Use this method to save data, release shared resources, and store enough scene-specific state information
            // to restore the scene back to its current state.
        }
        
        


