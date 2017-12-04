//
//  TodayViewController.swift
//  RaiToday
//
//  Created by Zack Shapiro on 11/11/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

import UIKit
import NotificationCenter
import Cartography


struct XRBPair: Codable {

    let pairs: [String: Pair]

    var xrbPair: Pair {
        return pairs.filter { $0.key == "XRB_BTC" }.first!.value
    }

    struct Pair: Codable {
        let last: String
    }

}


class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var label: UILabel!
    
    func getPriceAndSetLabel() {
        guard let url = URL(string: "https://mercatox.com/public/json24") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else { return }


            if let data = data, let xrb = try? JSONDecoder().decode(XRBPair.self, from: data) {
                DispatchQueue.main.async {
                    self.label.text = xrb.xrbPair.last
                }
            } else {
                print("failed")
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        getPriceAndSetLabel()
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}
