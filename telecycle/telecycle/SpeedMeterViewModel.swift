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

protocol ViewModelProtocol {
    
}

struct RidingData {
    var speed : Int
    var distance : Int
    var timeInterval : TimeInterval
    
    init(speed: Int, distance: Int, timeInterval : TimeInterval) {
        self.speed = speed;
        self.distance = distance;
        self.timeInterval = timeInterval;
    }
}

class SpeedMeterViewModel : GeoDataDelegate {
    
    let ridingDataVariable : Variable<RidingData> = Variable(RidingData(speed: 0, distance :0, timeInterval : Date().timeIntervalSinceNow))
    
    init() {
        GeoData.sharedInstance.delegate = self
    }
    var startDate : Date = Date()
    
    func tracingLocation(currentLocation: CLLocation) {
        let speed = Int(GeoData.sharedInstance.getSpeed())
        let distance = Int(GeoData.sharedInstance.getDistance())
        let timeInterval = startDate.timeIntervalSinceNow
        ridingDataVariable.value = RidingData(speed: speed, distance :distance, timeInterval : timeInterval)
        Speaker.shareInstance.speakIfNeeded(speed: speed, distance: distance)
        
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print("Error!!")
    }
}

