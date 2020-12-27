import UIKit

class NewsListViewController: UIViewController {
    @IBOutlet weak var NewsScrollView: UIScrollView!
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
        
        // set language parameter in urlRequest
        newsManager.SetLang(lang: lang!)
        
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
    // function returning calculated height for given string
    func getHeight(for string: String, font: UIFont, width: CGFloat) -> CGFloat {
        let textStorage = NSTextStorage(string: string)
        let textContainter = NSTextContainer(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainter)
        textStorage.addLayoutManager(layoutManager)
        textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, textStorage.length))
        textContainter.lineFragmentPadding = 0.0
        layoutManager.glyphRange(for: textContainter)
        return layoutManager.usedRect(for: textContainter).size.height
    }
    // function returning calculated full height for scrollView (all news in dict)
    func PrepareFullHeight(dict: [[String:String]]) -> Int{
        var fullHeight = CGFloat(0)
        for n in dict{
            var SingleHeight = CGFloat(0)
            for (_, v) in n {
                
                let sectionHeight = self.getHeight(for: v, font: UIFont.init(name: "Hiragino Mincho ProN W3", size: 17)!, width: CGFloat(Int(self.view.frame.width-35)))
                SingleHeight += sectionHeight + 10
            }
            fullHeight += SingleHeight + 10
        }
        return Int(fullHeight)
    }
    // function returning calculated height single news given as dict
    func PrepareSingleHeight(dict: [String:String]) -> Int{
        var SingleHeight = CGFloat(0)
        for (_, v) in dict {
            let sectionHeight = getHeight(for: v, font: UIFont.init(name: "Hiragino Mincho ProN W3", size: 17)!, width: CGFloat(Int(view.frame.width-25)))
            SingleHeight += sectionHeight
        }
        return Int(SingleHeight)
    }
    func PrepareErrorUI(){
        DispatchQueue.main.async {
            let errorLabel = UILabel(frame: CGRect(x: 10, y: 10, width: Int(self.view.frame.width-40), height: 40))
            errorLabel.text = self.lang == "en" ? "There is nothing here :(" : "Nic tu nie ma :("
            errorLabel.font = UIFont.init(name: "Hiragino Mincho ProN W3", size: 17)!
            self.NewsScrollView.addSubview(errorLabel)
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                errorLabel.centerXAnchor.constraint(equalTo: self.NewsScrollView.centerXAnchor)
                
            ])
        }
    }
    // function preparing all news views and text labels
    func PrepareUI(dict: [[String:String]]){
        var newsList = [UIView]()
        var newsCounter = 0
        for n in dict{
            DispatchQueue.main.async {
                // create view for storing text
                let view = UIView(frame: CGRect(x: 10, y: CGFloat(newsCounter), width: self.view.frame.size.width-20, height: CGFloat(self.PrepareSingleHeight(dict: n)+60)))
                
                // make view corners radius
                view.layer.cornerRadius = 25
                
                // increase y position for next view
                newsCounter += self.PrepareSingleHeight(dict: n) + 60
                
                // starting y position for text
                var actHeight = 10
                
                // iterating through news dictionary
                for (key , value) in n.sorted(by: {$0 < $1}) {
                    // calculated height of label
                    let lblHeight = self.getHeight(for: value, font: UIFont.init(name: "Hiragino Mincho ProN W3", size: 17)!, width: CGFloat(Int(view.frame.width-7)))
                    
                    // created label
                    let data = UILabel(frame: CGRect(x: 5, y: actHeight, width: Int(view.frame.width-7), height: Int(lblHeight)))
                    
                    actHeight += Int(lblHeight)+2
                    data.text = value
                    
                    // change layout of label
                    if(key == "2title"){
                        data.font = UIFont.init(name: "Hiragino Mincho ProN W6", size: 17)!
                    }
                    else if(key == "4link"){
                        data.font = UIFont.italicSystemFont(ofSize: 17)
                    }
                    else{
                        data.font = UIFont.systemFont(ofSize: 17)
                    }
                    
                    data.numberOfLines = 0
                    data.lineBreakMode = NSLineBreakMode.byWordWrapping
                    view.addSubview(data)
                }
                view.backgroundColor = UIColor( red: CGFloat(213/255.0), green: CGFloat(250/255.0), blue: CGFloat(240/255.0), alpha: CGFloat(0.5))
                self.NewsScrollView.addSubview(view)
                newsList.append(view)
                
                // distance between news views
                newsCounter += 10
            }
        }
    }
}
extension NewsListViewController: NewsManagerDelegate{
    // function called when data is fetched
    func didFetchNews(data: NewsModel){
        // transform NewsModel into dict
        let dict = data.ConvertModelToDict()
        DispatchQueue.main.sync {
            self.fullHeight = PrepareFullHeight(dict: dict)
            self.NewsScrollView.contentSize = CGSize(width: 375, height: fullHeight! + 100)
            self.PrepareUI(dict: dict)
        }
    }
    func didGetError() {
        self.PrepareErrorUI()
    }
}
