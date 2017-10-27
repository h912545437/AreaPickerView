//
//  ViewController.swift
//  AreaPickerView
//
//  Created by 贺思佳 on 2017/10/27.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var areaLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func chooseBtnClick() {
        AreaPickView.showChooseCityView { (province, city, town) in
            self.areaLabel.text = province + " " + city + " " + town
        }
    }
    @IBAction func levelTwoChooseBtnClick() {
        AreaPickView.showChooseCityView(level: 2, defaultAddress: nil) { (province, city, town) in
            self.areaLabel.text = province + " " + city + " " + town
        }
    }
    @IBAction func defaultAreaChooseBtnClick() {
        AreaPickView.showChooseCityView(level: 3, defaultAddress: ("湖北省","武汉市","洪山区")) { (province, city, town) in
            self.areaLabel.text = province + " " + city + " " + town
        }
    }
    
}

