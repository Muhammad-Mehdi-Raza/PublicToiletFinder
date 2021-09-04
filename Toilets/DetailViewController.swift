//
//  DetailViewController.swift
//  Toilets
//
//  Created by Muhammad Mehdi Raza on 6/5/20.
//  Copyright © 2020 Muhammad Mehdi Raza. All rights reserved.
//

import UIKit
import MapKit
import SystemConfiguration


class DetailViewController: UIViewController, MKMapViewDelegate {

    //outlet variables
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var female: UILabel!
    @IBOutlet weak var wheelchair: UILabel!
    @IBOutlet weak var baby: UILabel!
    @IBOutlet weak var male: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    //instance variables for filters, address and name of toilet
    var namelbl = ""
    var addresslbl = ""
    var malelbl = ""
    var femalelbl = ""
    var wheelchairlbl = ""
    var babylbl = ""
    var long = ""
    var lat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlert()
        
        //showing data coming from previous screen in labels
        name.text = namelbl
        male.text = malelbl.uppercased()
        female.text = femalelbl.uppercased()
        wheelchair.text = wheelchairlbl.uppercased()
        baby.text = babylbl.uppercased()
        
        let lon = Double(long)
        let lati = Double(lat)
                
        //putting an annotation on the toilet location
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lati!, longitude: lon!)
        annotation.title = namelbl
        annotation.subtitle = addresslbl
        map.addAnnotation(annotation)
        
        //setting zoom region of map
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        map.setRegion(region, animated: true)
        
    }
    
    //checking if user selected map or satellite view and chaning map view accordingly
    @IBAction func mapType(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            map.mapType = .standard
        }
        else{
            map.mapType = .satellite
        }
    }
    
    
    //checking if internet is available or not
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

    //showing alert if internet is not available
    func showAlert() {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Exit", style: .default, handler: { action in self.noInternet()})
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //exit application in case of no internet
    func noInternet(){
        exit(-1)
    }
    
    //sending longitude and latitude of toilet to next screen for calculating directios
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let directionsViewController = segue.destination as? DirectionsViewController {
            
            directionsViewController.long = self.long
            directionsViewController.lat = self.lat
            directionsViewController.name = self.namelbl
            directionsViewController.address = self.addresslbl
        }
    }
}
