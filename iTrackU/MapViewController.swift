//
//  MapViewController.swift
//  iTrackU
//
//  Created by Juan Riveros on 9/27/17.
//  Copyright © 2017 Juan Riveros. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate {

    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let manager = CLLocationManager()
    let annotation = MKPointAnnotation()
    var data = [Visits]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.startMonitoringVisits()
        fetchAll()
        
        //PIN LOCATION
        var annotations = [MKPointAnnotation]()
        
        for i in data{
            let anno = MKPointAnnotation()
            anno.coordinate = CLLocationCoordinate2DMake(i.latitude, i.longitude)
            annotations.append(anno)
        }
        
//        for location in coordinates{
//            annotations.append(["latitude":i])
//        }
        
        for i in annotations{
            print("inside annotations loop --->", i)
        }
        
        map.showAnnotations(annotations, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @IBOutlet weak var map: MKMapView!
    
    
    
//    UPDATE LOCATION
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    
//        //GET LOCATION AND MAP VIEW MOVEMENT
//        let location = locations[0]
//        let span = MKCoordinateSpanMake(0.01, 0.01)
//        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: myLocation, span: span)
//        map.setRegion(region, animated: true)
//        self.map.showsUserLocation = true
//
////            //GET COORDINATE ADDRESS
////            let loc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
////            CLGeocoder().reverseGeocodeLocation(loc) { (placemark, error) in
////                print(placemark![0].administrativeArea)
////
////            }
//
////        if Int((locations[0].speed)*2.236936284) < 0{
////            speed.text = "0"
////        }else{
////            speed.text = String(Int((locations[0].speed)*2.236936284))
////        }
//
////        stoptUpdaLoc()
////        saveToDB()
////        fetchAll()
//        
//    }
    
    
    
    
    
    
    
    //START UPDATING LOCATION
    func startUpdaLoc(){
        manager.startUpdatingLocation()
    }
    
    
    //STOP UPDATING LOCATION
    func stoptUpdaLoc(){
        manager.stopUpdatingLocation()
    }
    
    
    //SAVE TO DATA BASE
    func saveToDB(){
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("\(error)")
            }
        }
    }
    
    //FETCH ALL
    func fetchAll(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Visits")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        do {
            data = try moc.fetch(fetchRequest) as! [Visits]
        } catch {
            print("\(error)")
        }
        
    }
}
