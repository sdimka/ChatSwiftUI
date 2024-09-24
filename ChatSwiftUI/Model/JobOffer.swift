import Foundation

struct JobOffer: Hashable, Identifiable, Codable {
    let url: String
    let id: String
    let payment: String
    let spendings: String
    let tags: String
    let addDate: Date
    let title: String
    let description: String
    let stars: Int
    let country: String
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case url, id, payment, spendings, tags, title, description, stars, country, status
        case addDate = "add_date"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        url = try container.decode(String.self, forKey: .url)
        id = try container.decode(String.self, forKey: .id)
        payment = try container.decode(String.self, forKey: .payment)
        spendings = try container.decode(String.self, forKey: .spendings)
        tags = try container.decode(String.self, forKey: .tags)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        stars = try container.decode(Int.self, forKey: .stars)
        country = try container.decode(String.self, forKey: .country)
        status = try container.decode(Int.self, forKey: .status)
        
        let dateString = try container.decode(String.self, forKey: .addDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            addDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .addDate, in: container, debugDescription: "Date string does not match format")
        }
    }
}

extension JobOffer {
    var tagArray: [String] {
        tags.components(separatedBy: ";").filter { !$0.isEmpty }
    }
}
