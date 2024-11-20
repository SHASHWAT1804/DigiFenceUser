import UIKit

class ProfileViewController: UIViewController {
    // UI Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cellNoLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton! // IBOutlet for the logout button

    // Property to store the logged-in user's email
    var loggedInEmail: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedInEmail = loggedInUser?.email // Assuming loggedInUser holds current user data
        
        fetchProfileData()

        // Ensure that the logout button is linked correctly
        if let button = logoutButton {
            // Add target to the logout button programmatically
            button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        } else {
            print("Error: logoutButton is not linked.")
        }
    }

    @objc private func logoutButtonTapped() {
        // Clear session data (logged-in user data or token)
        loggedInUser = nil // Assuming you have a `loggedInUser` variable storing the logged-in user's info

        // Navigate to OnboardViewController (login/signup screen)
        if let onboardVC = storyboard?.instantiateViewController(withIdentifier: "OnboardViewController") {
            navigationController?.setViewControllers([onboardVC], animated: true) // Replaces the current view controller with OnboardViewController
        }
    }

    func fetchProfileData() {
        // Get the path to the Documents directory
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Unable to locate Documents directory.")
            return
        }

        // Construct the path to attendee.json
        let fileURL = documentsURL.appendingPathComponent("attendee.json")

        // Check if file exists
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("Error: attendee.json does not exist at path \(fileURL.path)")
            return
        }

        do {
            // Read the file content
            let data = try Data(contentsOf: fileURL)
            
            // Decode JSON data
            let attendees = try JSONDecoder().decode([Attendee].self, from: data)
            
            // Fetch the attendee whose email matches the loggedInEmail
            if let email = loggedInEmail,
               let attendee = attendees.first(where: { $0.email == email }) {
                updateUI(with: attendee)
            } else {
                print("Error: No attendee found with the email \(loggedInEmail ?? "")")
            }
        } catch {
            print("Error fetching or decoding JSON data: \(error.localizedDescription)")
        }
    }

    func updateUI(with attendee: Attendee) {
        // Update the UI with the attendee's details
        nameLabel.text = attendee.name
        roleLabel.text = attendee.role
        emailLabel.text = attendee.email
        cellNoLabel.text = attendee.cellNo
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare data for the next screen (EditViewController)
        if segue.identifier == "editProfileSegue" {
            let destinationVC = segue.destination as! EditViewController
            destinationVC.delegate = self // Set delegate for callback

            // Pass the current attendee object correctly
            destinationVC.attendee = Attendee(
                name: nameLabel.text ?? "",
                email: emailLabel.text ?? "",
                cellNo: cellNoLabel.text ?? "",
                password: "", // Password is not required for editing profile here
                role: roleLabel.text ?? ""
            )
        }
    }
}

// MARK: - Conform to EditProfileDelegate
extension ProfileViewController: EditProfileDelegate {
    // Handle profile update
    func didUpdateProfile(with updatedAttendee: Attendee) {
        // Update UI and JSON file after editing
        updateUI(with: updatedAttendee)
        updateAttendeeJSON(with: updatedAttendee)
    }

    func updateAttendeeJSON(with updatedAttendee: Attendee) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Unable to locate Documents directory.")
            return
        }

        let fileURL = documentsURL.appendingPathComponent("attendee.json")

        do {
            // Fetch existing attendees
            let data = try Data(contentsOf: fileURL)
            var attendees = try JSONDecoder().decode([Attendee].self, from: data)

            // Update attendee data
            if let index = attendees.firstIndex(where: { $0.email == updatedAttendee.email }) {
                attendees[index] = updatedAttendee
            }

            // Write back to JSON
            let updatedData = try JSONEncoder().encode(attendees)
            try updatedData.write(to: fileURL, options: .atomic)
        } catch {
            print("Error updating attendee.json: \(error.localizedDescription)")
        }
    }
}
