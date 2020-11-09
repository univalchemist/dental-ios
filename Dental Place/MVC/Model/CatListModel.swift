import Foundation

struct CatListModel : Codable {
    
    let code : String?
    let status : String?
     let message : String?
    let data : [CatListDatum]?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
}
struct CatListDatum : Codable {
    
    let id : Int?
    let userName : String?
    let userEmail : String?
    let profileImage : String?
    let level : String?
    let categoryId : String?
    let datetime : String?
    let otp : String?
    let source : String?
    let facebookId : String?
    let googleId : String?
    let status : String?
    let benStart : String?
    let benEnd : String?
    let createdAt : String?
    let updatedAt : String?
    let vendorMeta : [VendorMeta]?
    let vendorReviews : [VendorReview]?
    let reviewsCount : Int?
    let reviewsAvg : Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "user_name"
        case userEmail = "user_email"
        case profileImage = "profile_image"
        case level = "level"
        case categoryId = "categoryId"
        case datetime = "datetime"
        case otp = "otp"
        case source = "source"
        case facebookId = "facebook_id"
        case googleId = "google_id"
        case status = "status"
        case benStart = "ben_start"
        case benEnd = "ben_end"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case vendorMeta = "vendor_meta"
        case vendorReviews = "vendor_reviews"
        case reviewsCount = "reviewsCount"
        case reviewsAvg = "reviewsAvg"
}

}
struct VendorReview : Codable {
    
    let id : Int?
    let vendorId : String?
    let userId : String?
    let starRate : String?
    let feedback : String?
    let createdAt : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case vendorId = "vendor_id"
        case userId = "user_id"
        case starRate = "star_rate"
        case feedback = "feedback"
        case createdAt = "created_at"
    }
}
struct VendorMeta : Codable {
    
    let id : Int?
    let vendorId : String?
    let address : String?
    let address1 : String?
    let country : String?
    let city : String?
    let zipcode : String?
    let contact : String?
    let gender : String?
    let dob : String?
    let open : CatOpen?
    let close : CatClose?
    let service : CatService?
    let updatedAt : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case vendorId = "vendor_id"
        case address = "address"
        case address1 = "address1"
        case country = "country"
        case city = "city"
        case zipcode = "zipcode"
        case contact = "contact"
        case gender = "gender"
        case dob = "dob"
        case open = "open"
        case close = "close"
        case service = "service"
        case updatedAt = "updated_at"
    }

}

struct CatService : Codable {
    
    let generalCheckup : String?
    let generalCheckup1 : String?
    let generalCheckup2 : String?
    let generalCheckup3 : String?
    
    enum CodingKeys: String, CodingKey {
        case generalCheckup = "General Checkup"
        case generalCheckup1 = "General Checkup1"
        case generalCheckup2 = "General Checkup2"
        case generalCheckup3 = "General Checkup3"
    }
    
}
struct CatClose : Codable {
    
    let sun : String?
    let mon : String?
    let tue : String?
    let wed : String?
    let thu : String?
    let fri : String?
    let sat : String?
    
    enum CodingKeys: String, CodingKey {
        case sun = "Sun"
        case mon = "Mon"
        case tue = "Tue"
        case wed = "Wed"
        case thu = "Thu"
        case fri = "Fri"
        case sat = "Sat"
    }
}
struct CatOpen : Codable {
    
    let sun : String?
    let mon : String?
    let tue : String?
    let wed : String?
    let thu : String?
    let fri : String?
    let sat : String?
    
    enum CodingKeys: String, CodingKey {
        case sun = "Sun"
        case mon = "Mon"
        case tue = "Tue"
        case wed = "Wed"
        case thu = "Thu"
        case fri = "Fri"
        case sat = "Sat"
    }

}
