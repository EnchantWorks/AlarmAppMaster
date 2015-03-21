//
//  DetailViewController.swift
//  AlarmAppMaster
//
//  Created by 奥山博史 on 2015/03/18.
//  Copyright (c) 2015年 奥山博史. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var _player = [AVAudioPlayer]()
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var _switch: UISwitch! //スイッチ部品の接続
    var _pickersrow:Int = 0
    var timer: NSTimer?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func changed(sender: UISwitch) {//スイッチがon,offの切り替えに関するメソッド
        if _switch.on == true {
            setPickerEnabled(false, pick: false)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            }else{
            setPickerEnabled(true, pick: true)
            _player[_pickersrow].stop()
        }

    }
    
    func update(){
        var now = NSDate()
        myDateFormatter.dateFormat = "hh:mm"
        var nowDate: NSString = myDateFormatter.stringFromDate(now)
        if mySelectedDate == nowDate {
            showAlert("", text: "試しに鳴らしてみた")
            _player[_pickersrow].numberOfLoops = 999
            _player[_pickersrow].currentTime = 0
            _player[_pickersrow].play()
        }
    }
    let myDateFormatter: NSDateFormatter = NSDateFormatter()
    var mySelectedDate: NSString = ""
    @IBAction func onDidChangeDate(sender: UIDatePicker){
        myDateFormatter.dateFormat = "hh:mm"
        mySelectedDate = myDateFormatter.stringFromDate(sender.date)
    }
    
    /************UIPicker************/
    @IBOutlet weak var _picker: UIPickerView!
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*表示するデータ数を返す.*/
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myValues.count
    }
    
    /*値を代入する.*/
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return myValues[row] as String
    }
    
    /*Pickerが選択された際に呼ばれる.*/
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _pickersrow = row
        println("row: \(row)")
        println("value: \(myValues[row])")
    }
    
    // 表示する値の配列.
    var myValues: NSArray = ["アラーム１","アラーム2"]
    /*************************************************/
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
    
    
    //アラートの表示メソッド
    func showAlert(title: NSString?, text: NSString?){
        let alert = UIAlertController(title: title, message: text,preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //プレイヤーの生成
        self.configureView()
        _player.append(makeAudioPlayer("Alarm1.mp3"))
        _player.append(makeAudioPlayer("Alarm2.mp3"))
        setPickerEnabled(true, pick: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //オーディオプレイヤーの生成
    func makeAudioPlayer(res:String) -> AVAudioPlayer{
        let path = NSBundle.mainBundle().pathForResource(res, ofType: "")
        let url = NSURL.fileURLWithPath(path!)
        
        return AVAudioPlayer(contentsOfURL: url, error: nil)
    }
    
    func setPickerEnabled(date:Bool, pick:Bool) {
        self.datePicker.userInteractionEnabled = date
        self._picker.userInteractionEnabled = pick
    }
}

