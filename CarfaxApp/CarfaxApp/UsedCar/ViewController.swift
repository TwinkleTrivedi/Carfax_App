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
        return listObj.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 330;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let  cell=carfaxTableview.dequeueReusableCell(withIdentifier: "carfaxTableViewCell") as! carfaxTableViewCell
     
        // Ensure we have valid data for this index
        guard indexPath.row < listObj.count,
              indexPath.row < vehicleObj.count,
              indexPath.row < dObj.count else {
            return cell
        }
        
        let vehicleimg="\(vehicleObj[indexPath.row].vehiclephoto)"
        
        // Only load image if URL is not empty
        if !vehicleimg.isEmpty, let urlimg = URL(string: vehicleimg) {
            DispatchQueue.global(qos: .background).async {
                if let data = try? Data(contentsOf: urlimg) {
                    DispatchQueue.main.async {
                        cell.VehiclePhoto.image = UIImage(data: data)
                    }
                }
            }
        } else {
            // Set placeholder or clear image if no URL
            cell.VehiclePhoto.image = nil
        }
        var trim = "\(listObj[indexPath.row].trim)"
        if trim == "Unspecified"
        {
            trim=""
        }
        cell.VehicleDetails1lbl.text="\(listObj[indexPath.row].year) \(listObj[indexPath.row].make) \(listObj[indexPath.row].model)  \(trim)"
        
        cell.VehicleDetails2lbl.text="$\(listObj[indexPath.row].price) | \(listObj[indexPath.row].mileage) Mi | \(dObj[indexPath.row].city),\(dObj[indexPath.row].state)"
        cell.callDealerBtn.setTitle("\(dObj[indexPath.row].dealerPhone)", for: .normal)
        
        cell.callDealerBtn.addTarget(self, action: #selector(callDealer(sender:)), for: .touchUpInside)
         cell.callDealerBtn.tag=indexPath.row
        
        return cell
        
    }
    
    @objc func callDealer(sender: UIButton)
    {
        // Ensure we have a valid index
        guard sender.tag < dObj.count else {
            return
        }
        
        let phoneNumber = dObj[sender.tag].dealerPhone
        let dealerName = sender.tag < listObj.count ? "\(listObj[sender.tag].year) \(listObj[sender.tag].make) \(listObj[sender.tag].model)" : "Dealer"
        
        // Show alert before calling
        let alert = UIAlertController(title: "Call Dealer", message: "Do you want to call \(phoneNumber) for \(dealerName)?", preferredStyle: .alert)
        
        // Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Call action
        alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { _ in
            // Format phone number (remove any non-digit characters except +)
            let cleanedPhone = phoneNumber.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
            
            if let url = URL(string: "tel://\(cleanedPhone)") {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: { success in
                            if !success {
                                print("Failed to open phone dialer")
                            }
                        })
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                } else {
                    // Show error if phone calls are not available (e.g., on simulator)
                    let errorAlert = UIAlertController(title: "Cannot Make Call", message: "Phone calls are not available on this device.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
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
                    print("carfax JSON received")
                    
                    if let data_obj = jsonData as? NSDictionary
                    {
                        if let listings = data_obj["listings"] as? NSArray
                        {
                            print("Found \(listings.count) listings")
                            for i in 0 ..< listings.count
                            {
                                if let listDic = listings[i] as? NSDictionary
                                {
                                    // Parse images
                                    if let image = listDic["images"] as? NSDictionary
                                    {
                                        self.main1!.vehicleObj.append(vehicleimageObj(image))
                                        // Try to print image URL for debugging
                                        if let largeArray = image["large"] as? NSArray,
                                           largeArray.count > 0,
                                           let firstImage = largeArray[0] as? String {
                                            print("image: \(firstImage)")
                                        } else if let fp = image["firstPhoto"] as? NSDictionary,
                                                  let medium = fp["medium"] as? String {
                                            print("image: \(medium)")
                                        }
                                    } else {
                                        // Add empty image object if no images found
                                        self.main1!.vehicleObj.append(vehicleimageObj(NSDictionary()))
                                    }
                                    
                                    // Parse vehicle data
                                    if let year = listDic["year"] as? NSInteger,
                                       let make = listDic["make"] as? String,
                                       let model = listDic["model"] as? String {
                                        print("year \(year) make: \(make) model \(model)")
                                        self.main1!.listObj.append(carfaxObj(listDic))
                                    }
                                    
                                    // Parse dealer data
                                    if let dealer = listDic["dealer"] as? NSDictionary
                                    {
                                        if let city = dealer["city"] as? String,
                                           let state = dealer["state"] as? String,
                                           let phone = dealer["phone"] as? String {
                                            print("location \(city) \(state) \(phone)")
                                            self.main1!.dObj.append(dealerObj(dealer))
                                        }
                                    } else {
                                        // Add empty dealer object if no dealer found
                                        self.main1!.dObj.append(dealerObj(NSDictionary()))
                                    }
                                }
                            }
                            
                            // Ensure all arrays have the same count
                            let maxCount = max(self.main1!.listObj.count, self.main1!.vehicleObj.count, self.main1!.dObj.count)
                            while self.main1!.vehicleObj.count < maxCount {
                                self.main1!.vehicleObj.append(vehicleimageObj(NSDictionary()))
                            }
                            while self.main1!.dObj.count < maxCount {
                                self.main1!.dObj.append(dealerObj(NSDictionary()))
                            }
                            
                            print("Parsed \(self.main1!.listObj.count) vehicles, \(self.main1!.vehicleObj.count) images, \(self.main1!.dObj.count) dealers")
                        }
                        
                        
                    }
                   DispatchQueue.main.async(execute: self.main1!.refresh)
                    
                    
                }
                catch
                {
                    print("Error parsing JSON: \(error)")
                    return
                }
                
            }
        }
        
        
        GetDisplay_Data("\(appDelegate.jsonurl)", RequestHandler(self), "")
    }


}

