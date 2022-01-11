import UIKit

class TopBarButton: UIControl {
    var blurView: UIVisualEffectView?
    
    var image: UIImageView
    let label: UILabel
    let numberInBar: Int
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ image: UIImage, _ title: String, _ number: Int) {
        numberInBar = number
        
        label = UILabel()
        label.text = title
        label.font = UIFont(name: "SFProText-Medium", size: 12)
        label.textColor = .black
        self.image = UIImageView(image: image)
        self.image.tintColor = .black
        
        super.init(frame: .zero)
        
        self.addSubview(label)
        self.addSubview(self.image)
        
        clipsToBounds = true
                
        self.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        let labelMarginBottom = 8
        let labelHeight = 12
        
        label.textAlignment = NSTextAlignment.center
        label.frame = CGRect(x: 0,
                             y: Int(self.bounds.maxY) - labelHeight - labelMarginBottom,
                             width: Int(self.bounds.width),
                             height: labelHeight)
        
        image.center = CGPoint(x: Int(self.bounds.midX),
                               y: (Int(self.bounds.height) - labelHeight - labelMarginBottom) / 2)
        
        layer.cornerRadius = frame.height / 2
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.height / 2
        
        let isInside = sqrt(Double(sqr(point.x - center.x) + sqr(point.y - center.y))) <= Double(radius)
        return isInside
    }
    
    private func sqr<T:Numeric>(_ n: T) -> T {
        return n * n
    }
    
    func open() {
        backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView!.translatesAutoresizingMaskIntoConstraints = false
        blurView!.alpha = 0.3
        self.insertSubview(blurView!, at: .zero)
        
        NSLayoutConstraint.activate ([
          blurView!.heightAnchor.constraint (equalTo: self.heightAnchor),
          blurView!.widthAnchor.constraint (equalTo: self.widthAnchor),
          ])
    }
    
    func close() {
        blurView?.removeFromSuperview()
    }
    
    @objc func buttonDidTap(_ button: TopBarButton) {
        UIApplication.shared.sendAction(#selector(TopBarController.didTap), to: nil, from: self, for: nil)
    }
}

