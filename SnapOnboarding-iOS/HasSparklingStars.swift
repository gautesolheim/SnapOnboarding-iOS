import UIKit

protocol HasSparklingStars: class {
    
    var sparklingStars: [UIImageView]? { get }
    
}

extension HasSparklingStars {
    
    func animateSparklingStarsWithCycleDuration(duration: NSTimeInterval) {
        guard let sparklingStars = sparklingStars else {
            return
        }
        
        for star in sparklingStars {
            let delay: NSTimeInterval = Double(arc4random_uniform(UInt32(duration) * 100)) * 0.01
            
            UIView.animateWithDuration(duration, delay: delay, options: [UIViewAnimationOptions.CurveEaseInOut], animations: {
                star.transform = CGAffineTransformMakeScale(1.5, 1.5)
                }, completion: { _ in
                    UIView.animateWithDuration(duration, delay: 0, options: [UIViewAnimationOptions.CurveEaseInOut], animations: {
                        star.transform = CGAffineTransformMakeScale(0.7, 0.7)
                        }, completion: { _ in
                            self.animateSparklingStarWithDuration(duration, star: star)
                    })
            })
        }
    }
    
    private func animateSparklingStarWithDuration(duration: NSTimeInterval, star: UIImageView) {
        UIView.animateWithDuration(duration, delay: 0, options: [UIViewAnimationOptions.CurveEaseInOut], animations: {
            star.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }, completion: { _ in
                UIView.animateWithDuration(duration, delay: 0, options: [UIViewAnimationOptions.CurveEaseInOut], animations: {
                    star.transform = CGAffineTransformMakeScale(0.7, 0.7)
                    }, completion: { _ in
                        self.animateSparklingStarWithDuration(duration, star: star)
                })
        })
    }
    
}