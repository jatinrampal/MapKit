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
    
    var coordinate1 : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var location1 : CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    var coordinate2 : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var location2 : CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    var coordinate3 : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var location3 : CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    let regionRadius : CLLocationDistance = 1000
    func centerMapOnLocation(location : CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        myMapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        print("Unwind to View Controller")
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
    
        let circle = MKCircle(center: initialLocation.coordinate, radius: regionRadius)
        self.myMapView.addAnnotation(circle)
        self.myMapView.selectAnnotation(circle, animated: true)

        
    }
    @IBAction func findNewLocation(){
        
        let wp1EnteredText = tbWayPoint1Entered.text
        let wp2EnteredText = tbWayPoint2Entered.text
        let locEnteredText = tbLocEntered.text
        let geocoder = CLGeocoder()
        

        
      /*  let overlays = myMapView.overlays
        myMapView.removeOverlays(overlays) */
        
        
        
        
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
        geocoder.geocodeAddressString(wp1EnteredText!, completionHandler:
            {
                (placemarks, error) -> Void in
                if(error != nil){
                    print("Error: ", error)
                }
                
                if let placemark = placemarks?.first{
                    self.coordinate1 = placemark.location!.coordinate
                    self.location1 = CLLocation(latitude : self.coordinate1.latitude, longitude : self.coordinate1.longitude)
                    self.centerMapOnLocation(location: self.location1)
                    
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = self.coordinate1
                    dropPin.title = placemark.name
                    self.myMapView.addAnnotation(dropPin)
                    self.myMapView.selectAnnotation(dropPin, animated: true)
                    
                    let request = MKDirections.Request()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.initialLocation.coordinate, addressDictionary: nil))
                    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.coordinate1, addressDictionary: nil))
                    
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
            break;
        case 1:
            geocoder.geocodeAddressString(wp2EnteredText!, completionHandler:
                {
                    (placemarks, error) -> Void in
                    if(error != nil){
                        print("Error: ", error)
                    }
                    
                    if let placemark = placemarks?.first{
                        self.coordinate2 = placemark.location!.coordinate
                        self.location2 = CLLocation(latitude : self.coordinate2.latitude, longitude : self.coordinate2.longitude)
                        self.centerMapOnLocation(location: self.location2)
                        
                        let dropPin = MKPointAnnotation()
                        dropPin.coordinate = self.coordinate2
                        dropPin.title = placemark.name
                        self.myMapView.addAnnotation(dropPin)
                        self.myMapView.selectAnnotation(dropPin, animated: true)
                        
                        let request = MKDirections.Request()
                        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.coordinate1, addressDictionary: nil))
                        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.coordinate2, addressDictionary: nil))
                        
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
                                    
                                    for step in route.steps {
                                        self.routeSteps.append(step.instructions)
                                    }
                                    self.myTableView.reloadData()
                                }
                            }
                            
                        )
                    }
            })
            break;
            
        case 2:
            geocoder.geocodeAddressString(locEnteredText!, completionHandler:
                {
                    (placemarks, error) -> Void in
                    if(error != nil){
                        print("Error: ", error)
                    }
                    
                    if let placemark = placemarks?.first{
                        self.coordinate3 = placemark.location!.coordinate
                        self.location3 = CLLocation(latitude : self.coordinate3.latitude, longitude : self.coordinate3.longitude)
                        self.centerMapOnLocation(location: self.location3)
                        
                        let dropPin = MKPointAnnotation()
                        dropPin.coordinate = self.coordinate3
                        dropPin.title = placemark.name
                        self.myMapView.addAnnotation(dropPin)
                        self.myMapView.selectAnnotation(dropPin, animated: true)
                        
                        let request = MKDirections.Request()
                        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.coordinate2, addressDictionary: nil))
                        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.coordinate3, addressDictionary: nil))
                        
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
                                    
                                    for step in route.steps {
                                        self.routeSteps.append(step.instructions)
                                    }
                                    self.myTableView.reloadData()
                                }
                            }
                            
                        )
                    }
            })
            break;
        default:
            break
        }
        
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
