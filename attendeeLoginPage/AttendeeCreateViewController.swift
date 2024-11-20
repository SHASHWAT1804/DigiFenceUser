import UIKit

class AttendeeCreateViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cellNoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var passwordEyeButton: UIButton! // Eye button next to the password field
    @IBOutlet weak var passwordAgainEyeButton: UIButton! // Eye button next to the password again field

    // MARK: - Properties
    var userRole: String?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureEyeButtons()
    }

    // MARK: - Actions
    @IBAction func signUpTapped(_ sender: Any) {
        // Validate all fields
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let cellNo = cellNoTextField.text, !cellNo.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please fill out all fields.")
            return
        }

        // Create a new user object
        let newUser = User(name: name, email: email, cellNo: cellNo, password: password, role: userRole ?? "attendee")

        // Save the user to the appropriate JSON file
        saveUserToFile(user: newUser)

        // Show success message and navigate to login page
        showAlert(message: "Account created successfully!") { [weak self] in
            self?.navigateToLoginPage()
        }
    }

    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        if sender == passwordEyeButton {
            passwordTextField.isSecureTextEntry.toggle()
            let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
            passwordEyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        } else if sender == passwordAgainEyeButton {
            passwordAgainTextField.isSecureTextEntry.toggle()
            let imageName = passwordAgainTextField.isSecureTextEntry ? "eye.slash" : "eye"
            passwordAgainEyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    // MARK: - Helper Functions
    private func configureEyeButtons() {
        passwordTextField.isSecureTextEntry = true
        passwordAgainTextField.isSecureTextEntry = true

        passwordEyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        passwordAgainEyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }

    private func saveUserToFile(user: User) {
        // Determine the correct file based on the role
        let fileName = user.role == "organizer" ? "organizer.json" : "attendee.json"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)

        var users: [User] = []

        // Read existing data from the file
        if let data = try? Data(contentsOf: fileURL),
           let existingUsers = try? JSONDecoder().decode([User].self, from: data) {
            users = existingUsers
        }

        // Add the new user to the list
        users.append(user)

        // Save the updated list back to the file
        do {
            let updatedData = try JSONEncoder().encode(users)
            try updatedData.write(to: fileURL, options: .atomic)
            print("User data saved successfully to \(fileName).")
            print("File path: \(fileURL.path)") // Log the file path in the console
            print("Saved data: \(users)")       // Log the saved data in the console
        } catch {
            print("Failed to save user data: \(error)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    private func navigateToLoginPage() {
        // Instantiate and navigate to the login page programmatically
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "AttendeeLoginViewController") as? AttendeeLoginViewController {
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
