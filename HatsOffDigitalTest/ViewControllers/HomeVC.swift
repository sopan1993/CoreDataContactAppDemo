//
//  HomeVC.swift
//  HatsOffDigitalTest
//
//  Created by Shirish Vispute on 10/05/19.
//  Copyright © 2019 Bitware Technologies. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {

    
    @IBOutlet var tblClientList: UITableView!
    
    var clientArr = [Client]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblClientList.delegate = self
        tblClientList.dataSource = self
        tblClientList.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tblClientList.tableFooterView = UIView()
        getAllClientsAddedByUser()
        // Do any additional setup after loading the view.
    }
  
    func getAllClientsAddedByUser(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Client")
        
        do {
            
            self.clientArr = try managedContext.fetch(fetchRequest) as! [Client]
        
            self.clientArr = []
            self.clientArr = Constant.appDelegate.userPhone!.has?.allObjects as! [Client]
            
            if self.clientArr.isEmpty{
                
                self.tblClientList.isHidden = true
                
            } else {
                
                self.tblClientList.isHidden = false
            }
            
            DispatchQueue.main.async {
                 self.tblClientList.reloadData()
            }
           
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
    }
    
    @IBAction func btnGoToAddClientVCClicked(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ClientDetailsVC") as? ClientDetailsVC
        vc!.callback = { objClient in
            
            self.getAllClientsAddedByUser()

        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension HomeVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.clientArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let temp = self.clientArr[indexPath.row]
        cell.textLabel?.text = temp.name
        cell.detailTextLabel?.text = temp.phone
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let temp = self.clientArr[indexPath.row]
            context.delete(temp)
            do {
                
                try context.save()
                
            } catch {
                
                print("Failed saving")
            }
            self.clientArr.remove(at: indexPath.row)
            tblClientList.deleteRows(at: [indexPath], with: .fade)
            tblClientList.reloadData()
        }
        if editingStyle == .insert{
            
        }
    }
    
}
