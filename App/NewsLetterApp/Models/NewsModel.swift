import Foundation

struct NewsModel: Codable{
    let status: String
    var articles = [News]()
    func ConvertModelToDict() -> [[String:String]] {
        var resultDict = [[String:String]]()
        for news in self.articles{
            var tmpDict = ["1date":"","2title":"","3summary":"","4link":""]
            tmpDict.updateValue(news.published_date, forKey: "1date")
            tmpDict.updateValue(news.title, forKey: "2title")
            tmpDict.updateValue(news.summary, forKey: "3summary")
            tmpDict.updateValue("[ "+news.clean_url+" ]", forKey: "4link")
            resultDict.append(tmpDict)
        }
        return resultDict
    }
}

struct News: Codable {
    let title:String
    let summary:String
    let published_date:String
    let clean_url:String
}
