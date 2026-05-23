import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создаем контейнер с помощью CALayer
        let squareView = UIView(frame: CGRect(x: 60, y: 150, width: 300, height: 300))
        
        // Фон для контейнера
        squareView.backgroundColor = .clear
        
        // Скругление углов
        squareView.layer.cornerRadius = 20.0
        
        // Тень
        squareView.layer.shadowColor = UIColor.black.cgColor
        squareView.layer.shadowOpacity = 0.8
        squareView.layer.shadowOffset = CGSize(width: 10, height: 10)
        squareView.layer.shadowRadius = 10
        
        // Добавляем градиент
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = squareView.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 20.0
        
        squareView.layer.addSublayer(gradientLayer)
        
        // Добавляем контейнер на основное view
        self.view.addSubview(squareView)
    }
}
