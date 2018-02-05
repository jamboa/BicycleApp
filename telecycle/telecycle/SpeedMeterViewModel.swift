//
//  SpeedMeterViewModel.swift
//  telecycle
//
//  Created by yoojonghyun on 2018. 2. 4..
//  Copyright © 2018년 yoojonghyun. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class SpeedMeterViewModel : GeoDataDelegate {
    
    static let sharedInstance: SpeedMeterViewModel = SpeedMeterViewModel()
    
    let speedVariable : Variable<Int> = Variable(0)
    let distanceVariable : Variable<Int> = Variable(0)
    let timeIntervalVariable : Variable<TimeInterval> = Variable(Date().timeIntervalSinceNow)
    
    
    init() {
        GeoData.sharedInstance.delegate = self
    }
    var startDate : Date = Date()
    
    func tracingLocation(currentLocation: CLLocation) {
        speedVariable.value = Int(GeoData.sharedInstance.getSpeed())
        distanceVariable.value = Int(GeoData.sharedInstance.getDistance())
        timeIntervalVariable.value = startDate.timeIntervalSinceNow
        
        Speaker.shareInstance.speakIfNeeded(speed: speedVariable.value, distance: distanceVariable.value)
        
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print("Error!!")
    }
}

