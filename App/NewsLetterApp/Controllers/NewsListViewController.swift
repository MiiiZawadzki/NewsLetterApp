import UIKit

class NewsListViewController: UIViewController {
    
    // UI elements
    @IBOutlet weak var NewsTableView: UITableView!
    @IBOutlet weak var GoBackButton: UIButton!
    @IBOutlet weak var TableView: UIView!
    
    // variable that stores the topic on which news are searched for
    var topic: String?
    
    // variable to handle changing between views controllers
    var vcString: Bool = false
    
    // Back to previous view
    @IBAction func BackButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // NewsModel structs
    var newsManager = NewsManager()
    var newsModel: NewsModel?
    
    // variable to handle language change
    var lang: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title for back button
        GoBackButton.setTitle(lang == "en" ? "Go back" : "Wróć", for: .normal)
        
        GoBackButton.layer.cornerRadius = 10
        
        // set language parameter in urlRequest
        newsManager.SetLang(lang: lang!)
        
        newsManager.delegate = self
        
        //MARK: - Setting up request
        
        // set request search parameters
        newsManager.SetSearchParam(type: vcString ? "q" : "topic", topic: topic!)
        
        // if searching with given string perform Request
        var request = newsManager.PrepareSearchStringRequest()
        // if searching with topic selected from picker view perform Request
        if(!vcString){
            request = newsManager.PrepareSearchTopicRequest()
            
        }
        newsManager.PerformRequest(for: request)
        
        //MARK: - Setting up table view options
        NewsTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "ReuseableNewsCell")
        NewsTableView.dataSource = self
        
    }
}
//MARK: - Fetching data and detecting errors
extension NewsListViewController: NewsManagerDelegate{
    // function called when data is fetched
    func didFetchNews(data: NewsModel){
        DispatchQueue.main.sync {
            self.newsModel = data
            self.NewsTableView.reloadData()
        }
    }
    // function called when error is fetched
    func didGetError() {
        DispatchQueue.main.async {
            let errorLabel = UILabel(frame: CGRect(x: 10, y: 10, width: Int(self.view.frame.width-40), height: 40))
            errorLabel.text = self.lang == "en" ? "There is nothing here :(" : "Nic tu nie ma :("
            errorLabel.font = UIFont.init(name: "Hiragino Mincho ProN W3", size: 17)!
            self.TableView.addSubview(errorLabel)
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                errorLabel.centerXAnchor.constraint(equalTo: self.TableView.centerXAnchor)
                
            ])
        }
    }
    
}
//MARK: - Creating table view and cells
extension NewsListViewController: UITableViewDataSource{
    // Return count of NewsModel article
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel?.articles.count ?? 0

    }
    
    // Return created cells with news data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseableNewsCell", for: indexPath) as! NewsCell
        if let safeModel = newsModel{
            cell.TitleLabel.text = safeModel.articles[indexPath.row].title
            cell.SummaryLabel.text = safeModel.articles[indexPath.row].summary
            cell.SourceLabel.text = "via: "+safeModel.articles[indexPath.row].clean_url
            cell.DateLabel.text = safeModel.articles[indexPath.row].published_date
        }
        return cell
    }
}


