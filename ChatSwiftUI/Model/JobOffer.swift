import Foundation

struct JobOffer: Hashable, Identifiable, Codable {
    let id: String
    let title: String
    let jobType: Int
    let duration: String?
    let hourlyBudget: String?
    let clientId: Int
    let tierLabel: String
    let addDate: Date
    let publishedOn: Date
    let url: String
    let description: String
    let amount: Double?
    let connectPrice: Int
    let tier: String
    let status: Int
    let client: Client
    let tags: [Tag]
    
    enum CodingKeys: String, CodingKey {
        case id, title, duration, url, description, amount, tier, status, client, tags
        case jobType = "job_type"
        case hourlyBudget = "hourly_budget"
        case clientId = "client_id"
        case tierLabel = "tier_label"
        case addDate = "add_date"
        case publishedOn = "published_on"
        case connectPrice = "connect_price"
    }

    struct Client: Codable, Hashable {
        let totalHires: Int
        let totalSpent: Double
        let country: String
        let totalFeedback: Double
        let paymentVerificationStatus: Bool
        let id: Int
        let totalReviews: Int
        
        enum CodingKeys: String, CodingKey {
            case totalHires = "total_hires"
            case totalSpent
            case country
            case totalFeedback
            case paymentVerificationStatus = "payment_verification_Status"
            case id
            case totalReviews = "total_reviews"
        }
    }

    struct Tag: Codable, Identifiable, Hashable {
        let name: String
        let id: String
    }

    init(id: String, title: String, jobType: Int, duration: String?, hourlyBudget: String?, clientId: Int,
         tierLabel: String, addDate: Date, publishedOn: Date, url: String, description: String,
         amount: Double?, connectPrice: Int, tier: String, status: Int, client: Client, tags: [Tag]) {
        self.id = id
        self.title = title
        self.jobType = jobType
        self.duration = duration
        self.hourlyBudget = hourlyBudget
        self.clientId = clientId
        self.tierLabel = tierLabel
        self.addDate = addDate
        self.publishedOn = publishedOn
        self.url = url
        self.description = description
        self.amount = amount
        self.connectPrice = connectPrice
        self.tier = tier
        self.status = status
        self.client = client
        self.tags = tags
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        jobType = try container.decode(Int.self, forKey: .jobType)
        duration = try container.decodeIfPresent(String.self, forKey: .duration)
        hourlyBudget = try container.decodeIfPresent(String.self, forKey: .hourlyBudget)
        clientId = try container.decode(Int.self, forKey: .clientId)
        tierLabel = try container.decode(String.self, forKey: .tierLabel)
        url = try container.decode(String.self, forKey: .url)
        description = try container.decode(String.self, forKey: .description)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        connectPrice = try container.decode(Int.self, forKey: .connectPrice)
        tier = try container.decode(String.self, forKey: .tier)
        status = try container.decode(Int.self, forKey: .status)
        client = try container.decode(Client.self, forKey: .client)
        tags = try container.decode([Tag].self, forKey: .tags)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let addDateString = try container.decode(String.self, forKey: .addDate)
        if let date = dateFormatter.date(from: addDateString) {
            addDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .addDate, in: container, debugDescription: "Date string does not match format")
        }
        
        let publishedOnString = try container.decode(String.self, forKey: .publishedOn)
        if let date = dateFormatter.date(from: publishedOnString) {
            publishedOn = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .publishedOn, in: container, debugDescription: "Date string does not match format")
        }
    }

    func copy(status: Int? = nil) -> JobOffer {
        let newTags = self.tags
        let newClient = self.client
        return JobOffer(id: self.id, title: self.title, jobType: self.jobType, duration: self.duration,
                        hourlyBudget: self.hourlyBudget, clientId: self.clientId, tierLabel: self.tierLabel,
                        addDate: self.addDate, publishedOn: self.publishedOn, url: self.url,
                        description: self.description, amount: self.amount, connectPrice: self.connectPrice,
                        tier: self.tier, status: status ?? self.status, client: newClient, tags: newTags)
    }
}

extension JobOffer {
    var tagNames: [String] {
        return tags.map { $0.name }
    }
}
