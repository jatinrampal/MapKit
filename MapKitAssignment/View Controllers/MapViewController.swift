//
//  MapViewController.swift
//  MapKitAssignment
//
//  Created by Jatin Rampal on 2018-10-06.
//  Copyright © 2018 Jatin Rampal. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {

    let locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: 43.655787, longitude: -79.739534)
    
    @IBOutlet var myMapView : MKMapView!
    @IBOutlet var tbLocEntered : UITextField!
    @IBOutlet var myTableView : UITableView!
    
    @IBOutlet var segmentedControl : UISegmentedControl!
    
    @IBOutlet var tbWayPoint1Entered : UITextField!
    @IBOutlet var tbWayPoint2Entered : UITextField!
    
    var routeSteps = ["Enter a destination to see the steps"]
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    let regionRadius : CLLocationDistance = 1000
    func centerMapOnLocation(location : CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        myMapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        centerMapOnLocation(location: initialLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = initialLocation.coordinate
        dropPin.title = "Starting at Sheridan College"
        self.myMapView.addAnnotation(dropPin)
        self.myMapView.selectAnnotation(dropPin, animated: true)
        
    }
    
    
   /* @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            NSLog("Popular selected")
        
        case 1:
            NSLog("History selected")
        
        case 2:
            NSLog("History selected")
        default:
            break;
        }
    } */
    
    
    @IBAction func findNewLocation(){
        let locEnteredText = tbLocEntered.text
        let wp1EnteredText = tbWayPoint1Entered.text
        let wp2EnteredText = tbWayPoint2Entered.text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locEnteredText!, completionHandler:
            {
                (placemarks, error) -> Void in
                if(error != nil){
                    print("Error: ", error)
                }
                
                if let placemark = placemarks?.first{
                    let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                    let newLocation = CLLocation(latitude : coordinates.latitude, longitude : coordinates.longitude)
                    self.centerMapOnLocation(location: newLocation)
                    
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinates
                    dropPin.title = placemark.name
                    self.myMapView.addAnnotation(dropPin)
                    self.myMapView.selectAnnotation(dropPin, animated: true)
                    
                    let request = MKDirections.Request()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.initialLocation.coordinate, addressDictionary: nil))
                    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                    
                    request.requestsAlternateRoutes = false
                    request.transportType = .automobile
                    
                    let directions = MKDirections(request: request)
                    directions.calculate(completionHandler:
                        {
                           [unowned self] response, error in
                            for route in (response?.routes)!
                            {
                                self.myMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                                self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                                self.routeSteps.removeAll()
                                for step in route.steps {
                                    self.routeSteps.append(step.instructions)
                                }
                                self.myTableView.reloadData()
                            }
                        }
                    
                    )
                }
            })
        
            geocoder.geocodeAddressString(wp1EnteredText!, completionHandler:
                {
                    (placemarks, error) -> Void in
                    if(error != nil){
                        print("Error: ", error)
                    }
                    
                    if let placemark = placemarks?.first{
                        let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                        let newLocation = CLLocation(latitude : coordinates.latitude, longitude : coordinates.longitude)
                        self.centerMapOnLocation(location: newLocation)
                        
                        let dropPin = MKPointAnnotation()
                        dropPin.coordinate = coordinates
                        dropPin.title = placemark.name
                        self.myMapView.addAnnotation(dropPin)
                        self.myMapView.selectAnnotation(dropPin, animated: true)
                        
                        let request = MKDirections.Request()
                        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.initialLocation.coordinate, addressDictionary: nil))
                        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                        
                        request.requestsAlternateRoutes = false
                        request.transportType = .automobile
                        
                        let directions = MKDirections(request: request)
                        directions.calculate(completionHandler:
                            {
                                [unowned self] response, error in
                                for route in (response?.routes)!
                                {
                                    self.myMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                                    self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                                    self.routeSteps.removeAll()
                                    for step in route.steps {
                                        self.routeSteps.append(step.instructions)
                                    }
                                    self.myTableView.reloadData()
                                }
                            }
                            
                        )
                    }
            }

            
            
        )
        
        geocoder.geocodeAddressString(wp2EnteredText!, completionHandler:
            {
                (placemarks, error) -> Void in
                if(error != nil){
                    print("Error: ", error)
                }
                
                if let placemark = placemarks?.first{
                    let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                    let newLocation = CLLocation(latitude : coordinates.latitude, longitude : coordinates.longitude)
                    self.centerMapOnLocation(location: newLocation)
                    
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinates
                    dropPin.title = placemark.name
                    self.myMapView.addAnnotation(dropPin)
                    self.myMapView.selectAnnotation(dropPin, animated: true)
                    
                    let request = MKDirections.Request()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.initialLocation.coordinate, addressDictionary: nil))
                    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                    
                    request.requestsAlternateRoutes = false
                    request.transportType = .automobile
                    
                    let directions = MKDirections(request: request)
                    directions.calculate(completionHandler:
                        {
                            [unowned self] response, error in
                            for route in (response?.routes)!
                            {
                                self.myMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                                self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                                self.routeSteps.removeAll()
                                for step in route.steps {
                                    self.routeSteps.append(step.instructions)
                                }
                                self.myTableView.reloadData()
                            }
                        }
                        
                    )
                }
        }
            
            
            
        )
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.darkGray
        renderer.lineWidth = 2.0
        return renderer
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeSteps.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        tableCell.textLabel?.text = routeSteps[indexPath.row]
        
        return tableCell
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
