//
//  Ladder.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/3.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import UIKit
//import NetworkExtension

struct Ladder: CustomStringConvertible {
    let ip: String
    let port: String
    let password: String
    let encryptType: String
//    let QRCodeURL: String
    
    init(ip: String, port: String, password: String, encryptType: String) {
        self.ip = ip
        self.port = port
        self.password = password
        self.encryptType = encryptType
    }
    
    var description: String {
        return "ip: \(ip)" + "\n" + "port: \(port)" + "\n" + "password: \(password)" + "\n" + "encryptType: \(encryptType)" + "\n"
    }
    
}

//class A {
//    let manager = NEVPNManager.shared()
//    func a() {
//        manager.loadFromPreferences { (e) in
//            if e != nil {
//                let p = NEVPNProtocolIPSec()
//                p.username = ""
//                p.passwordReference = ""
//                p.serverAddress = ""
//                p.authenticationMethod = ""
//                p.sharedSecretReference = ""
//                p.localIdentifier = ""
//                p.remoteIdentifier = ""
//                p.useExtendedAuthentication = false
//                p.disconnectOnSleep = false
//            }
//        }
//    }
//    
//}
