//
//  File.swift
//  ACApps
//
//  Created by Brandon Phan on 4/14/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation

class XMLParser: NSObject, NSXMLParserDelegate {
    
    var parser = NSXMLParser()
    var strXMLData = String()
    
    private var passName = false
    private var passData = false
    private var currentElement: String = ""
    private var currentParsedElement = String()
    
    //Hospital data
    var hospitalSearch = Bool()
    var hospitalDataArray = NSMutableArray()
    var H_Facillity, H_Alias, H_Address, H_City, H_State, H_Zip_Code, H_Status, H_Type, H_longitude, H_Latitude, H_county: String!
    
    //School data
    var schoolSearch = Bool()
    var schoolDataArray = NSMutableArray()
    var SC_X_Coordinate, SC_Y_Coordinate, SC_schoolName, SC_address, SC_city, SC_state, SC_gradeLevel, SC_organizationType: String!
    
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                  Parse School XML File
//--------------------------------------------------------------------------------------------------------------------------------------------------------------

    //Parse XML
    var finishXMLParse: Bool!
    typealias CompletionHandler = (success: Bool) -> Void
    func parse(completionHandler: CompletionHandler) {
        
        let schoolDataArray = self.schoolDataArray
        let hospitalDataArray = self.hospitalDataArray
        
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
            parser.delegate = self

            let success: Bool = self.parser.parse()
            if success {
                print("Parse success")
                finishXMLParse = true
                completionHandler(success: finishXMLParse)
            } else {
                print("Parse failure")
            }
        }
    }

    
    
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                  Parse Hospital XML File
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.currentElement = elementName
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
            if self.schoolSearch == true  {
                if (elementName == "x" || elementName == "y" || elementName == "site" || elementName == "SC_address" || elementName == "SC_city" || elementName == "state" || elementName == "type" || elementName == "org") {
                    self.passName = true
                    self.passData = false
                    self.schoolSearch = true
                    self.hospitalSearch = false
                    
                }
            }
            
            if self.hospitalSearch == true {
                if (elementName == "facility" || elementName == "alias" || elementName == "address_1" || elementName == "city" || elementName == "state" || elementName == "zip_code" || elementName == "fac_status" || elementName == "type" || elementName == "longitude" || elementName == "latitude" || elementName == "county") {
                    self.passName = true
                    self.passData = false
                    self.hospitalSearch = true
                    self.schoolSearch = false
                }
            }
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        dispatch_sync(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { () -> Void in
            self.strXMLData = self.strXMLData + "\n" + string
            
            if (self.passName && self.schoolSearch == true) {
                
                if self.currentElement == "x" {
                    self.SC_X_Coordinate = self.currentParsedElement + string
                    self.schoolDataArray.addObject("long: " + self.SC_X_Coordinate)
                }
                
                if self.currentElement == "y" {
                    self.SC_Y_Coordinate = self.currentParsedElement + string
                    self.schoolDataArray.addObject("lat" + self.SC_Y_Coordinate)
                }
                
                if self.currentElement == "site" {
                    self.SC_schoolName = self.currentParsedElement + string
                    self.schoolDataArray.addObject(self.SC_schoolName)
                }
                
                if self.currentElement == "SC_address" {
                    self.SC_address = self.currentParsedElement + string
                    self.schoolDataArray.addObject(self.SC_address)
                }
                
                if self.currentElement == "SC_city" {
                    self.SC_city = self.currentParsedElement + string
                    self.schoolDataArray.addObject(self.SC_city)
                }
                
                if self.currentElement == "state" {
                    self.SC_state = self.currentParsedElement + string
                    self.schoolDataArray.addObject(self.SC_state)
                }
                
                if self.currentElement == "type" {
                    self.SC_gradeLevel = self.currentParsedElement + string
                    self.schoolDataArray.addObject(self.SC_gradeLevel)
                }
                
                if self.currentElement == "org" {
                    self.SC_organizationType = self.currentParsedElement + string
                    self.schoolDataArray.addObject(self.SC_organizationType)
                }
            }
            
            if (self.passName && self.hospitalSearch == true) {
                
                if self.currentElement == "facility" {
                    self.H_Facillity = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_Facillity)
                    print(self.hospitalDataArray)
                }
                if self.currentElement == "alias" {
                    self.H_Alias = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_Alias)
                    print(self.hospitalDataArray)
                }
                if self.currentElement == "address_1" {
                    self.H_Address = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_Address)
                    print(self.hospitalDataArray)
                }
                if self.currentElement == "city" {
                    self.H_City = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_City)
                    print(self.hospitalDataArray)
                }
                if self.currentElement == "state" {
                    self.H_State = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_State)
                    print(self.hospitalDataArray)
                }
                if self.currentElement == "zip_Code" {
                    self.H_Zip_Code = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_Zip_Code)
                    print(self.hospitalDataArray)
                }
                if self.currentElement == "status" {
                    self.H_Status = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_Status)
                    print(self.hospitalDataArray)
                }
                if self.currentElement == "type" {
                    self.H_Type = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_Type)
                    print(self.hospitalDataArray)
                }
                if self.currentElement == "longitude" {
                    self.H_longitude = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_longitude)
                    print(self.hospitalDataArray)
                }
                if self.currentElement == "latitude" {
                    self.H_Latitude = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_Latitude)
                    print(self.hospitalDataArray)
                }
                if self.currentElement == "country" {
                    self.H_county = self.currentParsedElement + string
                    self.hospitalDataArray.addObject(self.H_county)
                    print(self.hospitalDataArray)
                }
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName.isEmpty == false {
            if (elementName == "x" || elementName == "y" || elementName == "site" || elementName == "address" || elementName == "city" || elementName == "state" || elementName == "type" || elementName == "org") {
            }
            
            if (elementName == "facility" || elementName == "alias" || elementName == "address_1" || elementName == "city" || elementName == "state" || elementName == "zip_Code" || elementName == "status" || elementName == "type" || elementName == "longitude" || elementName == "latitude" || elementName == "county") {
            }
            
        } else {
            NSLog("Could not find end of elemnt \"%@\"", elementName)
            parser.abortParsing()
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
            parser.abortParsing()
            parser.finalize()
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
            //parser.finalize()
        }
    }
}


