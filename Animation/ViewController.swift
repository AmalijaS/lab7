import UIKit

class ViewController: UIViewController {

    // 1. Создаем анимируемый объект
    let animatedView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 50, y: 150, width: 100, height: 100)
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        return view
    }()

    let startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Запустить анимацию", for: .normal)
        button.frame = CGRect(x: 80, y: 500, width: 230, height: 50)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let nextScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Кастомный переход", for: .normal)
        button.frame = CGRect(x: 80, y: 570, width: 230, height: 50)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var isAnimating = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(animatedView)
        view.addSubview(startStopButton)
        view.addSubview(nextScreenButton)
        
        startStopButton.addTarget(self, action: #selector(toggleAnimation), for: .touchUpInside)
        nextScreenButton.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)
    }
    
    @objc func toggleAnimation() {
        if isAnimating {
            stopAnimation()
        } else {
            startAnimation()
        }
    }
    
    func startAnimation() {
        isAnimating = true
        startStopButton.setTitle("Остановить анимацию", for: .normal)
        
        // 1. UIView-анимация движения и изменения фона
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.animatedView.center = CGPoint(x: self.view.center.x, y: 300)
            self.animatedView.backgroundColor = .systemRed
        }, completion: nil)
        
        // 2. Core Animation: вращение
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.5
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        animatedView.layer.add(rotation, forKey: "rotationAnimation")
        
        // 3. Core Animation: масштабирование
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue = NSNumber(value: 1.5)
        scale.duration = 1.0
        scale.autoreverses = true
        scale.repeatCount = Float.infinity
        animatedView.layer.add(scale, forKey: "scaleAnimation")
    }
    
    func stopAnimation() {
        isAnimating = false
        startStopButton.setTitle("Запустить анимацию", for: .normal)
        
        // Удаляем все анимации слоя
        animatedView.layer.removeAllAnimations()
        // Сбрасываем изменения
        UIView.animate(withDuration: 0.3) {
            self.animatedView.center = CGPoint(x: 100, y: 200)
            self.animatedView.backgroundColor = .systemBlue
        }
    }
    
    @objc func goToNextScreen() {
        let detailVC = DetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        // Настраиваем делегат для кастомного перехода
        detailVC.transitioningDelegate = self
        present(detailVC, animated: true, completion: nil)
    }
}

// Второй экран, на который переходим с анимацией
class DetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        
        // Кнопка для закрытия экрана
        let dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Закрыть", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.backgroundColor = .systemRed
        dismissButton.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        dismissButton.layer.cornerRadius = 10
        dismissButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        view.addSubview(dismissButton)
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
}

// Расширение для поддержки кастомного перехода
extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
}

// Класс аниматора для перехода
class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        toView.alpha = 0.0
        toView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, animations: {
            toView.alpha = 1.0
            toView.transform = CGAffineTransform.identity
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}
