import Foundation

// Protocol to handle fetching data / error from API
protocol NewsManagerDelegate {
    func didFetchNews(data: NewsModel)
    func didGetError()
}

struct NewsManager {
    // Base API URLs
    let baseSearchStringURL = "https://newscatcher.p.rapidapi.com/v1/search?"
    let baseSearchTopicURL = "https://newscatcher.p.rapidapi.com/v1/latest_headlines?"
    
    // Base request parameters
    var parametersSearchString = ["media": "True", "sort_by" : "relevancy", "lang" : "en", "page" : "1","q":"Iphone"]
    var parametersSearchTopic = ["media": "True", "lang" : "en","topic":"news"]
    
    // request authentication header
    let headers = ["x-rapidapi-key": RequestData.xRapidapiKey]
    
    var delegate: NewsManagerDelegate?
    
    // functions setting news parameters
    mutating func SetSearchQParam(topic: String) {
        self.parametersSearchString["q"] = topic
    }
    mutating func SetSearchTopicParam(topic: String) {
        self.parametersSearchTopic["topic"] = topic
    }
    mutating func SetLang(lang: String){
        self.parametersSearchTopic["lang"] = lang
        self.parametersSearchString["lang"] = lang
    }
    
    // function preparing request with string topic
    func PrepareSearchStringRequest() -> URLRequest{
        var url = URLComponents(string: baseSearchStringURL)
        var queryItems = [URLQueryItem]()
        for (key, value) in parametersSearchString {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        url?.queryItems = queryItems
        var request = URLRequest(url: (url?.url)!)
        request.httpMethod = "GET"

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    // function preparing request with topic selected for pick view
    func PrepareSearchTopicRequest() -> URLRequest{
        var url = URLComponents(string: baseSearchTopicURL)
        var queryItems = [URLQueryItem]()
        for (key, value) in parametersSearchTopic {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        url?.queryItems = queryItems
        var request = URLRequest(url: (url?.url)!)
        request.httpMethod = "GET"

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    // function sending request to API
    func PerformRequest(for request: URLRequest){
        let task = URLSession.shared.dataTask(with: request, completionHandler: HandleRequest(data: response: error:))
        task.resume()
    }
    
    // function handling returned data from API
    func HandleRequest(data: Data?, response: URLResponse?, error: Error?){
        if error != nil {
            delegate?.didGetError()
        }
        else{
            if let safeData = data{
                self.DecodeJSON(dataToDecode: safeData)
            }
        }
    }
    
    // function decoding data from JSON to NewsModel object
    func DecodeJSON(dataToDecode: Data){
        let jsonDecoder = JSONDecoder()
        do {
            let decodedData = try jsonDecoder.decode(NewsModel.self, from: dataToDecode)
            delegate?.didFetchNews(data: decodedData)
        } catch{
            print(error)
            delegate?.didGetError()
        }
    }

}
