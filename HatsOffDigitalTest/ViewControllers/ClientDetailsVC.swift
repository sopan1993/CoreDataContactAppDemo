//
//  ClientDetailsVC.swift
//  HatsOffDigitalTest
//
//  Created by Shirish Vispute on 10/05/19.
//  Copyright © 2019 Bitware Technologies. All rights reserved.
//

import UIKit
import CoreData

class ClientDetailsVC: UIViewController,UITextFieldDelegate {

    @IBOutlet var txtfClientName: UITextField!
    @IBOutlet weak var myNumericTextField: UITextField! {
        didSet { myNumericTextField?.addDoneCancelToolbar() }
    }
    
    @IBOutlet var txtfPhone: UITextField!
    
    var callback : ((Client) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtfPhone.delegate = self
        txtfClientName.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtfPhone || textField == self.txtfClientName {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func addClients(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Client", in: managedContext)!
        let newEntity = NSManagedObject(entity: entity, insertInto: managedContext) as! Client
        newEntity.name = txtfClientName.text!
        newEntity.phone = txtfPhone.text!
        newEntity.belogsTo = Constant.appDelegate.userPhone
        callback?(newEntity)
        do {
            
            try managedContext.save()
            self.txtfClientName.text = ""
            self.txtfPhone.text = ""
            self.navigationController?.popViewController(animated: true)
            
        } catch {
            print("Failed saving")
        }
        
    }
    
    
    @IBAction func btnAddDetailsClicked(_ sender: Any) {
        
        if txtfClientName.text == "" {
            
            AppUtility.showAlert(message: "Please enter person name.",vc: self,alertViewBackGrounColor: nil,textColor:"green")
            
        } else if txtfPhone.text == "" {
            
            AppUtility.showAlert(message: "Please enter person phone number.",vc: self,alertViewBackGrounColor: nil,textColor: "green")
            
        } else if !(txtfPhone.text!.isValidContact) {
            
            AppUtility.showAlert(message: "Phone number is not valid.",vc: self,alertViewBackGrounColor:nil,textColor:"green")
            
        } else {
            
            addClients()
        }
        
    }
    
    

}
