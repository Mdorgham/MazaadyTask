struct PropertiesData: Codable, Identifiable {
    let message: Message
    let data: [Property]
    
    struct Message: Codable {
        let txt: [String?]  // تغيير من String إلى [String?] للتعامل مع null
    }
    
    struct Property: Codable, Identifiable {
        let id: Int
        let name: String
        let type: String
        let parentId: Int?
        let options: [Option]
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case type
            case parentId = "parent_id"
            case options
        }
    }
    
    struct Option: Codable, Identifiable {
        let id: Int
        let name: String
        let hasChild: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case hasChild = "has_child"
        }
    }
} 