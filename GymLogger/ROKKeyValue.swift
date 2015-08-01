//
//  ROKKeyValue.swift
//  GymLogger
//
//  Created by Roman Klauke on 01.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import RealmSwift

class ROKKeyValue: Object {
    dynamic var key = ""
    dynamic var bool = false
    dynamic var int = 0
    dynamic var double = Double()
    dynamic var float = Float()
    dynamic var date = NSDate()
    dynamic var string = ""

    override class func primaryKey() -> String? {
        return "key"
    }

    private class func keyExists(key: String) -> ROKKeyValue? {
        let realm = Realm()
        let result = realm.objects(ROKKeyValue).filter("key == %@", key)
        return result.first
    }

    class func put(key: String, string: String) -> Void {
        let realm = Realm()
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.string = string
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.string = string
        }
        realm.commitWrite()
    }

    class func put(key: String, int: Int) -> Void {
        let realm = Realm()
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.int = int
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.int = int
        }
        realm.commitWrite()
    }

    class func put(key: String, float: Float) -> Void {
        let realm = Realm()
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.float = float
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.float = float
        }
        realm.commitWrite()
    }

    class func put(key: String, double: Double) -> Void {
        let realm = Realm()
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.double = double
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.double = double
        }
        realm.commitWrite()
    }

    class func put(key: String, bool: Bool) -> Void {
        let realm = Realm()
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.bool = bool
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.bool = bool
        }
        realm.commitWrite()
    }

    class func put(key: String, date: NSDate) -> Void {
        let realm = Realm()
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.date = date
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.date = date
        }
        realm.commitWrite()
    }

    class func getRaw(key: String) -> ROKKeyValue? {
        if key.isEmpty {
            return nil
        }

        let realm = Realm()
        return realm.objects(ROKKeyValue).filter("key == @%", key).first
    }

    class func getString(key: String) -> String {
        if let obj = getRaw(key) {
            return obj.string
        } else {
            return ""
        }
    }

    class func getString(key: String, defaultValue: String) -> String {
        if let obj = getRaw(key) {
            return obj.string
        } else {
            return defaultValue
        }
    }

    class func getInt(key: String) -> Int {
        if let obj = getRaw(key) {
            return obj.int
        } else {
            return 0
        }
    }

    class func getInt(key: String, defaultValue: Int) -> Int {
        if let obj = getRaw(key) {
            return obj.int
        } else {
            return defaultValue
        }
    }

    class func getFloat(key: String) -> Float {
        if let obj = getRaw(key) {
            return obj.float
        } else {
            return 0.0
        }
    }

    class func getFloat(key: String, defaultValue: Float) -> Float {
        if let obj = getRaw(key) {
            return obj.float
        } else {
            return defaultValue
        }
    }

    class func getDouble(key: String) -> Double {
        if let obj = getRaw(key) {
            return obj.double
        } else {
            return 0.0
        }
    }

    class func getDouble(key: String, defaultValue: Double) -> Double {
        if let obj = getRaw(key) {
            return obj.double
        } else {
            return defaultValue
        }
    }

    class func getBool(key: String) -> Bool {
        if let obj = getRaw(key) {
            return obj.bool
        } else {
            return false
        }
    }

    class func getBool(key: String, defaultValue: Bool) -> Bool {
        if let obj = getRaw(key) {
            return obj.bool
        } else {
            return defaultValue
        }
    }

    class func getDate(key: String) -> NSDate {
        if let obj = getRaw(key) {
            return obj.date
        } else {
            return NSDate()
        }
    }

    class func getDate(key: String, defaultValue: NSDate) -> NSDate {
        if let obj = getRaw(key) {
            return obj.date
        } else {
            return defaultValue
        }
    }

    class func remove(key: String) -> Void {
        if let obj = getRaw(key) {
            let realm = Realm()
            realm.beginWrite()
            realm.delete(obj)
            realm.commitWrite()
        }
    }

    class func entryCount() -> Int {
        let realm = Realm()
        return realm.objects(ROKKeyValue).count
    }
}
