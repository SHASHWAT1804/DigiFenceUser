import UIKit
import MapKit
import CoreLocation

class MAPVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var DoneButton: UIBarButtonItem!
    
    var eventCoordinate: CLLocationCoordinate2D?
    var eventName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the mapView delegate
        mapView.delegate = self
        
        // Ensure eventCoordinate is not nil
        if let coordinate = eventCoordinate {
            centerMapOnEventLocation(coordinate: coordinate)
            addAnnotation(coordinate: coordinate) // Add pointer to event location
        } else {
            print("Error: Event coordinate is nil.")
        }
    }
    
    func centerMapOnEventLocation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = eventName
        mapView.addAnnotation(annotation)
    }
    
    // Customize annotation view for a clear pointer display
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "EventAnnotation"
        
        if annotation is MKPointAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.glyphImage = UIImage(named: "customPinIcon") // Use a custom pin image
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
        
    }
    
    // Action for Done button
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }}

