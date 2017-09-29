//
//  DetailViewController.swift
//  iTrackU
//
//  Created by Juan Riveros on 9/27/17.
//  Copyright © 2017 Juan Riveros. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class DetailViewController: UIViewController, CLLocationManagerDelegate {

    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let annotation = MKPointAnnotation()
    let manager = CLLocationManager()
    var delegate: DetailViewControllerDelegate?
    var location: CLLocation?
    var index: Int?
    
    var data = [Visits]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        fetchAll()
        saveToDB()
        print("this is latitude", data[index!])
        print("this is longitude", data[index!])
        
        //TOTAL TIME
        let totalTime = data[index!].rawOutTime!.timeIntervalSince(data[index!].rawInTime!)
        let totalTimeString = stringFromTimeInterval(interval: totalTime)
        
        //PIN LOCATION
        let coordinate = CLLocationCoordinate2DMake(data[index!].latitude, data[index!].longitude)
        annotation.coordinate = coordinate
        detailMap.addAnnotation(annotation)

        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        detailMap.setRegion(region, animated: true)
        self.detailMap.showsUserLocation = false
        
        //ASSIGNING DATA TO LABELS
        locationNumberLabel.text = "Location \(String(describing: index!+1))"
        street.text = data[index!].street
        city.text = data[index!].city
        state.text = data[index!].state
        zipCode.text = data[index!].zipCode
        arrivalTime.text = data[index!].arrTime
        departureTime.text = data[index!].deptTime
        totalTimeLabel.text = totalTimeString
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        delegate?.backButton(by: self)
    }
    
    @IBOutlet weak var detailMap: MKMapView!
    @IBOutlet weak var locationNumberLabel: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var zipCode: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    
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
    
    //GET HOURS:MINUTES FROM TIMEINTERVAL
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02dhrs%02dmin", hours, minutes)
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
    
    //START UPDATING LOCATION
    func startUpdaLoc(){
        manager.startUpdatingLocation()
    }
    
    
    //STOP UPDATING LOCATION
    func stoptUpdaLoc(){
        manager.stopUpdatingLocation()
    }
}
