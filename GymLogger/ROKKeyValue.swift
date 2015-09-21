//
//  ROKKeyValue.swift
//  GymLogger
//
//  Created by Roman Klauke on 01.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import RealmSwift

public class ROKKeyValue: Object {
    dynamic var key = ""
    dynamic var bool = false
    dynamic var int = 0
    dynamic var double = Double()
    dynamic var float = Float()
    dynamic var date = NSDate()
    dynamic var string = ""

    override public class func primaryKey() -> String? {
        return "key"
    }

    private class func keyExists(key: String, realm: Realm = try! Realm()) -> ROKKeyValue? {
        let result = realm.objects(ROKKeyValue).filter("key == %@", key)
        return result.first
    }

    public class func put(key: String, string: String, realm: Realm = try! Realm()) -> Void {
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.string = string
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.string = string
            realm.add(newRecord)
        }
        try! realm.commitWrite()
    }

    public class func put(key: String, int: Int, realm: Realm = try! Realm()) -> Void {
        try! realm.write {
            if let obj = self.keyExists(key) {
                obj.int = int
            } else {
                let newRecord = ROKKeyValue()
                newRecord.key = key
                newRecord.int = int
                realm.add(newRecord)
            }
        }
    }

    public class func put(key: String, float: Float, realm: Realm = try! Realm()) -> Void {
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.float = float
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.float = float
            realm.add(newRecord)
        }
        try! realm.commitWrite()
    }

    public class func put(key: String, double: Double, realm: Realm = try! Realm()) -> Void {
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.double = double
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.double = double
        }
        try! realm.commitWrite()
    }

    public class func put(key: String, bool: Bool, realm: Realm = try! Realm()) -> Void {
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.bool = bool
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.bool = bool
            realm.add(newRecord)
        }
        try! realm.commitWrite()
    }

    public class func put(key: String, date: NSDate, realm: Realm = try! Realm()) -> Void {
        realm.beginWrite()
        if let obj = keyExists(key) {
            obj.date = date
        } else {
            let newRecord = ROKKeyValue()
            newRecord.key = key
            newRecord.date = date
            realm.add(newRecord)
        }
        try! realm.commitWrite()
    }

    public class func getRaw(key: String, realm: Realm = try! Realm()) -> ROKKeyValue? {
        if key.isEmpty {
            return nil
        }
        return realm.objects(ROKKeyValue).filter("key == %@", key).first
    }

    public class func getString(key: String, realm: Realm = try! Realm()) -> String {
        if let obj = getRaw(key, realm: realm) {
            return obj.string
        } else {
            return ""
        }
    }

    public class func getString(key: String, defaultValue: String, realm: Realm = try! Realm()) -> String {
        if let obj = getRaw(key, realm: realm) {
            return obj.string
        } else {
            return defaultValue
        }
    }

    public class func getInt(key: String, realm: Realm = try! Realm()) -> Int {
        if let obj = getRaw(key, realm: realm) {
            return obj.int
        } else {
            return 0
        }
    }

    public class func getInt(key: String, defaultValue: Int, realm: Realm = try! Realm()) -> Int {
        if let obj = getRaw(key, realm: realm) {
            return obj.int
        } else {
            return defaultValue
        }
    }

    public class func getFloat(key: String, realm: Realm = try! Realm()) -> Float {
        if let obj = getRaw(key, realm: realm) {
            return obj.float
        } else {
            return 0.0
        }
    }

    public class func getFloat(key: String, defaultValue: Float, realm: Realm = try! Realm()) -> Float {
        if let obj = getRaw(key, realm: realm) {
            return obj.float
        } else {
            return defaultValue
        }
    }

    public class func getDouble(key: String, realm: Realm = try! Realm()) -> Double {
        if let obj = getRaw(key, realm: realm) {
            return obj.double
        } else {
            return 0.0
        }
    }

    public class func getDouble(key: String, defaultValue: Double, realm: Realm = try! Realm()) -> Double {
        if let obj = getRaw(key, realm: realm) {
            return obj.double
        } else {
            return defaultValue
        }
    }

    public class func getBool(key: String, realm: Realm = try! Realm()) -> Bool {
        if let obj = getRaw(key, realm: realm) {
            return obj.bool
        } else {
            return false
        }
    }

    public class func getBool(key: String, defaultValue: Bool, realm: Realm = try! Realm()) -> Bool {
        if let obj = getRaw(key, realm: realm) {
            return obj.bool
        } else {
            return defaultValue
        }
    }

    public class func getDate(key: String, realm: Realm = try! Realm()) -> NSDate {
        if let obj = getRaw(key, realm: realm) {
            return obj.date
        } else {
            return NSDate()
        }
    }

    public class func getDate(key: String, defaultValue: NSDate, realm: Realm = try! Realm()) -> NSDate {
        if let obj = getRaw(key, realm: realm) {
            return obj.date
        } else {
            return defaultValue
        }
    }

    public class func remove(key: String, realm: Realm = try! Realm()) -> Void {
        if let obj = getRaw(key, realm: realm) {
            realm.beginWrite()
            realm.delete(obj)
            try! realm.commitWrite()
        }
    }

    public class func entryCount(inRealm realm: Realm) -> Int {
        return realm.objects(ROKKeyValue).count
    }
}
