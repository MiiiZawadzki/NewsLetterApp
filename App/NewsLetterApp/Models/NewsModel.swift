import Foundation

struct NewsModel: Codable{
    let status: String
    var articles = [News]()
}

struct News: Codable {
    let title:String
    let summary:String
    let published_date:String
    let clean_url:String
}
