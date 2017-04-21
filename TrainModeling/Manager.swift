//
//  Manager.swift
//  TrainModeling
//
//  Created by Максим on 10.03.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import Foundation
import UIKit

class Manager {
    
    
    private var absoluteTime: Int = 0 //время в секундах с начала страта моделирования
    
    private var startTime: String = "10:00" //время начала моделирования
    
    private var stepTime: Int = 0 //абсолютный временной шаг в секундах
    
    
    
    private var railRoad: Railroad?
    
    private var happendEvents: [Event] = [] //массив возникших событий (поломки поездов)
    
    
    private var currentRouteNumber = 0 //эквивалентно train_id
    
    private var generalSchedule: [[[String]]] //список из M маршрутов (общее расписание)
    
    private var routesNumber: Int
    
    private var isPause: Bool = true
    
    private var trainSelected: Bool = false
    
    private var settings: Settings
    
    private static var roadLength: CGFloat = 6000
    
    
    init(settings: Settings) {
        self.settings = settings
        self.generalSchedule = settings.getRoutes()
        self.routesNumber = settings.getRoutesNumber()
        self.railRoad = Railroad(stations: makeRailwayStations(stations: settings.getStations()),
                                 trains: makeTrains(routes: settings.getRoutes()))
    }
    
    
    //MARK: - Public functions
    
    //получить текущее время в 24м формате
    public func getWorldTime() -> String {
        return Manager.sum24Time(time1: self.startTime,
                                 time2: Manager.convertTo24Time(time:self.absoluteTime))
    }
    
    //получить время в секундах от начала дня
    public func getTime() -> Int {
        return Manager.convertToSecTime(time: self.startTime) + self.absoluteTime
    }
    
    public func updateAbsoluteTimeOnStepTime(withFps fps: Int) {
        self.absoluteTime += self.stepTime / fps
    }
    
    public func sortTrainsByStartTime() {
        railRoad?.sortTrainsByStartTime()
    }
    
    public func insertActiveTrain(train: Train) {
        self.railRoad?.insertActiveTrain(train: train)
    }
    
    
    //MARK: - Getters
    
    //получить время в секундах от времени начала моделирования
    public func getAbsoluteTime() -> Int {
        return self.absoluteTime
    }
    
    public func getTrains() -> [Train] {
        return (railRoad?.getTrains())!
    }
    
    public func getActiveTrains() -> [Train] {
        return (railRoad?.getActiveTrains())!
    }
    
    public func getStations() -> [RailwayStation] {
        return (railRoad?.getStations())!
    }
    
    public func isOnPause() -> Bool {
        return self.isPause
    }
    
    public func isTrainSelected() -> Bool {
        return self.trainSelected
    }
    
    public func getStepTime() -> Int {
        return self.stepTime
    }

    public func getRoutes() -> [[[String]]] {
        return self.generalSchedule
    }
    
    public func getCurrentRoute() -> [[String]] {
        return self.generalSchedule[self.currentRouteNumber]
    }
    
    public func getRoutesNumber() -> Int {
        return self.routesNumber
    }
    
    public func getTrackView() -> UIView {
        return (self.railRoad?.getTrackView())!
    }
    
    public func getHappendEvents() -> [Event] {
        return self.happendEvents
    }
    
    
    //MARK: - Setters
    
    public func setCurrentRouteNumber(number: Int) {
        self.currentRouteNumber = number
    }
    
    public func setOnPause() {
        self.isPause = true
    }
    
    public func setOnPlay() {
        self.isPause = false
    }
    
    public func setOnTrainSelected() {
        self.trainSelected = true
    }
    
    public func setOffTrainSelected() {
        self.trainSelected = false
    }
    
    public func setStepTime(time: Int) {
        self.stepTime = time
    }
    
    public func setTrains(trains: [Train]) {
        self.railRoad?.setTrains(trains: trains)
    }
    
    public func setActiveTrains(activeTrains: [Train]) {
        self.railRoad?.setActiveTrains(activeTrains: activeTrains)
    }
    
    public func setTrackView(trackView: UIView) {
        self.railRoad?.setTrackView(trackView: trackView)
    }
    
    
    public func getStationId(stationName: String) -> Int {
        for (i, station) in settings.getStations().enumerated() {
            if station.0 == stationName {
                return i
            }
        }
        return 0
    }
    
    //MARK: - Private functions
    
    
    private func makeRailwayStations(stations: [(String, Float)]) -> [RailwayStation] {
        var railwayStations: [RailwayStation] = []
        var i = 0
        for s in stations {
            railwayStations.append(RailwayStation(id: i, location: s.1, name: s.0))
            i += 1
        }
        return railwayStations
    }

    private func makeTrains(routes: [[[String]]]) -> [Train] {
        var trains: [Train] = []
        for i in 0..<routes.count {
            
            var trainStations: [RailwayStation] = []
            for (j, line) in routes[i].enumerated() {
                //если не начальная и не конечная станция то добавляем значение длительности остановки на промежуточной станции
                var stationTime: Int = 0
                if j != 0 && j != routes[i].count - 1 {
                    stationTime =
                        Manager.convertToSecTime(time: line[2]) - Manager.convertToSecTime(time: line[1])
                }
                let stationName: String = line[0]
                trainStations.append(RailwayStation(id: getStationId(stationName: stationName),
                                                    location: settings.getStationsDict()[stationName]!,
                                                    name: stationName,
                                                    stationTime: stationTime))
                    
            }
            
            trains.append(Train(id: i,
                                location: settings.getStationsDict()[routes[i][0][0]]!,
                                route: routes[i],
                                startAbsoluteTime: Manager.convertToSecTime(time: routes[i][0][2]),
                                trainStations: trainStations))
        }
        return trains
    }
    
    //MARK: - Other
    
    public func updateGeneralShedule(with route: [[String]], trainId: Int) {
        self.generalSchedule[trainId] = route
    }
    
    public func addHappendEvent(newEvent: Event) {
        self.happendEvents.append(newEvent)
    }
    
    
    //MARK: - Static functions
    
    public static func sum24Time(time1: String, time2: String) -> String {
        let absTime1: Int = convertToSecTime(time: time1)
        let absTime2: Int = convertToSecTime(time: time2)
        
        let absNewTime: Int = absTime1 + absTime2
        return convertTo24Time(time: absNewTime)
    }
    
    public static func sub24Time(time1: String, time2: String) -> String {
        let absTime1: Int = convertToSecTime(time: time1)
        let absTime2: Int = convertToSecTime(time: time2)
        
        let absNewTime: Int = absTime1 - absTime2
        return convertTo24Time(time: absNewTime)
    }
    
    //функция перевода 24 формата (строка HH:MM) в абсолютное время (секунды)
    public static func convertToSecTime(time: String) -> Int {
        let hours: Int = Int(time.substring(to: time.index(time.startIndex, offsetBy: 2)))!
        let minutes: Int = Int(time.substring(from: time.index(time.startIndex, offsetBy: 3)))!
        
        return hours * 3600 + minutes * 60
    }
    
    //функция конвертирования из секунд в 24й формат
    public static func convertTo24Time(time: Int) -> String {
        let hours: Int = (time / 3600) % 24
        let minutes: Int = (time - (time / 3600) * 3600) / 60
        
        var hoursStr: String = String(hours)
        var minutesStr: String = String(minutes)
        
        if hours / 10 == 0 { //если 1 цифра то добавляем незначащий ноль
            hoursStr = "0" + hoursStr
        }
        if minutes / 10 == 0 { //если 1 цифра то добавляем незначащий ноль
            minutesStr = "0" + minutesStr
        }
        return hoursStr + ":" + minutesStr
    }
    
    public static func getRoadLength() -> CGFloat {
        return self.roadLength
    }
}

