import UIKit

protocol HasSparklingStars: class {
    
    var sparklingStars: [UIImageView]? { get }
    
}

extension HasSparklingStars {
    
    func animateSparklingStarsWithCycleDuration(duration: NSTimeInterval) {
        guard let sparklingStars = sparklingStars else {
            return
        }
        
        let variation = duration < 1 ? 0 : 0.4
        
        for star in sparklingStars where star.layer.animationKeys() == nil {
            let delay: NSTimeInterval = Double(arc4random_uniform(UInt32(duration * 100))) / 100 // 0 ... duration
            let duration: NSTimeInterval = (duration - variation / 2) + Double(arc4random_uniform(UInt32(variation * 100))) / 100 // (duration - variation / 2) ... (duration + variation / 2)
            
            animateSparklingStarWithDuration(duration, delay: delay, star: star)
        }
    }

    func stopAnimatingSparklingStars() {
        sparklingStars?.forEach { $0.layer.removeAllAnimations() }
    }
    
    private func animateSparklingStarWithDuration(duration: NSTimeInterval, delay: NSTimeInterval, star: UIImageView) {
        UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseInOut, animations: {
            star.transform = CGAffineTransformMakeScale(1.5, 1.5)
        }, completion: { finished in
            guard finished else { return }
            
            UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseInOut, .Autoreverse, .Repeat], animations: {
                star.transform = CGAffineTransformMakeScale(0.7, 0.7)
            }, completion: nil)
            
        })
    }
    
}