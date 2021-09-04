//
//  Util.swift
//  Toilets
//
//  Created by Muhammad Mehdi Raza on 4/6/20.
//  Copyright © 2020 Muhammad Mehdi Raza. All rights reserved.
//

import UIKit

var aView: UIView?

extension UITableViewController {
    
    //function used to show Activity Indictor while loading table view
    func showSpinner(){
        let aView = UIView(frame: self.view.bounds)
        aView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = aView.center
        ai.startAnimating()
        aView.addSubview(ai)
        self.view.addSubview(aView)
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false){ (t) in
            ai.stopAnimating()
            ai.hidesWhenStopped = true
            aView.isHidden = true
        }
    }
}
