import UIKit
import LocalAuthentication
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    struct Event {
        var name: String
        var date: String
        var time: String
        var image: String
        var latitude: Double
        var longitude: Double
        var hostName: String
        var hostEmail: String
        var hostPhone: String
        var eventDescription: String
    }

    // Sample events with host info
    let events: [Event] = [
        Event(name: "Dil-luminati", date: "09/11/24", time: "10:30 AM", image: "Diljit", latitude: 35.6895, longitude: 139.6917, hostName: "John Doe", hostEmail: "john@example.com", hostPhone: "123-456-7890", eventDescription: "An illuminating cultural event."),
        Event(name: "NH7 Weekende", date: "04/11/24", time: "10:00 AM", image: "NH7Weekende", latitude: 37.7749, longitude: -122.4194, hostName: "Jane Smith", hostEmail: "jane@example.com", hostPhone: "987-654-3210", eventDescription: "A weekend full of music and fun."),
        Event(name: "Lollapalooza India", date: "05/11/24", time: "10:00 AM", image: "LollapaloozaIndia", latitude: 34.0522, longitude: -118.2437, hostName: "Robert Brown", hostEmail: "robert@example.com", hostPhone: "555-987-6543", eventDescription: "A grand music festival in India."),
        Event(name: "Sunburn", date: "06/11/24", time: "12:00 PM", image: "Sunburn", latitude: 40.7128, longitude: -74.0060, hostName: "Lisa Ray", hostEmail: "lisa@example.com", hostPhone: "444-333-2211", eventDescription: "Dance to the beats of Sunburn."),
        Event(name: "Hackathon 2024", date: "07/11/24", time: "09:00 AM", image: "hell", latitude: 51.5074, longitude: -0.1278, hostName: "Alice Green", hostEmail: "alice@example.com", hostPhone: "666-777-8888", eventDescription: "A coding marathon for developers."),
        Event(name: "Cultural Night", date: "08/11/24", time: "07:00 PM", image: "cultural", latitude: 28.7041, longitude: 77.1025, hostName: "Raj Kapoor", hostEmail: "raj@example.com", hostPhone: "999-888-7776", eventDescription: "A night celebrating cultural diversity.")
    ]

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DataTableViewCell else {
            return UITableViewCell()
        }

        let event = events[indexPath.row]
        cell.eventNameLabel.text = event.name
        cell.eventDateLabel.text = event.date
        cell.eventTimeLabel.text = event.time
        cell.eventImageView.image = UIImage(named: event.image)
        cell.eventImageView.layer.cornerRadius = 10
        cell.eventImageView.clipsToBounds = true

        // Style the card view
        cell.epassCardView.layer.cornerRadius = 10
        cell.epassCardView.layer.shadowColor = UIColor.black.cgColor
        cell.epassCardView.layer.shadowOpacity = 0.2
        cell.epassCardView.layer.shadowOffset = CGSize(width: 0, height: 2)

        // Set button tag to the current indexPath.row
        cell.activatePassButton.tag = indexPath.row
        cell.activatePassButton.addTarget(self, action: #selector(activatePassTapped(_:)), for: .touchUpInside)
        cell.infotapped.tag = indexPath.row // Set tag for info button
        cell.infotapped.addTarget(self, action: #selector(infotappedButtonTapped(_:)), for: .touchUpInside) // Add target for info button

        return cell
    }

    @objc func activatePassTapped(_ sender: UIButton) {
        authenticateUser(for: sender.tag)
    }

    @objc func infotappedButtonTapped(_ sender: UIButton) {
        // Perform segue to EventDetailsViewController
        performSegue(withIdentifier: "ShowEventDetails", sender: sender)
    }

    func authenticateUser(for index: Int) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access your event pass"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.showECodePopup(for: index) // Pass the index to show the e-code popup
                    } else {
                        self.showErrorAlert()
                    }
                }
            }
        } else {
            showAlert(title: "Authentication Unavailable", message: "Biometric authentication is not available on this device.")
        }
    }

    func showECodePopup(for index: Int) {
        let uniqueECode = String(format: "%06d", Int.random(in: 100000...999999))
        let alert = UIAlertController(title: "ePass Activated", message: "Your unique e-code is \(uniqueECode).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.deactivateButton(at: index) // Deactivate the button after OK is clicked
        }))
        
        present(alert, animated: true, completion: nil)
    }

    func deactivateButton(at index: Int) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DataTableViewCell {
            // Disable the button
            cell.activatePassButton.isEnabled = false
            cell.activatePassButton.alpha = 0.5 // Fade out visually if desired
        }
    }

    func showErrorAlert() {
        let alert = UIAlertController(title: "Authentication Failed", message: "Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    // Prepare for segue to pass event data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventDetails", let indexPath = tableView.indexPathForSelectedRow {
            let event = events[indexPath.row] // Get the selected event
            if let eventDetailsVC = segue.destination as? EventDetailsViewController {
                eventDetailsVC.selectedEvent = event // Pass the selected event to the EventDetailsViewController
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
