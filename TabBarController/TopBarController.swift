import UIKit

class TopBarController: UIViewController {
    let viewControllers: [UIViewController]
    
    var topBar: TopBar
    let startControllerNumber = 0

    convenience init(_ viewControllers: UIViewController...) {
        self.init(viewControllers: viewControllers)
    }

    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        var items: [TopBarItem] = []
        
        for controller in viewControllers {
            if let item = controller.topBarItem {
                items.append(item)
            }
        }
        
        topBar = TopBar(items)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewController(viewControllers[startControllerNumber])
    }
    
    private func loadViewController(_ controller: UIViewController) {
        self.addChild(controller)
        controller.willMove(toParent: self)
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        controller.didMove(toParent: self)
        view.addSubview(topBar)
        
        topBar.openController(number: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            
        let topBarMarginTop = 12
        let topBarSidePadding = 16
        let topBarY: Int = Int(view.safeAreaInsets.top) + topBarMarginTop
        var topBarW: Int = 0
        var topBarH: Int = 0
        
        switch UIDevice.current.model {
        case "iPad":
            let topBarButtonW = 70
            
            topBarW = topBarButtonW * 5 + topBarSidePadding * 2
            topBarH = topBarButtonW
        case "iPhone", "iPod":
            let minWidth = min(view.bounds.size.width, view.bounds.size.height)
            let topBarSideMargin = 24

            topBarW = Int(minWidth) - topBarSideMargin * 2
            topBarH = (topBarW - topBarSidePadding * 2) / 5
        default:
            assert(false, "Apple has a new ios device?")
        }
        
        topBar.frame = CGRect(x: 0, y: topBarY, width: topBarW, height: topBarH)
        topBar.center.x = view.center.x
    }
    
    @objc func didTap(_ button: TopBarButton) {
        if let nowOpen = topBar.nowOpen {
            if button.numberInBar != nowOpen {
                loadViewController(viewControllers[button.numberInBar])
                topBar.openController(number: button.numberInBar)
            }
        }
    }
}
