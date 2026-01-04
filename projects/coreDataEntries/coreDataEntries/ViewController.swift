//
//  ViewController.swift
//  coreDataEntries
//
//  Created by kunguma-14252 on 21/11/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonAction(_ sender: Any) {
        self.createData()
        label.text = "created"
    }
    
    @IBAction func retriveData(_ sender: Any) {
        self.retriveData()
        label.text = "retrived"
    }
    
    @IBAction func deleteData(_ sender: Any) {
        self.deleteData()
        label.text = "Deleted"
    }
    
    func createData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let moc = appDelegate.persistentContainer.viewContext
        moc.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        for i in 1...10 {
            let user = User(context: moc)
            user.name = "Kunguma\(i)"
            user.mail = "Kunguma\(i)@gmail.com"
            user.pass = "Pass\(i)"
        }
        
        for i in 1...10 {
            let admin = Admin(context: moc)
            admin.name = "Kunguma\(i)"
            admin.empId = "Pt - \(i)"
        }
        do {
            try moc.save()
        } catch let error  {
            print("Kungu Error ",error)
        }
    }
    
    func retriveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let moc = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let results = try moc.fetch(fetchRequest)
            try results.forEach { result in
                let req = NSFetchRequest<Admin>(entityName: "Admin")
                req.predicate = NSPredicate(format: "name == %@", result.name!)
                let admin = try moc.fetch(req)
                print("User --- \(result.name!) -- \(result.pass!) -- \(result.mail!) -- \(admin[0].empId!)")

            }
            let admins = try moc.fetch(Admin.fetchRequest())
            admins.forEach { admin in
                print("Admin --- \(admin.name!) -- \(admin.empId!)")
            }
        }catch {
            print("Kungu Error")
        }
    }
    
    func deleteData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let moc = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "name = %@", "Kunguma1"), NSPredicate(format: "name = %@", "Kunguma10")])
        
        self.batchDelteData(fetchReq: fetchRequest, moc: moc)
        
        
//            guard let result = try moc.fetch(fetchRequest) as? [NSManagedObject] else { return }
//            let delete = result[0]
//            moc.delete(delete)
//            do {
//                try moc.save()
//            }catch {
//                print("Kungu Error - \(error)")
//            }
        
    }
    
    func batchDelteData(fetchReq: NSFetchRequest<NSFetchRequestResult>, moc: NSManagedObjectContext) {
        do {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchReq)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        guard let batchDeleteResult = try moc.execute(batchDeleteRequest) as? NSBatchDeleteResult,
              let deletedResultIDs = batchDeleteResult.result as? [NSManagedObjectID]
        else {
            return
        }
        let deletedObjects: [AnyHashable: Any] = [NSDeletedObjectsKey: deletedResultIDs]
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [moc]
        )
        }catch {
            print("Kungu Error")
        }
    }
}

