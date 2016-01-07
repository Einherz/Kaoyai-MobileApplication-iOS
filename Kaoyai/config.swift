//
//  config.swift
//  Khaoyai
//
//  Created by Amorn Apichattanakul on 12/9/15.
//  Copyright © 2015 Amorn Apichattanakul. All rights reserved.
//

import Foundation

struct config{
    //You can change this basedAPI to be your domain 
    //This is my domain for testing which you could get checkout the format of json based on this link
    //http://www.thethanisorn.com/khaoyai/api/tempnow.php
    
    static let basedAPI:String = "http://www.thethanisorn.com/khaoyai/api/"
    
    static let NEWSVER = "newsversion.php"
    static let HOWTOVER = "howtoversion.php"
    static let MAPVER = "mapversion.php"
    static let CONTACTVER = "contactsversion.php"

    static let TEMPERATURE = "tempnow.php"
    static let NEWS = "news.php"
    static let HOWTO = "howto.php"
    static let MAP = "map.php"
    static let CONTACT = "contacts.php"
}
