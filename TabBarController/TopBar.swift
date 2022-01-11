import UIKit

class TopBar: UIView {
    var topBarButtons: [TopBarButton]
    var nowOpen: Int?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ items: [TopBarItem]) {
        topBarButtons = []
        super.init(frame: .zero)
        self.becomeFirstResponder()
        
        backgroundColor = .white
        alpha = 0.4
        
        for (i, item) in items.enumerated() {
            let curButton = TopBarButton(item.icon, item.title, i)
            self.addSubview(curButton)
            topBarButtons.append(curButton)
        }
    }
    
    func openController(number: Int) {
        if let nowOpen = nowOpen {
            topBarButtons[nowOpen].close()
        }
        topBarButtons[number].open()
        nowOpen = number
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.height / 2
        
        let siteMargin = 16
        
        let buttonH = Int(self.frame.size.height)
        let buttonW = buttonH
        let buttonY = 0
        
        for (i, curButton) in topBarButtons.enumerated() {
            let buttonX = siteMargin + i * Int(buttonW)
            
            curButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
}
