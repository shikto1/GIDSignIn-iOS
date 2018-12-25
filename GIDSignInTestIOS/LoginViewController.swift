
import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{
    
    var dbRef: DatabaseReference?
    
    @IBOutlet weak var emailT: UITextField!
    @IBOutlet weak var passwordT: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
    }

    @IBAction func loginButtonDidTapped(_ sender: Any){
        let email = emailT.text
        let password = passwordT.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
            if let error = error{
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .userNotFound:
                        print("/////////////////// USER NOT FOUND")
                    case .userDisabled:
                        print("//////////////////////////USE DISABLED")
                    case .invalidEmail:
                        print("/////////////////////INVALID EMAIL>>>>>>>>>>>>>>")
                    case .wrongPassword:
                        print("/////////////////////WRONG PASSWORD>>>>>>")
                    default:
                        print("Create User Error: \(error)")
                    }
                }
                print(error.localizedDescription)
                return
            }else{
                self.gotoHome()
            }
        }
    }
    
    @IBAction func loginWithGmailButtonDidTapped(_ sender: Any){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authresult, error) in
            if error == nil{
                let userID = authresult?.user.uid
                let userEmail = authresult?.user.email
                let displayName = authresult?.user.displayName
                self.dbRef = Database.database().reference().child("Walletmix Pay").child("users").child(userID!)
                self.dbRef?.observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
                    if snapShot.exists(){
                        self.gotoHome()
                    }else{
                        let data = ["name": displayName,
                                    "email": userEmail,
                                    "phoneNumber": ""]
                        self.dbRef?.setValue(data)
                        self.gotoHome()
                    }
                })
                
            }
        }
    }
    
    func gotoHome(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "home_root")
        present(viewController, animated: true, completion: nil)
    }
}
