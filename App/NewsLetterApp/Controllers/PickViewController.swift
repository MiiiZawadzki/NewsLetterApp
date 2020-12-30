import UIKit

// Topics names in English and Polish
let topicsEN = ["News","Sport","Tech","World","Finance","Politics","Business","Economics","Entertainment"]
let topicsPL = ["Wiadomości","Sport","Technologia","Świat","Finanse","Polityka","Biznes","Ekonomia","Rozrywka"]

class PickViewController: UIViewController {
    // UI elements
    @IBOutlet weak var TopicPicker: UIPickerView!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var OrTextLabel: UILabel!
    @IBOutlet weak var AlternativeTextLabel: UILabel!
    @IBOutlet weak var SearchWordsButton: UIButton!
    
    // Go to news list view
    @IBAction func SearchButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "PickToNewsList", sender: self)
    }
    
    // Go to Search view
    @IBAction func SearchByWordButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "PickToSearch", sender: self)
    }
    
    // variable to handle language change
    var lang:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUILang()
        TopicPicker.dataSource = self
        TopicPicker.delegate = self
        SearchButton.layer.cornerRadius = 10
        SearchWordsButton.layer.cornerRadius = 10
        TopicPicker.layer.borderWidth = 4
        TopicPicker.layer.cornerRadius = 25
        TopicPicker.layer.borderColor = CGColor.init(red: CGFloat(193/255.0), green: CGFloat(230/255.0), blue: CGFloat(220/255.0), alpha: CGFloat(1.0))
    }
    
    // prepare other views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickToNewsList"{
            let VC = segue.destination as! NewsListViewController
            VC.topic = topicsEN[TopicPicker.selectedRow(inComponent: 0)].lowercased()
            VC.lang = lang
        }
        if segue.identifier == "PickToSearch"{
            let VC = segue.destination as! SearchViewController
            VC.isLangEN = lang! == "en" ? true : false
        }
    }
    
    // function changing UI elements languages
    func UpdateUILang() {
        SearchButton.setTitle(lang! == "en" ? "Search" : "Wyszukaj", for: .normal)
        OrTextLabel.text = lang! == "en" ? "Or" : "Lub"
        AlternativeTextLabel.text = lang! == "en" ? "Search news by words" : "Wyszukaj wiadomości poprzez słowa"
        SearchWordsButton.setTitle(lang! == "en" ? "Search by words" : "Wyszukaj przez słowa", for: .normal)
    }
}

// Handle picker view
extension PickViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return topicsEN.count
    }
}
extension PickViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if lang == "en"{
            return topicsEN[row]
        }
        else{
            return topicsPL[row]
        }
        
    }
}
