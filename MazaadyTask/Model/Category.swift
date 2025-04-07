import Foundation

// MARK: - BrandsResponse
struct CategoriesResponse: Codable {
    var message: Message?
    var data: CategoryData?
}

// MARK: - DataClass
struct CategoryData: Codable {
    var categories: [Category]?
    var iosVersion, iosLatestVersion, googleVersion, huaweiVersion: String?
}

// MARK: - Category
struct Category: Codable {
    var id: Int?
    var name, slug: String?
    var parentid: Int?
    var propertiesCount: Int?
    var image: CategoryImage?
    var seoTags: [String]?
    var isOther: Bool?
}

// MARK: - Image
struct CategoryImage: Codable {
    var medium, thumbnail: String?
    var id: Int?
    var customProperties: String?
    var placeHolder: PlaceHolder?
}

// MARK: - PlaceHolder
struct PlaceHolder: Codable {
    var smallNoBg, mediumBg, smallBg: String?
}

// MARK: - Message
struct Message: Codable {
    var txt: String?
} 
