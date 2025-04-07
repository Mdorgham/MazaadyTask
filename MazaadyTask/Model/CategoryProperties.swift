import Foundation

// MARK: - PropertiesResponse
struct PropertiesResponse: Codable {
    var message: Message?
    var data: PropertiesData?
}

// MARK: - PropertiesData
struct PropertiesData: Codable, Identifiable {
    var id: Int?
    var name: String?
    var description: String?
    var slug: String?
    var parent: Int?
    var list: Bool?
    var type: String?
    var value: String?
    var otherValue: String?
    var options: [Option]?
}

// MARK: - Option
struct Option: Codable, Identifiable {
    var id: Int?
    var name: String?
    var slug: String?
    var parent: Int?
    var child: Bool?
    var hasChild: Bool?
}

// MARK: - Message
struct Message: Codable {
    var txt: String?
} 