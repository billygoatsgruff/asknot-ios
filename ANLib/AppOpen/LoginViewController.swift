import LUX
import PlaygroundVCHelpers
import TwitterKit
import LithoOperators

func loginViewController(_ vm: LUXLoginViewModel?) -> UIViewController {
    let vc = LoginViewController.makeFromXIB()
    vc.loginViewModel = vm
    vc.onViewDidLoad = optionalCast >?> loginViewLoaded
    return vc
}

class LoginViewController: LUXLoginViewController {
    func login(_ session: TWTRSession) {
        loginViewModel?.inputs.usernameChanged(username: session.authToken)
        loginViewModel?.inputs.passwordChanged(password: session.authTokenSecret)
        loginViewModel?.inputs.submitButtonPressed()
    }
}

func loginViewLoaded(loginVC: LoginViewController) {
    loginVC.spinner?.style = .large
    loginVC.view.backgroundColor = UIColor.primaryDark()

    let logInButton = TWTRLogInButton { (session, twitterError) in
        if let err = twitterError {
            print("Twitter Login Error: \(String.init(describing: err.localizedDescription))")
            return
        }
        if let unwrappedSession = session {
            loginVC.login(unwrappedSession)
        }
    }
    
    logInButton.center = loginVC.view.center
    loginVC.view.addSubview(logInButton)
}
