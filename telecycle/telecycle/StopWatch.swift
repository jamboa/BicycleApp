//
//  File.swift
//  telecycle
//
//  Created by Samuel Kim on 2018. 4. 19..
//  Copyright © 2018년 yoojonghyun. All rights reserved.
//

import Foundation

struct TimeIntervalObject: Equatable {
    var hours: Int
    var minutes: UInt
    var seconds: UInt
    var fraction: UInt
    
    init() {
        hours = 0
        minutes = 0
        seconds = 0
        fraction = 0
    }
    
    init(timeInterval: TimeInterval) {
        var interval = timeInterval
        
        hours = Int(interval / 3600.0)
        interval -= (TimeInterval(hours) * 3600)
        
        minutes = UInt(interval / 60.0)
        interval -= (TimeInterval(minutes) * 60)
        
        seconds = UInt(interval)
        interval -= TimeInterval(seconds)
        
        fraction = UInt(interval * 100)
    }
    
    static func +(a: TimeIntervalObject, b: TimeIntervalObject) -> TimeIntervalObject {
        var sum = TimeIntervalObject()
        sum.fraction = a.fraction + b.fraction
        if sum.fraction >= 100 {
            sum.fraction = sum.fraction - 100
            sum.seconds += 1
        }
        sum.seconds += a.seconds + b.seconds
        if sum.seconds >= 100 {
            sum.seconds = sum.seconds - 100
            sum.minutes += 1
        }
        sum.minutes += a.minutes + b.minutes
        if sum.minutes >= 100 {
            sum.minutes = sum.minutes - 100
            sum.hours += 1
        }
        sum.hours += a.hours + b.hours
        return sum
    }
    
    static func -(a: TimeIntervalObject, b: TimeIntervalObject) -> TimeIntervalObject {
        var diff = TimeIntervalObject()
        var a = a
        
        if a.fraction < b.fraction {
            a.fraction += 100
            a.seconds -= 1
        }
        diff.fraction = a.fraction - b.fraction
        
        if a.seconds < b.seconds {
            a.seconds += 100
            a.minutes -= 1
        }
        diff.seconds = a.seconds - b.seconds
        
        if a.minutes < b.minutes {
            a.minutes += 100
            a.hours -= 1
        }
        diff.minutes = a.minutes - b.minutes
        
        diff.hours = a.hours - b.hours
        
        return diff
    }
    
    static func ==(a: TimeIntervalObject, b: TimeIntervalObject) -> Bool {
        return a.fraction == b.fraction
            && a.seconds == b.seconds
            && a.minutes == b.minutes
            && a.hours == b.hours
    }
    
    func toTimeInterval() -> TimeInterval {
        var timeInterval: TimeInterval = 0
        timeInterval += Double(self.fraction) / 100.0
        timeInterval += Double(self.seconds) * 1.0
        timeInterval += Double(self.minutes) * 60.0
        timeInterval += Double(self.hours) * 3600.0
        return timeInterval
    }
}

protocol StopWatchDelgate {
    func doSomethingPeriodically(timeIntervalObject: TimeIntervalObject)
}

class StopWatch {
    
    private var timer: Timer?
    private var startTime: TimeInterval = 0
    
    var delegate: StopWatchDelgate!
    var period: TimeInterval!
    
    init(delegate: StopWatchDelgate, period: TimeInterval) {
        self.delegate = delegate
        self.period = period
    }
    
    func start() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: period, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        let timeIntervalObj = TimeIntervalObject(timeInterval: currentTime) - TimeIntervalObject(timeInterval: startTime)
        
        delegate?.doSomethingPeriodically(timeIntervalObject: timeIntervalObj)
    }

}

