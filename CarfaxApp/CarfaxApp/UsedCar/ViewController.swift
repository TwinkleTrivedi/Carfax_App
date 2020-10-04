//
//  ViewController.swift
//  CarfaxApp
//
//  Created by Twinkle Trivedi on 2020-10-04.
//  Copyright © 2020 Twinkle Trivedi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CarfaxusedcarData()
       
    }
    func CarfaxusedcarData()
    {
        
        class RequestHandler : NSObject, Carfax {
            
            var main1:ViewController? = nil
            
            init(_ main1:ViewController)
            {
                self.main1 = main1
            }
            
            func process_request(_ data:Data)
            {
                
                do
                {
                  
                    
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                    print("carfax:\(jsonData)")
                    
                    if let data_obj = jsonData as? NSDictionary
                    {
//                        if let data = data_obj["data"] as? NSDictionary
//                        {
//
//                        }
                        
                        
                    }
                   // DispatchQueue.main.async(execute: self.main1!.refresh)
                    
                    
                }
                catch
                {
                    return
                }
                
            }
        }
        
        
        GetDisplay_Data("\(appDelegate.jsonurl)", RequestHandler(self), "")
    }


}

