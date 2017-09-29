//
//  ViewController.swift
//  iTrackU
//
//  Created by Juan Riveros on 9/22/17.
//  Copyright © 2017 Juan Riveros. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class MainViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, DetailViewControllerDelegate {
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let manager = CLLocationManager()
    var data = [Visits]()
    
    //VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        TableView.dataSource = self
        TableView.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.startMonitoringVisits()
        
        
        fetchAll()
        TableView.reloadData()
        
    }
    
    override var prefersStatusBarHidden: Bool{
    return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //LINKS TO VIEW CONTROLLER
    @IBOutlet weak var TableView: UITableView!
    
    
    
    //VISIT INFORMATION
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("arrival",visit.arrivalDate, "departure", visit.departureDate ) //RAW IN/OUT DATA
        if visit.departureDate == NSDate.distantFuture || visit.arrivalDate == NSDate.distantPast{
            print("not ready yet, DATE TIME IS CRAZY ----->",visit.arrivalDate,"     OR------>", visit.departureDate)
        }else{
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Visits", into: moc) as! Visits
            
            //DATE/TIME FORMATTER
            let arrvTime = DateFormatter.localizedString(from: visit.arrivalDate, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
            let deptTime = DateFormatter.localizedString(from: visit.departureDate, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
            newRecord.rawInTime = visit.arrivalDate
            newRecord.rawOutTime = visit.departureDate
            newRecord.arrTime = arrvTime
            newRecord.deptTime = deptTime
            newRecord.latitude = visit.coordinate.latitude
            newRecord.longitude = visit.coordinate.longitude
            //COORDENATE TO ADDRESS
            let loc = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler:{ (placemark, error) in
                if error != nil{
                    print("error gathering placemark data")
                }else{
                    if let place = placemark?[0]{
                        if place.postalCode != nil{
                            newRecord.street = place.name!
                            newRecord.city = place.locality!
                            newRecord.zipCode = place.postalCode!
                            newRecord.state = place.administrativeArea!
                        }
                    }
                }
                self.saveToDB()
                self.fetchAll()
                self.TableView.reloadData()
                }
            )
        }
    }
    
    
    
    //PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationDetail = segue.destination as! DetailViewController
        destinationDetail.delegate = self
        destinationDetail.index = sender as? Int
    }
    
    func backButton(by: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //CELL CREATION

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! customCell

            cell.locationNumberLabel.text = "Location \(indexPath.row + 1)"
            cell.streetLabel.text = data[indexPath.row].street
            cell.city.text = data[indexPath.row].city
            cell.cityZipCodeLabel.text = data[indexPath.row].zipCode
            cell.city.text = data[indexPath.row].city
        
        
        //NEED TOTAL TIME!
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToDetail", sender: indexPath.row )
    }
    
    
    
    //START MONITORING VISITS
    func startMonVisits(){
        manager.startMonitoringVisits()
    }
    
    
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

