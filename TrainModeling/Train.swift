//
//  Train.swift
//  TrainModeling
//
//  Created by Максим on 10.03.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import Foundation
import UIKit

class Train {
    
    private var id: Int //номер в исходном массиве поездов
    
    private var location: Float //положение на линии относительно начала линии (в км)
    
    private var route: [[String]] //маршрут, по которому едет поезд
    
    private var startAbsoluteTime: Int //время начала маршрута поезда
    
    private var speed: Float = 70 //в км/ч
    
    private var isBroken: Bool = false
        
    private var trainView: UIView?
    
    private var isMoving: Bool = false
    
    private var stayingInterval: Int = 0
    
    private var trainStations: [RailwayStation]
    
    init(id: Int, location: Float, route: [[String]], startAbsoluteTime: Int,
         trainStations: [RailwayStation]) {
        self.id = id
        self.location = location
        self.route = route
        self.startAbsoluteTime = startAbsoluteTime
        self.trainStations = trainStations
    }
    
    //MARK: - Getters
    
    public func getStationTime(stationId: Int) -> Int {
        for station in self.trainStations {
            if station.getId() == stationId {
                return station.getStationTime()
            }
        }
        return 0
    }
    
    public func getRoute() -> [[String]] {
        return self.route
    }
    
    public func getTrainView() -> UIView? {
        return self.trainView
    }
    
    public func getSpeed() -> Float {
        return self.speed
    }
    
    public func getId() -> Int {
        return self.id
    }
    
    public func isTrainMoving() -> Bool {
        return self.isMoving
    }
    
    public func getLocation() -> Float {
        return self.location
    }
    
    public func getEndLocation() -> Float {
        return self.trainStations[self.trainStations.count - 1].getLocation()
    }
    
    
    public func getStartAbsoluteTime() -> Int {
        return self.startAbsoluteTime
    }
    
    
    //MARK: - Setters
    
    public func setTrainView(trainView: UIView) {
        self.trainView = trainView
    }
    
    
    //MARK: - Other
    
    public func printTrain() {
        print("Train with id = \(self.id), location = \(self.location), startTime = \(self.startAbsoluteTime), endLocation = \(self.getEndLocation()), trainStations = \(self.trainStations)")
    }
    

    public func removeTrainView() {
        let view = self.trainView
        view?.removeFromSuperview()
    }

    
    //за секунду проезжаем минимум minStepTime(900 с) / 3600 * speed(70 км/ч) = 17.5 (км) = 52 пикселя
    public func move(stepTime: Int, fps: Int) {
        let delta: Float = Float(stepTime) / 3600 * self.speed * (1.0 / Float(fps))
        self.location += delta
    }
    
    public func startMoving() {
        self.isMoving = true
    }
    
    public func stopMoving(stayingInterval: Int) {
        self.isMoving = false
        self.stayingInterval = stayingInterval //устанавливаем то время которое должен простоять поезд
    }
    
    //стоит до тех пор пока не пройдет необходимый интервал stayingInterval
    public func staying(deltaTime: Int) {
        if self.stayingInterval - deltaTime <= 0 {
            self.stayingInterval = 0
            self.trainView?.backgroundColor = UIColor.green
            self.startMoving()
        } else {
            self.stayingInterval -= deltaTime //уменьшаем оставшееся время стоянки
        }
    }
    
    //если рядом с непосещеной станцией, то возвращаем её помечаем как посещенную, если нет то nil
    public func checkStation(stepTime: Int, fps: Int) -> RailwayStation? {
        let delta: Float = Float(stepTime) / 3600 * self.speed * (1.0 / Float(fps))
        for station in self.trainStations {
            if !station.isVisited() && self.location + delta > station.getLocation() {
                station.makeVisited()
                return station
            }
        }
        return nil
    }
    
    //изменить времена в маршруте на delta (сек)
    public func updateRoute(on delta: Int) {
        print(Manager.convertTo24Time(time: delta))
        for i in 0..<self.route.count {
            if self.route[i][1] != "--" {
                self.route[i][1] = Manager.sum24Time(time1: self.route[i][1],
                                                     time2: Manager.convertTo24Time(time: delta))
            }
            if self.route[i][2] != "--" {
                self.route[i][2] = Manager.sum24Time(time1: self.route[i][2],
                                                     time2: Manager.convertTo24Time(time: delta))
            }
            print(self.route[i])
        }
    }
    
}
