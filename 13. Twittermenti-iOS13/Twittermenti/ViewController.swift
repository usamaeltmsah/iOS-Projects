//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    var API_KEY: String!
    var API_KEY_SECRET: String!
    let tweetCount = 100
    
    let sentimentClassifier = try! TwitterSentement(configuration: MLModelConfiguration())
    var swifter: Swifter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nsDictionary: NSDictionary?
         if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            API_KEY = nsDictionary?.allValues[0] as? String
            API_KEY_SECRET = nsDictionary?.allValues[1] as? String
            swifter = Swifter(consumerKey: API_KEY, consumerSecret: API_KEY_SECRET)
            
         }
    }

    @IBAction func predictPressed(_ sender: Any) {
        fetchTweets()
    }
    
    func fetchTweets() {
        if let searchText = textField.text {
            swifter?.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended, success: { result, metadata in
                var tweets = [TwitterSentementInput]()
                for i in 0 ..< self.tweetCount {
                    if let tweet = result[i]["full_text"].string {
                        let tweetForClassification = TwitterSentementInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                
                self.makePrediction(with: tweets)
            }, failure: { error in
                print("There was an error with the Twitter API Request, \(error)")
            })
        }
    }
    
    func makePrediction(with tweets: [TwitterSentementInput]) {
        do {
            var sentimentScore = 0
            let  predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            
            for pred in predictions {
                switch pred.label {
                case "Positive":
                    sentimentScore += 1
                case "Negative":
                    sentimentScore -= 1
                default:
                    continue
                }
            }
            updateUI(with: sentimentScore)
        } catch {
            print("There was an error with the Twitter API Request, \(error)")
        }
    }
    
    func updateUI(with sentimentScore: Int) {
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😀"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "🙁"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
    }
}

