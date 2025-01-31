//
//  UserDefaults.swift
//  scoutwatch
//
//  Created by Dirk Hermanns on 27.12.15.
//  Copyright © 2015 private. All rights reserved.
//

import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

// Repository to store BgData using the NSUserDefaults
class NightscoutDataRepository {
    
    static let singleton = NightscoutDataRepository()
    
    struct Constants {
        static let currentBgData = "currentBgData"
        static let todaysBgData = "todaysBgData"
        static let yesterdaysBgData = "yesterdaysBgData"
        static let yesterdaysDayOfTheYear = "yesterdaysDayOfTheYear"
        static let cannulaChangeTime = "cannulaChangeTime"
        static let sensorChangeTime = "sensorChangeTime"
        static let batteryChangeTime = "batteryChangeTime"
        static let deviceStatus = "deviceStatus"
        static let temporaryTarget = "temporaryTarget"
    }
    
    var isEmpty: Bool {
        return loadYesterdaysBgData().isEmpty && loadTodaysBgData().isEmpty
    }
    
    func clearAll() {
         let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID)
        defaults?.removeObject(forKey: Constants.currentBgData)
        defaults?.removeObject(forKey: Constants.todaysBgData)
        defaults?.removeObject(forKey: Constants.yesterdaysBgData)
        defaults?.removeObject(forKey: Constants.yesterdaysDayOfTheYear)
        // this shouldn't be necessary anymore - remove it later
        defaults?.synchronize()
    }
    
    func storeCurrentNightscoutData(_ bgData : NightscoutData) {
        
        let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID)
        NSKeyedArchiver.setClassName("NightscoutData", for: NightscoutData.self)
        try?
            defaults?.set(
                NSKeyedArchiver.archivedData(withRootObject: bgData, requiringSecureCoding: true),
                forKey: Constants.currentBgData)
        
        if #available(iOS 14.0, *), #available(watchOS 9.0, *){
            // New BG values are there. Force updates of all Widget Timelines:
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func loadCurrentNightscoutData() -> NightscoutData {
        
        guard let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID) else {
            // Nothing has been stored before => return dummy-Data
            return NightscoutData()
        }
        
        guard let data = defaults.object(forKey: Constants.currentBgData) as? Data else {
            return NightscoutData()
        }
        
        NSKeyedUnarchiver.setClass(NightscoutData.self, forClassName: "NightscoutData")
        //guard let nightscoutData = (try? NSKeyedUnarchiver.unarchivedObject(ofClass: NightscoutData.self, from: data)) else {
        guard let nightscoutData = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)) as? NightscoutData else {
            return NightscoutData()
        }
        return nightscoutData
    }
    
    func storeTodaysBgData(_ todaysBgData : [BloodSugar]) {
        
        storeBgData(keyName: Constants.todaysBgData, todaysBgData)
    }
    
    func loadTodaysBgData() -> [BloodSugar] {
        
        return loadBgData(keyName: Constants.todaysBgData)
    }
    
    func storeYesterdaysBgData(_ yesterdaysBgData : [BloodSugar]) {
        
        storeBgData(keyName: Constants.yesterdaysBgData, yesterdaysBgData)
    }
    
    func loadYesterdaysBgData() -> [BloodSugar] {
        
        return loadBgData(keyName: Constants.yesterdaysBgData)
    }
    
    func loadYesterdaysDayOfTheYear() -> Int {
        guard let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID) else {
            // Nothing has been stored before => return dummy-Data
            return -1
        }
        
        return defaults.integer(forKey: Constants.yesterdaysDayOfTheYear)
    }
    
    func storeYesterdaysDayOfTheYear(yesterdaysDayOfTheYear : Int) {
        let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID)
        defaults?.set(yesterdaysDayOfTheYear, forKey: Constants.yesterdaysDayOfTheYear)
    }
    
    func loadCannulaChangeTime() -> Date {
        guard let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID) else {
            // Nothing has been stored before => return dummy-Data
            return Date()
        }
        
        guard let cannulaChangeTime = defaults.object(forKey: Constants.cannulaChangeTime) as? Date else {
            return Date();
        }
        return cannulaChangeTime
    }
    
    func storeCannulaChangeTime(cannulaChangeTime : Date) {
        let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID)
        defaults?.set(cannulaChangeTime, forKey: Constants.cannulaChangeTime)
    }
    
    func loadSensorChangeTime() -> Date {
        guard let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID) else {
            // Nothing has been stored before => return dummy-Data
            return Date()
        }
        
        guard let sensorChangeTime = defaults.object(forKey: Constants.sensorChangeTime) as? Date else {
            return Date();
        }
        return sensorChangeTime
    }
    
    func storeSensorChangeTime(sensorChangeTime : Date) {
        let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID)
        defaults?.set(sensorChangeTime, forKey: Constants.sensorChangeTime)
    }
    
    func loadBatteryChangeTime() -> Date {
        guard let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID) else {
            // Nothing has been stored before => return dummy-Data
            return Date()
        }
        
        guard let batteryChangeTime = defaults.object(forKey: Constants.batteryChangeTime) as? Date else {
            return Date();
        }
        return batteryChangeTime
    }
    
    func storeBatteryChangeTime(batteryChangeTime : Date) {
        let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID)
        defaults?.set(batteryChangeTime, forKey: Constants.batteryChangeTime)
    }
    
    func storeDeviceStatusData(deviceStatusData : DeviceStatusData) {
        
        let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID)
        NSKeyedArchiver.setClassName("DeviceStatusData", for: DeviceStatusData.self)
        defaults?.set(try? NSKeyedArchiver.archivedData(withRootObject: deviceStatusData, requiringSecureCoding: true), forKey: Constants.deviceStatus)
    }
    
    func loadDeviceStatusData() -> DeviceStatusData {
        
        guard let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID) else {
            // Nothing has been stored before => return dummy-Data
            return DeviceStatusData()
        }
        
        guard let data = defaults.object(forKey: Constants.deviceStatus) as? Data else {
            return DeviceStatusData()
        }
        
        NSKeyedUnarchiver.setClass(DeviceStatusData.self, forClassName: "DeviceStatusData")
        //guard let deviceStatusData = (try? NSKeyedUnarchiver.unarchivedObject(ofClass: DeviceStatusData.self, from: data)) else {
        guard let deviceStatusData = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)) as? DeviceStatusData else {
            return DeviceStatusData()
        }
        return deviceStatusData
    }
    
    func storeTemporaryTargetData(temporaryTargetData : TemporaryTargetData) {
        
        let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID)
        NSKeyedArchiver.setClassName("TemporaryTargetData", for: TemporaryTargetData.self)
        defaults?.set(try? NSKeyedArchiver.archivedData(withRootObject: temporaryTargetData, requiringSecureCoding: true), forKey: Constants.temporaryTarget)
    }
    
    func loadTemporaryTargetData() -> TemporaryTargetData {
        
        guard let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID) else {
            // Nothing has been stored before => return dummy-Data
            return TemporaryTargetData()
        }
        
        guard let data = defaults.object(forKey: Constants.temporaryTarget) as? Data else {
            return TemporaryTargetData()
        }
        
        NSKeyedUnarchiver.setClass(TemporaryTargetData.self, forClassName: "TemporaryTargetData")
//        guard let temporaryTargetData = (try? NSKeyedUnarchiver.unarchivedObject(ofClass: TemporaryTargetData.self, from: data)) else {
        guard let temporaryTargetData = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)) as? TemporaryTargetData else {
            return TemporaryTargetData()
        }
        return temporaryTargetData
    }
    
    fileprivate func storeBgData(keyName : String, _ bgData : [BloodSugar]) {
        
        print("Storing \(bgData.count) using key \(keyName)")
        
        let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID)
        defaults?.set(
            try? NSKeyedArchiver.archivedData(withRootObject: bgData, requiringSecureCoding: true),
            forKey: keyName)
    }
    
    fileprivate func loadBgData(keyName : String) -> [BloodSugar] {
        
        guard let defaults = UserDefaults(suiteName: AppConstants.APP_GROUP_ID) else {
            // Nothing has been stored before => return dummy-Data
            return []
        }
        
        guard let data = defaults.object(forKey: keyName) as? Data else {
            return []
        }
        
        guard let bgData = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: BloodSugar.self, from: data) else {
            return []
        }
        return bgData
    }
}
