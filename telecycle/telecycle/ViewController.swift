//
//  ViewController.swift
//  telecycle
//
//  Created by yoojonghyun on 2017. 12. 9..
//  Copyright © 2017년 yoojonghyun. All rights reserved.
//

import UIKit
import CoreLocation
import RxCocoa
import RxSwift


class ViewController: UIViewController  {
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var oneButton: UIButton!
    
    var isTracing = false
    public var viewModel : SpeedMeterViewModel?
    let disposeBag = DisposeBag()
    
    @IBAction func onClicked(_ sender: Any) {
        if isTracing == false {
            oneButton.setTitle("Stop", for: UIControlState.normal)
            Speaker.shareInstance.speakString(header: "let's Start", number: "", tailer: "")
            stateLabel.text = "Running"
            GeoData.sharedInstance.startUpdatingLocation()
            
        } else if isTracing == true {
            oneButton.setTitle("Start", for: UIControlState.normal)
            Speaker.shareInstance.speakString(header: "Ok, Stop", number: "", tailer: "")
            GeoData.sharedInstance.stopUpdatingLocation()
            stateLabel.text = "Stopped"
        }
        
        isTracing = !isTracing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func setup() {
        guard let viewModelUnwrapped = viewModel else {
            return
        }
        
        viewModelUnwrapped.ridingDataVariable.asObservable()
        .subscribe({[weak self] ridingDataEvent in
            guard let ridingData = ridingDataEvent.element else { return }
            let speedString = String(describing : ridingData.speed)
            self?.speedLabel.text = speedString
            
            let distanceString = String(describing : ridingData.distance)
            self?.distLabel.text = distanceString
            
            var sec: Int = Int(0 - ridingData.timeInterval)
            var min: Int = 0
            if sec >= 60 {
                min = sec / 60
                sec = sec - min * 60
            }
            var hour: Int = 0
            if min >= 60 {
                hour = min / 60
                min = min - hour * 60
            }
            self?.timeLabel.text = String(hour) + "h " + String(min) + "m " + String(sec) + "s"
        })
        .disposed(by: disposeBag)
    }

}


