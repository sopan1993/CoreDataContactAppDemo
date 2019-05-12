//
//  RegisterVC.swift
//  HatsOffDigitalTest
//
//  Created by Shirish Vispute on 10/05/19.
//  Copyright © 2019 Bitware Technologies. All rights reserved.
//

import UIKit
import CoreData


class RegisterVC: UIViewController,UITextFieldDelegate {

    
    @IBOutlet var txtfName: UITextField!
    @IBOutlet var txtfPhone: UITextField!
    @IBOutlet var txtfEmail: UITextField!
    @IBOutlet weak var myNumericTextField: UITextField! {
        didSet { myNumericTextField?.addDoneCancelToolbar() }
    }
    
    var callback : ((String) -> Void)?
    
    var phone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        txtfName.delegate = self
        txtfPhone.delegate = self
        txtfEmail.delegate = self
        txtfPhone.text = phone
        txtfPhone.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtfName || textField == self.txtfPhone || textField == self.txtfEmail{
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func registerUser(){
        
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
            let newEntity = NSManagedObject(entity: entity, insertInto: managedContext) as! User
            newEntity.name = txtfName.text!
            newEntity.phone = txtfPhone.text!
            newEntity.email = txtfEmail.text!
            callback?(txtfPhone.text!)
            do {
                
                try managedContext.save()
                self.txtfName.text = ""
                self.txtfPhone.text = ""
                self.txtfEmail.text = ""
                self.navigationController?.popViewController(animated: true)
                
            } catch {
                print("Failed saving")
            }
        
    }

    
    @IBAction func btnRegisterClicked(_ sender: Any) {
       
        if txtfName.text == "" {
            
            AppUtility.showAlert(message: "Please enter your name.",vc: self,alertViewBackGrounColor: nil,textColor:"green")
            
        } else if txtfEmail.text == "" {
            
            AppUtility.showAlert(message: "Please enter your email id.",vc: self,alertViewBackGrounColor: nil,textColor: "green")
            
        } else if !(AppUtility.isValidEmail(testStr: txtfEmail.text!)){
            
            AppUtility.showAlert(message: "Email is not valid.",vc: self,alertViewBackGrounColor: nil,textColor: "green")
        }
        
        else {
            
            registerUser()
        }
        
       
    }
    

}
