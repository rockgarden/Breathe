import UIKit

class TrainVC: UIViewController {
	@IBOutlet weak var breathBar: UIView!
	@IBOutlet weak var borderBar: UIView!
	
	let breathBarPadding: CGFloat = 20
	
	// There seems to be no IB attributes for these
	let borderBarWidth: CGFloat = 10
	let borderBarColor = UIColor.blue.cgColor
	let barCornerRadius: CGFloat = 5
	
	var fullBreathBarFrame: CGRect = CGRect.zero
	var emptyBreathBarFrame: CGRect = CGRect.zero

	override func viewDidLoad() {
		super.viewDidLoad()
		UserDefaults.standard.register(defaults: [BreatheInTimeKey:3,
																PauseTimeAfterBreathInKey:1,
																BreatheOutTimeKey: 4,
																PauseTimeAfterBreathOutKey: 1])
		
		// setup the attributes of the bars
		borderBar.backgroundColor = UIColor.white
		borderBar.layer.borderColor = borderBarColor
		borderBar.layer.borderWidth = borderBarWidth
		borderBar.layer.cornerRadius = barCornerRadius
		breathBar.layer.cornerRadius = barCornerRadius
		
		NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
	}
	
	func appDidBecomeActive() {
		startBreathingAnimation()
	}
	
	func appDidEnterBackground() {
		stopBreathingAnimation()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let breathBarWidth = borderBar.frame.size.width - 2 * breathBarPadding
		fullBreathBarFrame = CGRect(x: breathBarPadding,
										y: breathBarPadding,
										width: breathBarWidth,
										height: borderBar.frame.size.height - 2 * breathBarPadding)
		emptyBreathBarFrame = CGRect(x: breathBarPadding,
										 y: borderBar.frame.size.height - breathBarPadding,
										 width: breathBarWidth,
										 height: 0)
		startBreathingAnimation()
	}
	
	func startBreathingAnimation() {
		stopBreathingAnimation()	// Breath bar begins from the bottom
		breathBar.isHidden = false
		expand(0)					// Initial expansion starts immediately
	}
	
	func stopBreathingAnimation() {
		breathBar.layer.removeAllAnimations()
		breathBar.frame = emptyBreathBarFrame
	}
	
	func collapse(_ delay: TimeInterval) {
		UIView.animate(withDuration: userDefaultForTime(BreatheOutTimeKey), delay: delay, options: .curveLinear, animations: {
			self.breathBar.frame = self.emptyBreathBarFrame
			
			}, completion: { finished in
				if (finished) {
					self.expand(self.userDefaultForTime(PauseTimeAfterBreathOutKey))
				} else {
					self.stopBreathingAnimation()
				}
		})
	}
	
	func expand(_ delay: TimeInterval) {
		UIView.animate(withDuration: userDefaultForTime(BreatheInTimeKey), delay: delay, options: .curveLinear, animations: {
			self.breathBar.frame = self.fullBreathBarFrame
			
			}, completion: { finished in
				if (finished) {
					self.collapse(self.userDefaultForTime(PauseTimeAfterBreathInKey))
				} else {
					self.stopBreathingAnimation()
				}
		})
	}
	
	func userDefaultForTime(_ userDefaultsKey: String) -> Double {
		return Double(UserDefaults.standard.integer(forKey: userDefaultsKey))
	}
}

