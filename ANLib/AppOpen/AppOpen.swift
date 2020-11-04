import LUX
import Prelude
import LithoOperators
import FunNet
import Combine
import Slippers

open class AppOpenFlowController: LUXAppOpenFlowController {
    var cancelBag = Set<AnyCancellable>()
    
    public override init() {
        super.init()
        LUXSessionManager.primarySession = LUXUserDefaultsSession(host: Current.serverConfig.host, authHeaderKey: "X-Api-Key" )
        splashViewModel = LUXSplashViewModel(minimumVisibleTime: 1.0, otherTasks: nil)
        setupLogin()
    }

    open override func initialVC() -> UIViewController? {
        let splashVC = splashViewController(splashViewModel)
        splashVC.modalTransitionStyle = .crossDissolve

        splashViewModel?.outputs.advanceAuthedPublisher.sink { _ in
            let vc = AuthedFlowCoordinator().initialVC()
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle = .crossDissolve
            vc ?> splashVC.presentAnimated
        }.store(in: &cancelBag)
        splashViewModel?.outputs.advanceUnauthedPublisher.sink { [unowned self] _ in
            splashVC.present(self.loginVC(), animated: true, completion: nil)
        }.store(in: &cancelBag)

        return splashVC
    }

    open func loginVC() -> UIViewController {
        let loginVC = loginViewController(loginViewModel)
        loginVC.modalTransitionStyle = .crossDissolve
        loginVC.modalPresentationStyle = .fullScreen
        
        loginViewModel?.advanceAuthedPublisher.sink { _ in
            let vc = AuthedFlowCoordinator().initialVC()
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle = .crossDissolve
            vc ?> loginVC.presentAnimated
        }.store(in: &cancelBag)
        loginViewModel?.credentialLoginCall?.responder?.$serverError.sink { [weak loginVC] (error) in
            if let e = error {
                loginVC?.show(VerboseLoginErrorHandler().alert(for: e), sender: loginVC)
            }
        }.store(in: &cancelBag)

        return loginVC
    }

    func setupLogin() {
        let call = netCall(from: sessionsPostEndpoint())
        loginViewModel = LUXLoginViewModel(credsCall: call, loginModelToJson: AuthModel.init) { data in
            let loginData = JsonProvider.decode(User.self, from: data)
            if let authToken = loginData?.apiKey {
                let hostName = Current.serverConfig.host
                let session = LUXUserDefaultsSession(host: hostName, authHeaderKey: "X-Api-Key" )
                session.setAuthValue(authString: authToken)
                LUXSessionManager.primarySession = session
                return true
            }
            return false
        }
    }
}
