
import UIKit
import GoogleSignIn
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutBtnDidTapped(_ sender: Any){
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut()
            // Back to Login View COIntroller
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginRoot = storyBoard.instantiateViewController(withIdentifier: "login_root")
            self.present(loginRoot, animated: true, completion: nil)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
