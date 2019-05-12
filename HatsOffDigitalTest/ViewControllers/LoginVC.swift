//
//  LoginVC.swift
//  HatsOffDigitalTest
//
//  Created by Shirish Vispute on 10/05/19.
//  Copyright © 2019 Bitware Technologies. All rights reserved.
//

import UIKit
import CoreData


class LoginVC: UIViewController,UITextFieldDelegate {

    
    @IBOutlet var txtfPhone: UITextField!
    
    @IBOutlet weak var myNumericTextField: UITextField! {
        didSet { myNumericTextField?.addDoneCancelToolbar() }
    }
    
    var userArr = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtfPhone.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if  textField == self.txtfPhone{
        
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func fetchRegisteredUser() -> Bool{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            
            self.userArr = try managedContext.fetch(fetchRequest) as! [User]
            
            let arr = self.userArr.filter( { return $0.phone == self.txtfPhone.text! } )
            print(self.userArr.count)
            
            if arr.isEmpty
            {
                return false
            }
            else
            {
                Constant.appDelegate.userPhone = arr[0]
                print(arr[0].phone!)
                return true
            }
            

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        return false
    }
    
    
    @IBAction func btnLoginGignUpClicked(_ sender: Any) {
        if txtfPhone.text == ""{
            
            AppUtility.showAlert(message: "Please enter phone number.",vc:self,alertViewBackGrounColor:nil,textColor: "green")
            
        } else if !(txtfPhone.text!.isValidContact) {
    
            AppUtility.showAlert(message: "Please enter valid 10 digit mobile number.",vc: self,alertViewBackGrounColor:nil,textColor:"green")
    
       } else {
            
            if fetchRegisteredUser() {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
                self.navigationController?.pushViewController(vc!, animated: true)
                
            } else {
                
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
                vc!.phone = self.txtfPhone.text!
                vc!.callback = { phone in
                   
                    self.txtfPhone.text = phone
                }
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        
      
    }
    

}




