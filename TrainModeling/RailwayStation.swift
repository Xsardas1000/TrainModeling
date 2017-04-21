//
//  Station.swift
//  TrainModeling
//
//  Created by Максим on 10.03.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import Foundation
import UIKit


class RailwayStation {
    
    private var id: Int //порядковый номер в массиве станций
    
    private var location: Float //расстояние от начала линии в км
    
    private var name: String //название станции
    
    private var stationView: UIView?
    
    
    private var stationTime: Int = 0 // время стоянки поезда на промежуточной станции
    
    private var visited: Bool = false // посещенная поездом промежуточная станция
    
    //var shedule: StationShedule?
    
    init(id: Int, location: Float, name: String) {
        self.id = id
        self.location = location
        self.name = name
    }
    
    init(id: Int, location: Float, name: String, stationTime: Int) {
        self.id = id
        self.location = location
        self.name = name
        self.stationTime = stationTime
    }

    
    public func printStation() {
        print("Station with id = \(self.id), name = \(self.name), location = \(self.location)")
    }
    
    //MARK: - Getters
    
    public func getId() -> Int {
        return self.id
    }
    
    public func getLocation() -> Float {
        return self.location
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getStationTime() -> Int {
        return self.stationTime
    }
    
    
    //MARK: - Setters
    
    public func setStationView(stationView: UIView) {
        self.stationView = stationView
    }
    
    
    //MARK: - Other
    
    public func isVisited() -> Bool {
        return self.visited
    }
    
    public func makeVisited() {
        self.visited = true
    }
    
    public func removeStationView() {
        let view = self.stationView
        view?.removeFromSuperview()
    }
}
