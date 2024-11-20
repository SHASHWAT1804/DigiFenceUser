import UIKit

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(with updatedAttendee: Attendee)
}

class EditViewController: UIViewController {
    // UI Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cellNoTextField: UITextField!

    // Delegate and attendee data
    weak var delegate: EditProfileDelegate?
    var attendee: Attendee?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate text fields with current attendee data
        if let attendee = attendee {
            nameTextField.text = attendee.name
            cellNoTextField.text = attendee.cellNo // Ensure this field is correctly populated
        } else {
            print("Error: Attendee data not found.")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Validate user input
        guard let updatedName = nameTextField.text, !updatedName.isEmpty,
              let updatedCellNo = cellNoTextField.text, !updatedCellNo.isEmpty else {
            print("Error: All fields are required.")
            return
        }
        

        // Update attendee object
        if var updatedAttendee = attendee {
            updatedAttendee.name = updatedName
            updatedAttendee.cellNo = updatedCellNo

            // Notify delegate
            delegate?.didUpdateProfile(with: updatedAttendee)

            // Dismiss the view controller
            navigationController?.popViewController(animated: true)
        }
    }
}
