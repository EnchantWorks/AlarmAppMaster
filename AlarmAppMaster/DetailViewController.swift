//
//  DetailViewController.swift
//  AlarmAppMaster
//
//  Created by 奥山博史 on 2015/03/18.
//  Copyright (c) 2015年 奥山博史. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var _switch: UISwitch! //スイッチ
    @IBAction func changed(sender: UISwitch) {
        if _switch.on == false {
            showAlert("", text: "目覚ましかけろよ")
        }

    }
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.valueForKey("timeStamp")!.description
            }
        }
    }
    
    func showAlert(title: NSString?, text: NSString?){
        let alert = UIAlertController(title: title, message: text,preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

