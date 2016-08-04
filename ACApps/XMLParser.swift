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
    var hospitalDataArray = [String]()
    var H_Facillity, H_Alias, H_Address, H_City, H_State, H_Zip_Code, H_Status, H_Type, H_longitude, H_Latitude, H_county: String!
    
    //School data
    var schoolSearch = Bool()
    var schoolDataArray = [String]()
    var SC_X_Coordinate, SC_Y_Coordinate, SC_schoolName, SC_address, SC_city, SC_state, SC_gradeLevel, SC_organizationType: String!
    
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                  Parse School XML File
//--------------------------------------------------------------------------------------------------------------------------------------------------------------

    //Parse XML
    var finishXMLParse: Bool!
    typealias CompletionHandler = (success: Bool) -> Void
    func parse(completionHandler: CompletionHandler) {
        
        let schoolURL = "https://data.acgov.org/api/views/wswg-zukg/rows.xml?accessType=DOWNLOAD"
        let hospitalURL = "https://data.acgov.org/api/views/eje3-rj63/rows.xml?accessType=DOWNLOAD"
 
        /*
        let schoolDataFile = NSBundle.mainBundle().pathForResource("schoolXML", ofType: "xml")
        let hospitalDataFile = NSBundle.mainBundle().pathForResource("hospitalXML", ofType: "xml")
        
        let schoolDataURL = NSURL(fileURLWithPath: schoolDataFile!, isDirectory: true)
        let hospitalDataURL = NSURL(fileURLWithPath: hospitalDataFile!, isDirectory: true)
        */
        
        let XMLArray = [schoolURL, hospitalURL]
        
        for XML in XMLArray {
            
            if XML == schoolURL {
                schoolSearch = true
            } else if XML == hospitalURL {
                hospitalSearch = true
            }
            
            self.parser = NSXMLParser(contentsOfURL: NSURL(string: XML)!)!
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

    /*
 let schoolXMLPath = NSBundle.mainBundle().pathForResource("schoolXML", ofType: "xml")
 let hospitalXMLPath = NSBundle.mainBundle().pathForResource("hospitalXML", ofType: "xml")
 
 let schoolXML = NSData(contentsOfFile: schoolXMLPath!)
 let hospitalXML = NSData(contentsOfFile: hospitalXMLPath!)
 
 let URLArray = [schoolXML, hospitalXML]
 
 for XMLFile in URLArray {
 */
 
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
                    let dictKey = "SC_long: "
                    self.SC_X_Coordinate = self.currentParsedElement + string
                    self.schoolDataArray.append(dictKey + self.SC_X_Coordinate)
                }
                
                if self.currentElement == "y" {
                    let dictKey = "SC_lat: "
                    self.SC_Y_Coordinate = self.currentParsedElement + string
                    self.schoolDataArray.append(dictKey + self.SC_Y_Coordinate)
                }
                if self.currentElement == "site" {
                    let dictKey = "SC_site: "
                    self.SC_schoolName = self.currentParsedElement + string
                    self.schoolDataArray.append(dictKey + self.SC_schoolName)
                }
                
                if self.currentElement == "address" {
                    let dictKey = "SC_address: "
                    self.SC_address = self.currentParsedElement + string
                    self.schoolDataArray.append(dictKey + self.SC_address)
                }
                
                if self.currentElement == "city" {
                    let dictKey = "SC_city: "
                    self.SC_city = self.currentParsedElement + string
                    self.schoolDataArray.append(dictKey + self.SC_city)
                }
                
                if self.currentElement == "state" {
                    let dictKey = "SC_state: "
                    self.SC_state = self.currentParsedElement + string
                    self.schoolDataArray.append(dictKey + self.SC_state)
                }
                
                if self.currentElement == "type" {
                    let dictKey = "SC_type: "
                    self.SC_gradeLevel = self.currentParsedElement + string
                    self.schoolDataArray.append(dictKey + self.SC_gradeLevel)
                }
                
                if self.currentElement == "org" {
                    let dictKey = "SC_org: "
                    self.SC_organizationType = self.currentParsedElement + string
                    self.schoolDataArray.append(dictKey + self.SC_organizationType)
                }
                
                
            }
            
            if (self.passName && self.hospitalSearch == true) {
                
                if self.currentElement == "facility" {
                    let dictKey = "H_facility: "
                    self.H_Facillity = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_Facillity)
                }
                if self.currentElement == "alias" {
                    let dictKey = "H_alias: "
                    self.H_Alias = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_Alias)
                }
                if self.currentElement == "address_1" {
                    let dictKey = "H_address: "
                    self.H_Address = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_Address)
                }
                if self.currentElement == "city" {
                    let dictKey = "H_city: "
                    self.H_City = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_City)
                }
                if self.currentElement == "state" {
                    let dictKey = "H_state: "
                    self.H_State = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_State)
                }
                if self.currentElement == "zip_Code" {
                    let dictKey = "H_zip_Code: "
                    self.H_Zip_Code = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_Zip_Code)
                }
                if self.currentElement == "status" {
                    let dictKey = "H_status: "
                    self.H_Status = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_Status)
                }
                if self.currentElement == "type" {
                    let dictKey = "H_type: "
                    self.H_Type = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_Type)
                }
                if self.currentElement == "longitude" {
                    let dictKey = "H_long: "
                    self.H_longitude = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_longitude)
                }
                if self.currentElement == "latitude" {
                    let dictKey = "H_long: "
                    self.H_Latitude = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_Latitude)
                }
                if self.currentElement == "country" {
                    let dictKey = "H_country: "
                    self.H_county = self.currentParsedElement + string
                    self.hospitalDataArray.append(dictKey + self.H_county)
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


