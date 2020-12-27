import UIKit

class SearchViewController: UIViewController {
    // UI elements
    @IBOutlet weak var SearchWords: UITextField!
    @IBOutlet weak var SearchStringButton: UIButton!
    @IBOutlet weak var OrLabel: UILabel!
    @IBOutlet weak var AlternativeTextLabel: UILabel!
    @IBOutlet weak var SearchTopicButton: UIButton!
    var isLangEN = true
    
    @IBOutlet weak var ColoredSearchView: UIView!
    @IBOutlet weak var LangSwitch: UISwitch!
    
    // function called when language switch state changed
    @objc func LanguageSwitchValueChanged(_ switchState: UISwitch) {
        if switchState.isOn {
            isLangEN = false
        } else {
            isLangEN = true
        }
        UpdateUILang()
    }
    
    // Go to news list view
    @IBAction func SearchButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "SearchToNewsList", sender: self)
    }
    
    // Go to picker view
    @IBAction func SearchByTopicButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "SearchToPick", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // handle language switch changes
        SetSwitchState(state: isLangEN)
        LangSwitch.addTarget(self, action: #selector(LanguageSwitchValueChanged(_:)), for: .valueChanged)
        
        // call function thats hide keyboard
        self.hideKeyboardWhenTappedAround()
        
        SearchWords.delegate = self
        
        // UI change
        ColoredSearchView.layer.cornerRadius = ColoredSearchView.frame.size.height / 4
        SearchStringButton.layer.cornerRadius = 10
        SearchTopicButton.layer.cornerRadius = 10
    }
    
    // function changing UI elements languages
    func UpdateUILang() {
        SearchWords.placeholder = isLangEN ? "News to search for" : "Wiadomości do wyszukania"
        SearchStringButton.setTitle(isLangEN ? "Search" : "Wyszukaj", for: .normal)
        OrLabel.text = isLangEN ? "Or" : "Lub"
        AlternativeTextLabel.text = isLangEN ? "Search latest headlines by topic" : "Przeszukaj newsy według tematu"
        SearchTopicButton.setTitle(isLangEN ? "Search by topic" : "Wyszukaj przez temat", for: .normal)
    }
    
    // function to set switch state from other views
    func SetSwitchState(state: Bool){
        LangSwitch.setOn(!state, animated: true)
        UpdateUILang()
    }
    
    // prepare other views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToNewsList"{
            let VC = segue.destination as! NewsListViewController
            VC.topic = SearchWords.text
            VC.vcString = true
            VC.lang = isLangEN ? "en" : "pl"
        }
        if segue.identifier == "SearchToPick"{
            let VC = segue.destination as! PickViewController
            VC.lang = isLangEN ? "en" : "pl"
        }
    }
}

// function to hide keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}

// when return key is pressed go to news list view
extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        self.performSegue(withIdentifier: "SearchToNewsList", sender: self)
        return true
    }
}
