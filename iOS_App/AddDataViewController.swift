
import UIKit
import CoreData

class AddDataViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNoTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var genderSegmnet: UISegmentedControl!
    @IBOutlet weak var button: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userData : Entity?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userData != nil {
            self.button.tag = 1
            self.button.setTitle("Update", for: .normal)
            self.nameTF.text = userData?.name
            self.emailTF.text = userData?.email
            self.phoneNoTF.text = userData?.phoneNo
            self.addressTF.text = userData?.address
            self.ageTF.text = userData?.age
            self.genderSegmnet.selectedSegmentIndex = userData!.gender == "Male" ? 0 : 1
        } else {
            self.button.tag = 0
            self.button.setTitle("Save", for: .normal)
        }
        
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender.tag == 1 {
            self.updateData()
        } else {
            self.saveUserData()
        }
    }
    
    func updateData() {
        if userData != nil {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
            request.predicate = NSPredicate(format: "id = %@", self.userData!.id! as CVarArg)
            
            do {
                let results = try self.context.fetch(request)
                let objectUpdate = results[0] as! NSManagedObject
                    
                objectUpdate.setValue(self.addressTF.text ?? "", forKey: "address")
                objectUpdate.setValue(self.ageTF.text ?? "", forKey: "age")
                objectUpdate.setValue(self.emailTF.text ?? "", forKey: "email")
                objectUpdate.setValue(self.genderSegmnet.selectedSegmentIndex == 0 ? "Male" : "Female", forKey: "gender")
                objectUpdate.setValue(self.nameTF.text ?? "", forKey: "name")
                objectUpdate.setValue(self.phoneNoTF.text ?? "", forKey: "phoneNo")
                objectUpdate.setValue(self.userData?.id , forKey: "id")
                
                do {
                    try self.context.save()
                    self.navigationController?.popViewController(animated: true)
                } catch let err {
                    print(err.localizedDescription)
                }
                    
            } catch let err {
                print(err.localizedDescription)
            }
            
        }
    }

    func saveUserData() {
        let newContext = Entity(context: self.context)
        newContext.name = self.nameTF.text ?? ""
        newContext.email = self.emailTF.text ?? ""
        newContext.phoneNo = self.phoneNoTF.text ?? ""
        newContext.address = self.addressTF.text ?? ""
        newContext.age = self.ageTF.text ?? ""
        newContext.gender = self.genderSegmnet.selectedSegmentIndex == 0 ? "Male" : "Female"
        newContext.id = UUID()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
