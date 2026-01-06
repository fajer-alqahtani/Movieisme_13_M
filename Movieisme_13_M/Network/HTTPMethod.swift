import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    //Updates existing data fully on the server
    case put = "PUT"
    //Updates part of existing data
    case patch = "PATCH"
    case delete = "DELETE"
}
