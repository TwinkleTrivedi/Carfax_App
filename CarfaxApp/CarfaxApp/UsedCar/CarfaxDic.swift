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

struct vehicleimageObj {
    
    var vehiclephoto=""
    init(_ data:NSDictionary)
    {
        if let add = data["medium"] as? String
        {
            self.vehiclephoto = add
        }
    }
}
struct dealerObj {
    
    var city=""
    var state=""
    var dealerPhone=""
    init(_ data:NSDictionary)
    {
        if let add = data["city"] as? String
        {
            self.city = add
        }
        if let add = data["state"] as? String
        {
            self.state = add
        }
        if let add = data["phone"] as? String
        {
            self.dealerPhone = add
        }
    }
}

struct carfaxObj {
    

    var year=0
    var make=""
    var model=""
    var trim=""
    var price=0
    var mileage=0
    
    
    
    init(_ data:NSDictionary)
    {
    
        if let add = data["year"] as? NSInteger
        {
            self.year = add
        }
        if let add = data["make"] as? String
        {
            self.make = add
        }
        if let add = data["model"] as? String
        {
            self.model = add
        }
        if let add = data["trim"] as? String
        {
            self.trim = add
        }
        if let add = data["currentPrice"] as? NSInteger
        {
            self.price = add
        }
        if let add = data["mileage"] as? NSInteger
        {
            self.mileage = add
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
