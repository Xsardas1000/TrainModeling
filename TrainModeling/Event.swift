//
//  Event.swift
//  TrainModeling
//
//  Created by Максим on 21.04.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import Foundation
import UIKit


class Event {
    private var trainId: Int
    private var occuranceTime: Int // время возникновения события в сек 
    private var interval: Int // длина события в сек
    
    init(trainId: Int, occuranceTime: Int, interval: Int) {
        self.trainId = trainId
        self.occuranceTime = occuranceTime
        self.interval = interval
    }
    
    //MARK: - Getters
    public func getTrainId() -> Int {
        return self.trainId
    }
    
    public func getOccuranceTime() -> Int {
        return self.occuranceTime
    }
    
    public func getInterval() -> Int {
        return self.interval
    }
}
