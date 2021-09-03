
import UIKit

class ContactListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhoneNo: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var userAge: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 5
        mainView.layer.masksToBounds = true
        mainView.layer.borderColor = UIColor.systemGray.cgColor
        mainView.layer.borderWidth = 2
        stackView.backgroundColor = UIColor.systemGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(entity:Entity) {
        self.userName.text = entity.name
        self.userEmail.text = entity.email
        self.userPhoneNo.text = entity.phoneNo
        self.userGender.text = entity.gender
        self.userAddress.text = entity.address
        self.userAge.text = entity.age
    }
}
