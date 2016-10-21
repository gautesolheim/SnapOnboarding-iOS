import UIKit

protocol HasSparklingStars: class {
    
    var sparklingStars: [UIImageView]? { get }
    
}

extension HasSparklingStars {
    
    func animateSparklingStarsWithCycleDuration(_ duration: TimeInterval) {
        guard let sparklingStars = sparklingStars else {
            return
        }
        
        let variation = duration < 1 ? 0 : 0.4
        
        for star in sparklingStars where star.layer.animationKeys() == nil {
            let delay: TimeInterval = Double(arc4random_uniform(UInt32(duration * 100))) / 100 // 0 ... duration
            let duration: TimeInterval = (duration - variation / 2) + Double(arc4random_uniform(UInt32(variation * 100))) / 100 // (duration - variation / 2) ... (duration + variation / 2)
            
            animateSparklingStarWithDuration(duration, delay: delay, star: star)
        }
    }

    func stopAnimatingSparklingStars() {
        sparklingStars?.forEach { $0.layer.removeAllAnimations() }
    }
    
    fileprivate func animateSparklingStarWithDuration(_ duration: TimeInterval, delay: TimeInterval, star: UIImageView) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions(), animations: {
            star.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { finished in
            guard finished else { return }
            
            UIView.animate(withDuration: duration, delay: 0, options: [.autoreverse, .repeat], animations: {
                star.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }, completion: nil)
            
        })
    }
    
}
