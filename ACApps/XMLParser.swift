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
    
    var schoolSearch: Bool!
    var hospitalSearch: Bool!
    var schoolDataArray: [schoolData]!

    override init() {
        super.init()
        parserSetup()
    }
    func parserSetup() {
        parser.delegate = self
    }
    
    struct schoolData {
        var X_Coordinate, Y_Coordinate, schoolName, address, city, state, gradeLevel, organizationType: String?
        
        init(X_Coordinate: String) {
            self.X_Coordinate = X_Coordinate
        }
        init(Y_Coordinate: String) {
            self.Y_Coordinate = Y_Coordinate
        }
        init(schoolName: String) {
            self.schoolName = schoolName
        }
        init(address: String) {
            self.address = address
        }
        init(city: String) {
            self.city = city
        }
        init(state: String) {
            self.state = state
        }
        init(gradeLevel: String) {
            self.gradeLevel = gradeLevel
        }
        init(organizationType: String) {
            self.organizationType = organizationType
        }
        
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                  Parse School XML File
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
    class func schoolXMLParse() -> [schoolData] {
        
        let xmlParser = XMLParser()
        var schoolDataArray: [schoolData]!
        
        schoolDataArray = xmlParser.schoolDataArray
        
        //Parse XML
        let finishSchoolParse: Bool!
        typealias CompletionHandler = (success: Bool) -> Void
        func parse(completionHandler: CompletionHandler) {
            
            let schoolURL = "https://data.acgov.org/api/views/wswg-zukg/rows.xml?accessType=DOWNLOAD"
                
            xmlParser.parser = NSXMLParser(contentsOfURL: NSURL(string: schoolURL)!)!
            let success: Bool = xmlParser.parser.parse()
            if success {
                print("Parse success")
                completionHandler(success: finishSchoolParse)
                
            } else {
                print("Parse failure")
            }
        }

        return schoolDataArray
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                  Parse Hospital XML File
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
    class func hospitalXMLParse() -> [String] {
        let xmlParser = XMLParser()
        var hospitalDataArray: [String]!
        
        let finishHospitalParse: Bool!
        typealias CompletionHandler = (success: Bool) -> Void
        func parse(completionHandler: CompletionHandler) {
            
        }
        
        return hospitalDataArray
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        dispatch_sync(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { () -> Void in
            self.strXMLData = self.strXMLData + "\n" + string
            
            
            if (self.passName && self.schoolSearch == true) {
                
                if self.currentElement == "x" {
                    let X_Coordinate = schoolData(X_Coordinate: self.currentParsedElement + string)
                    self.schoolDataArray.append(X_Coordinate)
                    print(X_Coordinate)
                }
                
                if self.currentElement == "y" {
                    let Y_Coordiante = schoolData(Y_Coordinate: self.currentParsedElement + string)
                    self.schoolDataArray.append(Y_Coordiante)
                    print(Y_Coordiante)
                }
                
                if self.currentElement == "site" {
                    let schoolName = schoolData(schoolName: self.currentParsedElement + string)
                    self.schoolDataArray.append(schoolName)
                    print(schoolName)
                }
                
                if self.currentElement == "address" {
                    let schoolAddress = schoolData(address: self.currentParsedElement + string)
                    self.schoolDataArray.append(schoolAddress)
                    print(schoolAddress)
                }
                
                if self.currentElement == "city" {
                    let city = schoolData(city: self.currentParsedElement + string)
                    self.schoolDataArray.append(city)
                    print(city)
                }
                
                if self.currentElement == "state" {
                    let state = schoolData(state: self.currentParsedElement + string)
                    self.schoolDataArray.append(state)
                    print(state)
                }
                
                if self.currentElement == "type" {
                    let gradeLevel = schoolData(gradeLevel: self.currentParsedElement + string)
                    self.schoolDataArray.append(gradeLevel)
                    print(gradeLevel)

                }
                
                if self.currentElement == "org" {
                    let organizationType = schoolData(organizationType: self.currentParsedElement + string)
                    self.schoolDataArray.append(organizationType)
                    print(organizationType)
                }
            }
            
            /*
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
            */
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
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
            //            parser.finalize()
        }
    }
}


