//
//  Decoder.swift
//  Gloss
//
// Copyright (c) 2015 Harlan Kellaway
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

/**
Set of functions used to decode JSON to objects
*/
public struct Decoder {
    
    // MARK: - Decoders
    
    /**
    Returns function to decode JSON to value type
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to an optional value type
    */
    public static func decode<T>(key: String) -> JSON -> T? {
        return {
            json in
            
            if let value = json[key] as? T {
                return value
            }
            
            return nil
        }
    }
    
    /**
    Returns function to decode JSON to value type
    for objects that conform to the Glossy protocol
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to an optional value type
    */
    public static func decode<T: Decodable>(key: String) -> JSON -> T? {
        return {
            json in
            
            if let subJSON = json[key] as? JSON {
                return T(json: subJSON)
            }
            
            return nil
            
        }
    }
    
    /**
    Returns function to decode JSON to array
    of enum values
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to an optional array
    */
    public static func decodeArray<T: RawRepresentable>(key: String) -> JSON -> [T]? {
        return {
            json in
            
            if let rawValues = json[key] as? [T.RawValue] {
                var enumValues: [T] = []
                
                for rawValue in rawValues {
                    if let enumValue = T(rawValue: rawValue) {
                        enumValues.append(enumValue)
                    }
                }
                
                return enumValues
            }
            
            return nil
        }
    }
    
    /**
    Returns function to decode JSON to array
    for objects that conform to the Glossy protocol
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to an optinal array
    */
    public static func decodeArray<T: Decodable>(key: String) -> JSON -> [T]? {
        return {
            json in
            
            if let jsonArray = json[key] as? [JSON] {
                var models: [T] = []
                
                for subJSON in jsonArray {
                    models.append(T(json: subJSON))
                }
                
                return models
            }
            
            return nil
        }
    }
    
    /**
    Returns function to decode JSON to date
    
    - parameter key:           JSON key used to set value
    - parameter dateFormatter: Formatter used to format date
    
    - returns: Function decoding JSON to an optional date
    */
    public static func decodeDate(key: String, dateFormatter: NSDateFormatter) -> JSON -> NSDate? {
        return {
            json in
            
            if let dateString = json[key] as? String {
                return dateFormatter.dateFromString(dateString)
            }
            
            return nil
        }
    }
    
    /**
    Returns function to decode JSON to ISO8601 date
    
    - parameter key:           JSON key used to set value
    - parameter dateFormatter: Formatter with ISO8601 format
    
    - returns: Function decoding JSON to an optional ISO8601 date
    */
    public static func decodeDateISO8601(key: String) -> JSON -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return Decoder.decodeDate(key, dateFormatter: dateFormatter)
    }
    
    /**
    Returns function to decode JSON to enum value
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to an optional enum value
    */
    public static func decodeEnum<T: RawRepresentable>(key: String) -> JSON -> T? {
        return {
            json in
            
            if let rawValue = json[key] as? T.RawValue {
                return T(rawValue: rawValue)
            }
            
            return nil
        }
    }
    
    /**
    Returns function to decode JSON to URL
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to an optional URL
    */
    public static func decodeURL(key: String) -> JSON -> NSURL? {
        return {
            json in
            
            if let urlString = json[key] as? String {
                return NSURL(string: urlString)
            }
            
            return nil
        }
    }
    
    // MARK: - Force Decoders
    
    /**
    Returns function to decode JSON to value type
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to a value type
    */
    public static func forceDecode<T>(key: String) -> JSON -> T {
        return { return decode(key)($0)! }
    }
    
    /**
    Returns function to decode JSON to value type
    for objects that conform to the Glossy protocol
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to a value type
    */
    public static func forceDecode<T: Decodable>(key: String) -> JSON -> T {
        return { return decode(key)($0)! }
    }
    
    /**
    Returns function to decode JSON to array
    of enum values
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to a array
    */
    public static func forceDecodeArray<T: RawRepresentable>(key: String) -> JSON -> [T] {
        return { return decodeArray(key)($0)! }
    }
    
    /**
    Returns function to decode JSON to array
    for objects that conform to the Glossy protocol
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to a array
    */
    public static func forceDecodeArray<T: Decodable>(key: String) -> JSON -> [T] {
        return { return decodeArray(key)($0)! }
    }
    
    /**
    Returns function to decode JSON to date
    
    - parameter key:           JSON key used to set value
    - parameter dateFormatter: Formatter used to format date
    
    - returns: Function decoding JSON to a date
    */
    public static func forceDecodeDate(key: String, dateFormatter: NSDateFormatter) -> JSON -> NSDate {
        return { return decodeDate(key, dateFormatter: dateFormatter)($0)! }
    }
    
    /**
    Returns function to decode JSON to ISO8601 date
    
    - parameter key:           JSON key used to set value
    - parameter dateFormatter: Formatter with ISO8601 format
    
    - returns: Function decoding JSON to a ISO8601 date
    */
    public static func forceDecodeDateISO8601(key: String) -> JSON -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return Decoder.forceDecodeDate(key, dateFormatter: dateFormatter)
    }
    
    /**
    Returns function to decode JSON to enum value
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to an enum value
    */
    public static func forceDecodeEnum<T: RawRepresentable>(key: String) -> JSON -> T {
        return { return decodeEnum(key)($0)! }
    }
    
    /**
    Returns function to decode JSON to URL
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to a URL
    */
    public static func forceDecodeURL(key: String) -> JSON -> NSURL {
        return { return decodeURL(key)($0)! }
    }
    
}
