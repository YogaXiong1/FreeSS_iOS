//
//  Util.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/3.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import Foundation

private let urlSting = "http://abc.ishadow.online/index_cn.html"

class NetworkUtil: NSObject {
    static let shared = NetworkUtil()
    fileprivate var data: Data = Data()
    var completionHandler: ((Data, Error?) -> Void)?
    
    final func start() {
        let url = URL(string: urlSting)
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request)
        task.resume()
    }
}

extension NetworkUtil: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        completionHandler?(self.data, error)
    }
}


extension String {
    
    func getLadderTagList() -> [String] {
        let expression = Regex.makeRegularExpression(pattern: RegularExpression.listTag.rawValue)
        let result = expression.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
    
        var stringArray = [String]()
        for item in result {
        let s = (self as NSString).substring(with: item.range)
            stringArray.append(s)
        }
        return stringArray
    }

    
    func getItem(type: RegularExpression) -> String {
        let expression = Regex.makeRegularExpression(pattern: type.rawValue)
        
        guard let result = expression.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count)) else {
            return ""
        }
        let s = (self as NSString).substring(with: result.range)
        return s
    }
}



class Creater {
    static let shared = Creater()
    
    final func makeLadder(completionHandler: @escaping ([Ladder], Error?) -> Void) {
        let n = NetworkUtil.shared
        n.start()
        n.completionHandler = { (data, e) in
            let s = String(data: data, encoding: String.Encoding.utf8)!
            let list = s.getLadderTagList()
            var ladders = [Ladder]()
            for i in list {
                let ipTag = i.getItem(type: RegularExpression.ipTag)
                let portTag = i.getItem(type: RegularExpression.portTag)
                let passwordTag = i.getItem(type: RegularExpression.passwordTag)
                let encryptTypeTag = i.getItem(type: RegularExpression.encryptTypeTag)
                
                let ip = ipTag.getItem(type: RegularExpression.ip)
                let port = portTag.getItem(type: RegularExpression.port)
                let password = passwordTag.getItem(type: RegularExpression.password)
                
                let encryptType = encryptTypeTag.substring(with: encryptTypeTag.index(encryptTypeTag.startIndex, offsetBy: 5)..<encryptTypeTag.index(encryptTypeTag.endIndex, offsetBy: -5))
                
                let ladder = Ladder(ip: ip, port: port, password: password, encryptType: encryptType)
                ladders.append(ladder)
                
                completionHandler(ladders, e)
            }
        }

    }
    
}


struct Regex {
    static func makeRegularExpression(pattern: String) -> NSRegularExpression {
        var expression: NSRegularExpression!
        do {
            expression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        } catch let e {
            print(e)
        }
        return expression
    }
}

enum RegularExpression: String {
    case listTag = "<div class=\"hover-bg\">(.*?)</div>"
    case ipTag = "IP地址:<span id=\"\\b(.*?)\">(.*?)</span>"
    case portTag = "<h4>端口：(\\d+?)</h4>"
    case passwordTag = "密码:<span id=\"\\b(.*?)\">(\\d+)</span>"
    case encryptTypeTag = "加密方式:(.*?)</h4>"
    
    case ip = "\\w+\\W\\w+\\W\\w+"
    case port = "\\d{2,9}"
    case password = "\\d+"
}



