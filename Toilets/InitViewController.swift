//
//  InitViewController.swift
//  Toilets
//
//  Created by Muhammad Mehdi Raza on 25/5/20.
//  Copyright © 2020 Muhammad Mehdi Raza. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {
    
    //instance variables for filters
    var male = true
    var female = true
    var wheelchair = true
    var baby = false

    //action function for male switch
    @IBAction func maleSwitch(_ sender: UISwitch) {
        
        if (sender.isOn == true)
        {
            male = true
        }
        else
        {
            male = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //action function for female switch
    @IBAction func femaleSwitch(_ sender: UISwitch) {
        
        if (sender.isOn == true)
        {
            female = true
        }
        else
        {
            female = false
        }
    }
    
    //action function for wheelchair switch

    @IBAction func wheelchairSwitch(_ sender: UISwitch) {
        
        if (sender.isOn == true)
        {
            wheelchair = true
        }
        else
        {
            wheelchair = false
        }
    }
    
    //action function for baby_facility switch

    @IBAction func babySwitch(_ sender: UISwitch) {
        
        if (sender.isOn == true)
        {
            baby = true
        }
        else
        {
            baby = false
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    @IBAction func searchButton(_ sender: Any) {
        
    }
    
    //sending users choices of filters to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let tableViewController = segue.destination as? TableViewController {
            tableViewController.male = male
            tableViewController.female = female
            tableViewController.wheelchair = wheelchair
            tableViewController.baby = baby
        }
    }
}
    
