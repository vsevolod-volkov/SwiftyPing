//
//  ViewController.swift
//  SwiftyPingTest
//
//  Created by Sami Yrjänheikki on 20/09/2018.
//  Copyright © 2018 Sami Yrjänheikki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = ""
    }
    
    @IBAction func start(_ sender: Any) {
        startPinging()
    }
    @IBAction func stop(_ sender: Any) {
        ping?.stopPinging()
    }
    var ping: SwiftyPing?
    func startPinging() {
        do {
            ping = try SwiftyPing(host: "1.1.1.1", configuration: PingConfiguration(interval: 1.0, with: 1), queue: DispatchQueue.global())
        } catch {
            textView.text = error.localizedDescription
        }
        ping?.observer = { (response) in
            DispatchQueue.main.async {
                var message = "\(response.duration * 1000) ms"
                if let error = response.error {
                    if error == .responseTimeout {
                        message = "Timeout \(message)"
                    } else {
                        message = error.localizedDescription
                    }
                }
                self.textView.text.append(contentsOf: "\nPing #\(response.sequenceNumber): \(message)")
                self.textView.scrollRangeToVisible(NSRange(location: self.textView.text.count - 1, length: 1))
            }
        }
//        ping?.targetCount = 1
        ping?.startPinging()
    }

}

