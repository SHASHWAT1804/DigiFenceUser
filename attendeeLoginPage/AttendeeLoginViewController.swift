import UIKit

class AttendeeLoginViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeIconButton: UIButton!
    @IBOutlet weak var termsCheckboxButton: UIButton!
    @IBOutlet weak var googleIconImageView: UIImageView!
    @IBOutlet weak var appleIconImageView: UIImageView!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    var userRole: String? // Passed from OnboardViewController
    private var isPasswordVisible = false // Track the visibility state of the password

    override func viewDidLoad() {
        super.viewDidLoad()
        print("User Role in LoginVC: \(userRole ?? "No role")")
        updateWelcomeLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWelcomeLabel()
    }
    
    private func updateWelcomeLabel() {
        if let role = userRole {
            switch role {
            case "organizer":
                welcomeLabel.text = "Welcome Organizer"
            case "attendee":
                welcomeLabel.text = "Welcome Attendee"
            default:
                welcomeLabel.text = "Welcome"
            }
        } else {
            welcomeLabel.text = "Welcome"
        }
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter all fields.")
            return
        }

        // Ensure terms checkbox is checked
        if !termsCheckboxButton.isSelected {
            showAlert(message: "You must agree to the Terms and Conditions.")
            return
        }

        // Authenticate user from the respective JSON file
        if let authenticatedUser = authenticateUser(email: email, password: password) {
            loggedInUser = authenticatedUser
            navigateToHomePage(with: authenticatedUser.email)
        } else {
            showAlert(message: "Invalid email or password.")
        }
    }

    private func authenticateUser(email: String, password: String) -> User? {
        let fileName = userRole == "organizer" ? "organizer.json" : "attendee.json"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)

        // Read and decode the JSON file
        guard let data = try? Data(contentsOf: fileURL),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            print("Failed to read or decode \(fileName)")
            return nil
        }

        // Check if any user matches the entered email and password
        return users.first { $0.email == email && $0.password == password }
    }

    private func navigateToHomePage(with email: String) {
        if let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            profileVC.loggedInEmail = email // Pass the logged-in user's email
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        let imageName = isPasswordVisible ? "eye-filled" : "eye-closed"
        eyeIconButton.setImage(UIImage(named: imageName), for: .normal)
    }

    @IBAction func termsCheckboxTapped(_ sender: UIButton) {
        termsCheckboxButton.isSelected.toggle()
        let imageName = termsCheckboxButton.isSelected ? "checkbox-checked" : "checkbox-unchecked"
        termsCheckboxButton.setImage(UIImage(named: imageName), for: .normal)
    }

    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let forgetVC = storyboard.instantiateViewController(withIdentifier: "AttendeeForgetViewController") as? AttendeeForgetViewController {
            navigationController?.pushViewController(forgetVC, animated: true)
        }
    }
}
