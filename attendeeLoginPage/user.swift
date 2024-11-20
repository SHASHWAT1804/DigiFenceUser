import Foundation

struct User: Codable {
    var name: String
    var email: String
    var cellNo: String
    var password: String
    var role: String
}

struct Attendee: Codable {
    var name: String
    let email: String
    var cellNo: String
    let password: String
    let role: String
}

class UserSession {
    static let shared = UserSession()
    var loggedInEmail: String?
    var loggedInRole: String?
    var loggedInName: String?
    // Add any other user data here
}




var loggedInUser:User?


