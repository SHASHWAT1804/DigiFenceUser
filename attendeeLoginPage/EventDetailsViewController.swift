import UIKit

class EventDetailsViewController: UIViewController {

    var selectedEvent: ViewController.Event? // Property to receive the selected event
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostEmailLabel: UILabel!
    @IBOutlet weak var hostPhoneLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Safely unwrap and use selectedEvent
        if let event = selectedEvent {
            eventNameLabel.text = event.name
            eventDateLabel.text = event.date
            eventTimeLabel.text = event.time
            eventDescriptionLabel.text = event.eventDescription
            hostNameLabel.text = event.hostName
            hostEmailLabel.text = event.hostEmail
            hostPhoneLabel.text = event.hostPhone

            // Set the event image
            if let image = UIImage(named: event.image) {
                eventImageView.image = image
            } else {
                eventImageView.image = UIImage(named: "defaultImage") // Optional: Set a default image if none found
            }
        }
    }
}
