//
//  ViewController.swift
//  CarfaxApp
//
//  Created by Twinkle Trivedi on 2020-10-04.
//  Copyright © 2020 Twinkle Trivedi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    

     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var carfaxTableview: UITableView!
    
    var listObj:[carfaxObj]=[carfaxObj]()
     var vehicleObj:[vehicleimageObj]=[vehicleimageObj]()
    var dObj:[dealerObj]=[dealerObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CarfaxusedcarData()
       
    }
    
    
   
    func refresh()
    {
        if(self.carfaxTableview != nil)
        {
            self.carfaxTableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleObj.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 330;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let  cell=carfaxTableview.dequeueReusableCell(withIdentifier: "carfaxTableViewCell") as! carfaxTableViewCell
     
        
        let vehicleimg="\(vehicleObj[indexPath.row].vehiclephoto)"
        
        print("listobj: \(listObj)")
        let urlimg = URL(string: vehicleimg)
        DispatchQueue.global(qos: .background).async {
            let data = try? Data(contentsOf: urlimg!)
            DispatchQueue.main.async {
                if let imageData = data {
                    
                    cell.VehiclePhoto.image=UIImage(data: imageData)
                }
            }
        }
        cell.VehicleDetails1lbl.text="\(listObj[indexPath.row].year) \(listObj[indexPath.row].make) \(listObj[indexPath.row].model)  \(listObj[indexPath.row].trim)"
        
        cell.VehicleDetails2lbl.text="$\(listObj[indexPath.row].price) | \(listObj[indexPath.row].mileage) Mi | \(dObj[indexPath.row].city),\(dObj[indexPath.row].state)"
        cell.callDealerBtn.setTitle("\(dObj[indexPath.row].dealerPhone)", for: .normal)
        
        cell.callDealerBtn.addTarget(self, action: #selector(callDealer(sender:)), for: .touchUpInside)
         cell.callDealerBtn.tag=indexPath.row
        
        return cell
        
    }
    
    @objc func callDealer(sender: UIButton)
    {
        
      
            
            if let url = URL(string: "tel://\(dObj[sender.tag].dealerPhone)"),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                // add error message here
            }
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
                     self.main1!.listObj.removeAll()
                    self.main1!.dObj.removeAll()
                    self.main1!.vehicleObj.removeAll()
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                    print("carfax:\(jsonData)")
                    
                    if let data_obj = jsonData as? NSDictionary
                    {
                        if let listings = data_obj["listings"] as? NSArray
                        {
                            for i in 0 ..< listings.count
                            {
                                if let listDic = listings[i] as? NSDictionary
                                {
                                    if let image = listDic["images"] as? NSDictionary
                                    {
                                        if let fp = image["firstPhoto"] as? NSDictionary
                                        {
                                            self.main1!.vehicleObj.append(vehicleimageObj(fp))
                                            print("image: \(fp["medium"]!)")
                                            
                                            
                                        }
                                        
                                    }
                                    print("year \(listDic["year"]!) make: \(listDic["make"]!) model \(listDic["model"]!) trim  \(listDic["trim"]!)  \(listDic["currentPrice"]!) \(listDic["mileage"]!)")
                                   self.main1!.listObj.append(carfaxObj(listDic))
                                    if let dealer = listDic["dealer"] as? NSDictionary
                                    {
                                        print("location \(dealer["city"]!)\(dealer["state"]!) \(dealer["phone"]!)")
                                        self.main1!.dObj.append(dealerObj(dealer))
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                        
                    }
                   DispatchQueue.main.async(execute: self.main1!.refresh)
                    
                    
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

