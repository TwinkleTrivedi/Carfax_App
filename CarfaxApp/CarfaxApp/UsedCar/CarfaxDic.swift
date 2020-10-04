//
//  CarfaxDic.swift
//  CarfaxApp
//
//  Created by Twinkle Trivedi on 2020-10-04.
//  Copyright © 2020 Twinkle Trivedi. All rights reserved.
//

import UIKit
protocol Carfax {
    func process_request(_ data:Data)
}

struct carfaxObj {
    var id=""
    var image=""
  
    
    
    init(_ data:NSDictionary)
    {
        
        if let add = data["id"] as? String
        {
            self.id = add
        }
       
        if let add = data["img"] as? String
        {
            self.image = add
        }
       
       
        
    }
}
func GetDisplay_Data( _ url:String, _ handler:Carfax, _ ps:String)
{
    
    let url:URL = URL(string: url)!
    let session = URLSession.shared
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let postString = ps
    
    request.httpBody = postString.data(using: .utf8)
    
    let task = session.dataTask(with: request, completionHandler: {
        (
        _data, response, error) in
        
        if let data = _data
        {
            handler.process_request(data)
        }
        
    })
    
    task.resume()
    
}
