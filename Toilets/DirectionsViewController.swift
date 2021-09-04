//
//  DirectionsViewController.swift
//  Toilets
//
//  Created by Muhammad Mehdi Raza on 31/5/20.
//  Copyright © 2020 Muhammad Mehdi Raza. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DirectionsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    //to contain longs and lats of toilet from previous screen
    var long = ""
    var lat = ""
    var name = ""
    var address = ""
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //getting users permission for location
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.delegate = self
    }
    
    //when user's location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    //when button get directions is pressed
    @IBAction func getDirectionsTapped(_ sender: Any) {
        
        let longs = Double(self.long)!
        let lats = Double(self.lat)!
        
        let toiletLocation = CLLocationCoordinate2D(latitude: lats, longitude: longs)
        
        route(destinationCord: toiletLocation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = toiletLocation
        annotation.title = name
        annotation.subtitle = address
        map.addAnnotation(annotation)
    }
    
    //calculating a route from user's location to the toilet's location
    func route (destinationCord: CLLocationCoordinate2D){
        
        let sourceCoordinate = (locationManager.location?.coordinate)!
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate{(response, error) in
            guard let response = response else {
                if let error = error{
                    print ("Something went wrong: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        return render
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
