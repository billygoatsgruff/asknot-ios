import LUX
import PlaygroundVCHelpers

func splashViewController(_ vm: LUXSplashViewModel?) -> UIViewController {
    let vc = SplashViewController.makeFromXIB()
    vc.viewModel = vm
    vc.onViewDidLoad = { $0.view.backgroundColor = UIColor.primaryDark() }
    return vc
}

class SplashViewController: LUXSplashViewController {}
