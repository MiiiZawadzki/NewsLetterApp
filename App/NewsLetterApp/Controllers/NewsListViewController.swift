import UIKit

class NewsListViewController: UIViewController {
    @IBOutlet weak var NewsTableView: UITableView!
    @IBOutlet weak var GoBackButton: UIButton!
    var topic: String?
    var vcString: Bool = false
    // Back to previous view
    @IBAction func BackButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var newsManager = NewsManager()
    var newsModel: NewsModel?
    var lang: String?
    var fullHeight:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title for back button
        GoBackButton.setTitle(lang == "en" ? "Go back" : "Wróć", for: .normal)
        
        GoBackButton.layer.cornerRadius = 10
        
        NewsTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "ReuseableNewsCell")
        
        // set language parameter in urlRequest
        newsManager.SetLang(lang: lang!)
        NewsTableView.dataSource = self
        newsManager.delegate = self
        
        // if searching with given string perform Request
        if(vcString){
            newsManager.SetSearchQParam(topic: topic!)
            let request = newsManager.PrepareSearchStringRequest()
            newsManager.PerformRequest(for: request)
        }
        // if searching with topic selected from picker view perform Request
        else{
            newsManager.SetSearchTopicParam(topic: topic!)
            let request = newsManager.PrepareSearchTopicRequest()
            newsManager.PerformRequest(for: request)
        }
    }
}
extension NewsListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseableNewsCell", for: indexPath) as! NewsCell
        cell.TitleLabel.text = "Test Title"
        cell.SummaryLabel.text = "Test SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest SummaryTest Summary"
        cell.SourceLabel.text = "Test SourceTest SourceTest SourceTest SourceTest SourceTest Source"

        return cell
    }
}

extension NewsListViewController: NewsManagerDelegate{
    // function called when data is fetched
    func didFetchNews(data: NewsModel){
        // transform NewsModel into dict
        let dict = data.ConvertModelToDict()
        DispatchQueue.main.sync {
//            self.fullHeight = PrepareFullHeight(dict: dict)
//            self.NewsScrollView.contentSize = CGSize(width: 375, height: fullHeight! + 100)
//            self.PrepareUI(dict: dict)
        }
    }
    func didGetError() {
//        self.PrepareErrorUI()
    }
}
