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
        var tweets = [TwitterSentementInput]()
        var sentimentScore = 0
        if let searchText = textField.text {
            swifter?.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended, success: { result, metadata in
                for i in 0 ..< 100 {
                    if let tweet = result[i]["full_text"].string {
                        let tweetForClassification = TwitterSentementInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                
                do {
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
                } catch {
                    print("There was an error with the Twitter API Request, \(error)")
                }
            }, failure: { error in
                print("There was an error with the Twitter API Request, \(error)")
            })
        }
    }
    
}

