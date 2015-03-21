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
    var _player = [AVAudioPlayer]() //音楽再生のプレイヤー
    let dateFormatter: NSDateFormatter = NSDateFormatter() //日付のフォーマットを決めるもの
    @IBOutlet weak var detailDescriptionLabel: UILabel! //これは知らん
    @IBOutlet weak var _switch: UISwitch! //スイッチ部品の接続
    var _pickersrow:Int = 0 //アラーム音のピッカーが何番目の曲を指しているか
    var timer: NSTimer? //１秒周期で現在時刻を計測するために使う
    @IBOutlet weak var datePicker: UIDatePicker! //datepickerのoutlet
    @IBAction func changed(sender: UISwitch) { //スイッチのon,offの切り替えに関するメソッド
        if _switch.on == true {
            setPickerEnabled(false, pick: false) //スイッチがonならpickerの操作を出来ないようにする
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)//このメソッドでupdate()を１秒に１回実行する（実際にはセットした時間までは特に何も起きない）
        }else{
            setPickerEnabled(true, pick: true)//スイッチがオフなのでpickerの操作を可能に
            _player[_pickersrow].stop()//曲を止める
        }

    }
    
    func update(){
        var now = NSDate()//現在時刻
        myDateFormatter.dateFormat = "hh:mm"//ここで時間のフォーマットを”何時:何分”としている
        var nowDate: NSString = myDateFormatter.stringFromDate(now)//現在時刻を”何時:何分”というフォーマットに変換
        if mySelectedDate == nowDate {//セットした時間になったら起動
            _player[_pickersrow].numberOfLoops = 999//ループ回数
            _player[_pickersrow].currentTime = 0//曲のスタート時間
            _player[_pickersrow].play()//曲の始まり
            timer?.invalidate()//タイマーを切るためのもの、この文と下の文がないとアラームが永遠に鳴り続ける
            timer = nil
        }
    }
    
    /**************UIDatePicker*****************/
    
    let myDateFormatter: NSDateFormatter = NSDateFormatter()
    var mySelectedDate: NSString = ""
    @IBAction func onDidChangeDate(sender: UIDatePicker){
        myDateFormatter.dateFormat = "hh:mm"
        mySelectedDate = myDateFormatter.stringFromDate(sender.date)//datepickerでセットした時間を取得
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
    var myValues: NSArray = ["アラーム１","アラーム2","おまけ１","おまけ２"]
    
    /*************************************************/
    
    //ここら辺は知らん
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
    
    
    //アラートの表示メソッド　今は使ってないけど、のちのち使うかもと思って置いてある
    func showAlert(title: NSString?, text: NSString?){
        let alert = UIAlertController(title: title, message: text,preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {//DetailViewに遷移してきた時に行われるもの
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        //プレイヤーの生成
        _player.append(makeAudioPlayer("Alarm1.mp3"))
        _player.append(makeAudioPlayer("Alarm2.mp3"))
        _player.append(makeAudioPlayer("Alarm3.mp3"))
        _player.append(makeAudioPlayer("Alarm4.mp3"))
        
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
    
    //Pickerの有効化/無効化
    func setPickerEnabled(date:Bool, pick:Bool) {
        self.datePicker.userInteractionEnabled = date
        self._picker.userInteractionEnabled = pick
    }
}

