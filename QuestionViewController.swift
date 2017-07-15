//
//  QuestionViewController.swift
//  Solve 1337
//
//  Created by Daniel Meechan on 01/07/2017.
//  Copyright © 2017 Rogue Studios. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    var user:User = User()
    var questions:[Question] = [Question]()
    var questionStats:[QuestionStats] = [QuestionStats]()
    var transitionTime = 1.5
    var timer:Timer = Timer()

    @IBOutlet weak var questionNumLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var answerField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        // Stop timer
        timer.invalidate()
        
    }
    
    @IBAction func hintBtnClicked(_ sender: Any) {
        useHint()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        submitGuess()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create fresh user if user doesn't already exist
        user = User()
        
        // Import questions and questionStats
        importTestData()
        
        updateUI()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(QuestionViewController.runTimer), userInfo: nil, repeats: true)
    }
    
    func updateUI() {
        
        // Update question number count to current question num
        questionNumLabel.text = "\(user.questionNum + 1) / 1337"
        
        // Start question timer
        // TODO
        
        // Update question text
        questionLabel.text = questions[user.questionNum].question
        
        // Clear answer field
        answerField.text = ""
        
        // Hide keyboard
        // TODO
        
        // Update hintButton hint counter text
        hintButton.setTitle("Hints: \(user.hintsNum)", for: .normal)
        
        // Update submit button
        submitButton.setTitle("Submit", for: .normal)
        
        // Clear hint text and then append hints on the end if user has used any
        hintLabel.text = ""
        
        if questionStats[user.questionNum].hintsUsed > 0 {
            var i = 0
            
            while i < questionStats[user.questionNum].hintsUsed {
                hintLabel.text?.append(questions[user.questionNum].hint[i])
                i += 1
            }
            
        }
        
        setUIMode(0)
        
    }
    
    func runTimer() {
        
        questionStats[user.questionNum].timeTaken += 1
        let totalSeconds = questionStats[user.questionNum].timeTaken
        let mins = floor(Double(totalSeconds / 60))
        let secs = totalSeconds % 60
        
        timerLabel.text = String(format: "%02d", Int(mins)) + ":" + String(format: "%02d", Int(secs))
        
    }
    
    func submitGuess() {
        // Use lower-case format for guess
        let guess:String = (answerField.text?.lowercased())!
        
        var correct:Bool = false
        
        var i = 0
        
        // Loop through all allowed answers to see if one is correct
    
        
        while correct == false && i < questions[user.questionNum].answer.count {

            if (guess == questions[user.questionNum].answer[i].lowercased()) {
                correct = true
                
            }
            
            i += 1
            
        }
        
        if correct == true {
            // Guess is correct
            
            questionStats[i].completed = true
            user.questionNum += 1
            user.questionsSinceAd += 1
            
            setUIMode(1)
            submitButton.setTitle("Correct!", for: .normal)
            
            // After 0.3 seconds, update the UI for the next question
            Timer.scheduledTimer(timeInterval: transitionTime, target:self, selector: #selector(QuestionViewController.updateUI), userInfo: nil, repeats: false)
            
            
            // Save how long it took to do
            // TODO
            
        } else {
            // Guess is wrong
            
            questionStats[i].incorrectGuesses += 1
            
            setUIMode(2)
            submitButton.setTitle("Try again :)", for: .normal)
            
            // Then change it back after 3 seconds
            Timer.scheduledTimer(timeInterval: transitionTime, target:self, selector: #selector (QuestionViewController.setUIModeDefault), userInfo: nil, repeats: false)
            
        }
        
    }
    
    func setUIModeDefault() {
        setUIMode(0)
        submitButton.setTitle("Submit", for: .normal)
    }
    
    func setUIMode(_ mode:Int) {
        // 0 = default
        // 1 = correct
        // 2 = incorrect
        
        if mode == 0 {
            
            // Answer field: midnight blue
            answerField.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
            
            // Background colour: wet asphalt
            self.view.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
            
            
        } else if mode == 1 {
            
            // Answer field: silver
            answerField.backgroundColor = UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.0)
            
            // Background colour: clouds
            self.view.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
            
        } else if mode == 2 {
            
            // Tall poppy
            answerField.backgroundColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
            
            // Old brick
            self.view.backgroundColor = UIColor(red:0.59, green:0.16, blue:0.11, alpha:1.0)
        }
    }
    
    func useHint() {
        
        // Check user has some hints left
        if user.hintsNum > 0 {
            let qNum:Int = user.questionNum
            
            if questionStats[qNum].hintsUsed < questions[qNum].hint.count {
                // The question still has some hints left
                user.hintsNum -= 1
                questionStats[qNum].hintsUsed += 1
                
                // Add a line break
                // TODO
                // Doesn't work...
                hintLabel.text?.append("\n")
                
                // Add latest hint into it (-1 because it's in an array from 0)
                hintLabel.text?.append("ok pls work \n\(questions[user.questionNum].hint[questionStats[qNum].hintsUsed - 1])")
                
                updateUI()
                
            } else {
                // Question has run out of hints
                // Display error message
                // TODO
                
                createAlert(title: "Oops, this question has no more hints left!", message: "", acceptanceText: "Ok, I'll keep trying!")
                
            }
            
        } else {
            // Handle when the user has no hints left
            // TODO
            let watchAd = createChoiceAlert(title: "Oops, you've run out of hints!", message: "Would you like to watch an ad to unlock more now?", choiceYes: "Absolutely!", choiceNo: "Maybe later")
            
            if watchAd {
                
            } else {
                
            }
            
        }
    }
    
    func displayAdCheck() {
        if user.questionsSinceAd > 4 {
            
        }
    }
    
    
    func importTestData() {
        questions.append(Question(question: "What is an apple?", hint: ["Life.", "Life 2"], answer: ["Fruit", "A fruit"], number: 0))
        
        questions.append(Question(question: "What is 'banana'?", hint: ["Fruit of vegetable?", "It is itself"], answer: ["Banana", "A banana"], number: 1))
        
        questions.append(Question(question: "What is a carrot?", hint: ["Vegetable?", "Yes."], answer: ["Vegetable", "A vegetable"], number: 2))
        
        questionStats.append(QuestionStats(number: 0, completed: false, incorrectGuesses: 0, hintsUsed: 0, timeTaken: 0))
        questionStats.append(QuestionStats(number: 1, completed: false, incorrectGuesses: 0, hintsUsed: 0, timeTaken: 0))
        questionStats.append(QuestionStats(number: 2, completed: false, incorrectGuesses: 0, hintsUsed: 0, timeTaken: 0))
        
    }
    
    func createAlert(title: String, message: String, acceptanceText: String){
        
        // Create alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: acceptanceText, style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createChoiceAlert(title: String, message: String, choiceYes: String, choiceNo: String) -> Bool {
        // Create alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        var result = false;
        
        // Create choices
        
        alert.addAction(UIAlertAction(title: choiceNo, style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            result = false
            
        }))
        
        alert.addAction(UIAlertAction(title: choiceYes, style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            result = true
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        print("RESULT IS: " + String(result))
        return result
        
    }

}

struct Question {
    let question:String
    let hint:[String]
    let answer:[String]
    let number:Int
    
}

struct QuestionStats {
    let number:Int
    var completed:Bool
    var incorrectGuesses:Int
    var hintsUsed:Int
    var timeTaken:Int
    
}

struct User {
    var questionNum:Int
    var startDate:Date
    var hintsNum:Int
    var questionsSinceAd:Int
    var hintsUnlockable:Bool
    
    init(questionNum: Int, startDate: Date, hintsNum: Int, questionsSinceAd: Int, hintsUnlockable: Bool) {
        self.questionNum = questionNum
        self.startDate = startDate
        self.hintsNum = hintsNum
        self.questionsSinceAd = questionsSinceAd
        self.hintsUnlockable = hintsUnlockable
    
    }
    
    init() {
        self.questionNum = 0
        self.startDate = Date()
        self.hintsNum = 3
        self.questionsSinceAd = 0
        self.hintsUnlockable = true
        
    }
    
}
