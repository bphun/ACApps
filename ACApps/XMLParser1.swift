//
//  XMLParser.swift
//  ACApps
//
//  Created by Brandon Phan on 2/28/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import MapKit

class XMLParser: NSObject, NSXMLParserDelegate, CLLocationManagerDelegate {
    
    var parser = NSXMLParser()
    var strXMLData = String()
        
    private var passName = false
    private var passData = false
    private var currentElement: String = ""
    private var currentParsedElement = String()
    
    private var schoolSearch: Bool! = false
    private var hospitalSearch: Bool! = false
    private var finishParse = true
    
    //School Info
    internal var SC_X_Coordinate = String()
    internal var SC_Y_Coordinate = String()
    internal var SC_schoolName = String()
    internal var SC_address = String()
    internal var SC_city = String()
    internal var SC_state = String()
    internal var SC_gradeLevel = String()
    internal var SC_organization = String()
    
    internal var SC_X_CoordinateArray: [String] = []
    internal var SC_Y_CoordinateArray: [String] = []
    internal var SC_schoolNameArray: [String] = []
    internal var SC_addressArray: [String] = []
    internal var SC_cityArray: [String] = []
    internal var SC_stateArray: [String] = []
    internal var SC_gradeLevelArray: [String] = []
    internal var SC_organizationArray: [String] = []
    
    //Hospital info
    internal var H_Facillity = String()
    internal var H_Alias = String()
    internal var H_Address = String()
    internal var H_City = String()
    internal var H_State = String()
    internal var H_Zip_Code = String()
    internal var H_Status = String()
    internal var H_Type = String()
    internal var H_longitude = String()
    internal var H_Latitude = String()
    internal var H_country = String()
    
    internal var H_FacillityArray: [String] = []
    internal var H_AliasArray: [String] = []
    internal var H_AddressArray: [String] = []
    internal var H_CityArray: [String] = []
    internal var H_StateArray: [String] = []
    internal var H_ZipCodeArray: [String] = []
    internal var H_StatusArray: [String] = []
    internal var H_TypeArray: [String] = []
    internal var H_longitudeArray: [String] = []
    internal var H_LatitudeArray: [String] = []
    internal var H_CountryArray: [String] = []
    
    typealias CompletionHandler = (success: Bool) -> Void
    
    func parse(completionHandler: CompletionHandler) {
        //Parse xML
        
        let schoolURL = "https://data.acgov.org/api/views/wswg-zukg/rows.xml?accessType=DOWNLOAD"
        let hospitalURL = "https://data.acgov.org/api/views/eje3-rj63/rows.xml?accessType=DOWNLOAD"
        
        let URLArray = [schoolURL, hospitalURL]
        
        for URL in URLArray {
            
            if URL == schoolURL {
                schoolSearch = true
            } else if URL == hospitalURL {
                hospitalSearch = true
            }
            
            self.parser = NSXMLParser(contentsOfURL: NSURL(string: URL)!)!
            self.parser.delegate = self
            
            let success: Bool = self.parser.parse()
            if success {
                print("Parse success")
                completionHandler(success: finishParse)
            
            } else {
                print("Parse failure")
            }
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.currentElement = elementName
        
        if schoolSearch == true  {
            if (elementName == "x" || elementName == "y" || elementName == "site" || elementName == "address" || elementName == "city" || elementName == "state" || elementName == "type" || elementName == "org") {
                passName = true
                passData = false
                schoolSearch = true
                hospitalSearch = false
                
            }
        }
        
        if hospitalSearch == true {
            if (elementName == "facility" || elementName == "alias" || elementName == "address" || elementName == "city" || elementName == "state" || elementName == "zip_Code" || elementName == "status" || elementName == "type" || elementName == "longitude" || elementName == "latitude" || elementName == "country") {
                passName = true
                passData = false
                hospitalSearch = true
                schoolSearch = false
            }
        }

    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        dispatch_sync(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { () -> Void in
            self.strXMLData = self.strXMLData + "\n" + string
            
            if (self.passName && self.schoolSearch == true) {
                
                if self.currentElement == "x" {
                    self.SC_X_Coordinate = self.currentParsedElement + string
                    self.SC_X_Coordinate.removeAtIndex(self.SC_X_Coordinate.startIndex)
                    self.SC_X_CoordinateArray.append(self.SC_X_Coordinate)
                    print(self.SC_X_Coordinate)
                }
                
                if self.currentElement == "y" {
                    self.SC_Y_Coordinate = self.currentParsedElement + string
                    self.SC_Y_Coordinate.removeAtIndex(self.SC_Y_Coordinate.startIndex)
                    self.SC_Y_CoordinateArray.append(self.SC_Y_Coordinate)
                    print(self.SC_Y_Coordinate)
                }
                
                if self.currentElement == "site" {
                    self.SC_schoolName = self.currentParsedElement + string
                    self.SC_schoolNameArray.append(self.SC_schoolName)
                    print(self.SC_schoolName)
                }
                
                if self.currentElement == "address" {
                    self.SC_address = self.currentParsedElement + string
                    self.SC_addressArray.append(self.SC_address)
                    print(self.SC_address)
                }
                
                if self.currentElement == "city" {
                    self.SC_city = self.currentParsedElement + string
                    self.SC_cityArray.append(self.SC_city)
                    print(self.SC_city)
                }
                
                if self.currentElement == "state" {
                    self.SC_state = self.currentElement + string
                    self.SC_stateArray.append(self.SC_state)
                    print(self.SC_state)
                }
                
                if self.currentElement == "type" {
                    self.SC_gradeLevel = self.currentParsedElement + string
                    self.SC_gradeLevelArray.append(self.SC_gradeLevel)
                    print(self.SC_gradeLevel)
                }
                
                if self.currentElement == "org" {
                    self.SC_organization = self.currentParsedElement + string
                    self.SC_organizationArray.append(self.SC_organization)
                    print(self.SC_organization)
                }
            }
            
            if (self.passName && self.hospitalSearch == true) {
                
                if self.currentElement == "facility" {
                    self.H_Facillity = self.currentParsedElement + string
                    self.H_FacillityArray.append(self.H_Facillity)
                    print(self.H_Facillity)
                }
                
                if self.currentElement == "alias" {
                    self.H_Alias = self.currentParsedElement + string
                    self.H_AliasArray.append(self.H_Alias)
                    print(self.H_Alias)
                }
                
                if self.currentElement == "address" {
                    self.H_Address = self.currentParsedElement + string
                    self.H_AddressArray.append(self.H_Address)
                    print(self.H_Address)
                }
                
                if self.currentElement == "city" {
                    self.H_City = self.currentParsedElement + string
                    self.H_CityArray.append(self.H_City)
                    print(self.H_City)
                }
                
                if self.currentElement == "state" {
                    self.H_State = self.currentParsedElement + string
                    self.H_StateArray.append(self.H_State)
                    print(self.H_State)
                }
                
                if self.currentElement == "zip_Code" {
                    self.H_Zip_Code = self.currentParsedElement + string
                    self.H_ZipCodeArray.append(self.H_Zip_Code)
                    print(self.H_Zip_Code)
                }
                
                if self.currentElement == "status" {
                    self.H_Status = self.currentParsedElement + string
                    self.H_StatusArray.append(self.H_Status)
                    print(self.H_Status)
                }
                
                if self.currentElement == "type" {
                    self.H_Type = self.currentParsedElement + string
                    self.H_TypeArray.append(self.H_Type)
                }
                
                if self.currentElement == "longitude" {
                    self.H_longitude = self.currentParsedElement + string
                    self.H_longitudeArray.append(self.H_longitude)
                    print(self.H_longitude)
                }
                
                if self.currentElement == "latitude" {
                    self.H_Latitude = self.currentParsedElement + string
                    self.H_LatitudeArray.append(self.H_Latitude)
                    print(self.H_Latitude)
                }
                
                if self.currentElement == "country" {
                    self.H_country = self.currentParsedElement + string
                    self.H_CountryArray.append(self.H_country)
                    print(self.H_country)
                }
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName.isEmpty == false {
            if (elementName == "x" || elementName == "y" || elementName == "site" || elementName == "SC_address" || elementName == "SC_city" || elementName == "SC_state" || elementName == "type" || elementName == "org") {
            }
            
            if (elementName == "facility" || elementName == "alias" || elementName == "address" || elementName == "city" || elementName == "state" || elementName == "zip_Code" || elementName == "status" || elementName == "type" || elementName == "longitude" || elementName == "latitude" || elementName == "country") {
            }
            
        } else {
            NSLog("Could not find end of elemnt \"%@\"", elementName)
            parser.abortParsing()
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
            parser.finalize()
            parser.abortParsing()
            
            //Remove school arrays
            self.SC_X_CoordinateArray.removeAll()
            self.SC_Y_CoordinateArray.removeAll()
            self.SC_addressArray.removeAll()
            self.SC_cityArray.removeAll()
            self.SC_stateArray.removeAll()
            self.SC_gradeLevelArray.removeAll()
            self.SC_organizationArray.removeAll()
            
            //Remove hospital arrays
            self.H_FacillityArray.removeAll()
            self.H_AliasArray.removeAll()
            self.H_AddressArray.removeAll()
            self.H_CityArray.removeAll()
            self.H_StateArray.removeAll()
            self.H_ZipCodeArray.removeAll()
            self.H_StatusArray.removeAll()
            self.H_TypeArray.removeAll()
            self.H_longitudeArray.removeAll()
            self.H_LatitudeArray.removeAll()
            self.H_CountryArray.removeAll()
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
//            parser.finalize()
        }
    }
}
