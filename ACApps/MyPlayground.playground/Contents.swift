//: Playground - noun: a place where people can play

import UIKit
import Foundation

var lastApplicationUseDate: NSDate!
let lastTimeKey = "lastTime"

let terminateTime = NSDate()
let defaults = NSUserDefaults.standardUserDefaults()
defaults.setObject(terminateTime, forKey: lastTimeKey)



var dict = ["firstName" : "Brandon", "lastName" : "Phan", "Email" : "Brandon.phan.73@gmail.com"]

for (key,value) in dict {
    print(key)
    print(value)
    
}

extension Dictionary {
    func appendWithKey(destinationDictionary: [String : String], key: String, data: String) -> [String : String] {
        var destinationDictionary = destinationDictionary
        
        destinationDictionary.updateValue(data, forKey: key)
        
        return destinationDictionary
    }
}

dict.appendWithKey(dict, key: "birthday", data: "7/03/2")
print(dict.appendWithKey(dict, key: "birthday", data: "7/03/2"))

let array = ["Fruit: Orange","Fruit: Apple", "Fruit: Grape" ,"Animal: Elephant", "Animal: Lion", "Animal: Snow leopard"]

for i in array {
    if i.containsString("Fruit: ") {
        print(i, "Fruit")
    } else if i.containsString("Animal: ") {
        print(i, "Animal")
    }
}

let dictKey = "SC_long: "

let string = "123.231"

let cancatinatedString = dictKey + string

print(cancatinatedString)

var lat = "Hello"
lat.removeAtIndex(lat.startIndex.advancedBy(0))
lat.removeAtIndex(lat.startIndex.advancedBy(1))
lat.removeAtIndex(lat.startIndex.advancedBy(2))

print(lat)


