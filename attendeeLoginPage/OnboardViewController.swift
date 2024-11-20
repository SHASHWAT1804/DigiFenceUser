import UIKit

class OnboardViewController: UIViewController {
    var selectedRole: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func joinAsOrganizerTapped(_ sender: UIButton) {
        selectedRole = "organizer" // Set role as organizer
        navigateToSignUpOrLogin()
    }
    @IBAction func joinAsAttendeeTapped(_ sender: UIButton) {
        selectedRole = "attendee" // Set role as attendee
        navigateToSignUpOrLogin()
    }

    private func navigateToSignUpOrLogin() {
        // Instead of segue, instantiate the view controller programmatically
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "AttendeeLoginViewController") as? AttendeeLoginViewController {
            loginVC.userRole = selectedRole // Pass the selected role
            print("Selected Role: \(selectedRole ?? "No role")") // Debugging print
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
