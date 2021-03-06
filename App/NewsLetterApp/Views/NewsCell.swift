import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var SummaryLabel: UILabel!
    @IBOutlet weak var SourceLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        MainView.layer.cornerRadius = MainView.frame.size.height / 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
