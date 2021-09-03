
import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var contactListTableViewController: UITableView!
    var allData = [Entity]() {
        didSet {
            DispatchQueue.main.async {
                self.contactListTableViewController.reloadData()
            }
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactListTableViewController.register(UINib(nibName: "ContactListTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactListTableViewCell")
        contactListTableViewController.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchDataFromCoreData()
    }
    
    func fetchDataFromCoreData() {
        let request : NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            self.allData = try self.context.fetch(request)
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : ContactListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ContactListTableViewCell") as? ContactListTableViewCell {
            
            if allData.count > indexPath.row {
                let data = self.allData[indexPath.row]
                cell.configData(entity: data)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.allData.count > indexPath.row {
            let data = self.allData[indexPath.row]
            
            if let nav = self.storyboard?.instantiateViewController(withIdentifier: "AddDataViewController") as? AddDataViewController {
                nav.userData = data
                self.navigationController?.pushViewController(nav, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if self.allData.count > indexPath.row {
            let data = self.allData[indexPath.row]
            self.deleteData(userData: data)
        }
    }
    
    func deleteData(userData:Entity) {
        if userData.id != nil {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
            request.predicate = NSPredicate(format: "id = %@", userData.id! as CVarArg)
            
            do {
                let results = try self.context.fetch(request)
                let objectDelete = results[0] as! NSManagedObject
                self.context.delete(objectDelete)
                do {
                    try self.context.save()
                    self.fetchDataFromCoreData()
                    self.navigationController?.popViewController(animated: true)
                    
                } catch let err {
                    print(err.localizedDescription)
                }
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
}

