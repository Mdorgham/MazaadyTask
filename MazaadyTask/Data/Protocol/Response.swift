import Foundation

struct Response<T: Codable> {
    let value: T
    let response: URLResponse
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Error)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "عنوان URL غير صالح"
        case .noData:
            return "لا توجد بيانات"
        case .decodingError(let error):
            return "خطأ في فك التشفير: \(error.localizedDescription)"
        case .serverError(let error):
            return "خطأ في الخادم: \(error.localizedDescription)"
        case .unknown:
            return "خطأ غير معروف"
        }
    }
}
