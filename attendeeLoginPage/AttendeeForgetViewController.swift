//
//  AttendeeForgetViewController.swift
//  attendeeLoginPage
//
//  Created by UTKARSH NAYAN on 15/11/24.
//

import UIKit

class AttendeeForgetViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordEyeButton: UIButton! // Eye button for new password
    @IBOutlet weak var confirmPasswordEyeButton: UIButton! // Eye button for confirm password
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureEyeButtons()
    }
    
    @IBAction func resetPasswordTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let newPassword = newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill out all fields.")
            return
        }
        
        // Ensure new passwords match
        if newPassword != confirmPassword {
            showAlert(message: "New passwords do not match.")
            return
        }
        
        // Attempt to reset the password
        if resetPassword(email: email, newPassword: newPassword) {
            showAlert(message: "Password updated successfully!") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            showAlert(message: "Email not found.")
        }
    }
    
    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        if sender == newPasswordEyeButton {
            newPasswordTextField.isSecureTextEntry.toggle()
            let imageName = newPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
            newPasswordEyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        } else if sender == confirmPasswordEyeButton {
            confirmPasswordTextField.isSecureTextEntry.toggle()
            let imageName = confirmPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
            confirmPasswordEyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    private func configureEyeButtons() {
        newPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        newPasswordEyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        confirmPasswordEyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    
    private func resetPassword(email: String, newPassword: String) -> Bool {
        let fileURL = getDocumentsDirectory().appendingPathComponent("attendee.json")
        
        // Read and decode the JSON file
        guard let data = try? Data(contentsOf: fileURL),
              var users = try? JSONDecoder().decode([User].self, from: data) else {
            print("Failed to read or decode attendee.json")
            return false
        }
        
        // Search for the user by email
        if let index = users.firstIndex(where: { $0.email == email }) {
            // Update the password for the user
            users[index].password = newPassword
            
            // Save the updated data back to the file
            do {
                let updatedData = try JSONEncoder().encode(users)
                try updatedData.write(to: fileURL, options: .atomic)
                print("Password updated successfully for email: \(email)")
                return true
            } catch {
                print("Failed to update the password: \(error)")
                return false
            }
        }
        
        return false // Email not found
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
}
