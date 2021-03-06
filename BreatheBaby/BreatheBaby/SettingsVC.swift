import UIKit

let BreatheInTimeKey = "Breathe in time"
let PauseTimeAfterBreathInKey = "Pause time after breath in"
let BreatheOutTimeKey = "Breathe out time"
let PauseTimeAfterBreathOutKey = "Pause time after breath out"

class SettingsVC: UIViewController {

	@IBOutlet weak var breatheInTimeLabel: UILabel!
	@IBOutlet weak var pauseAfterBreathInTimeLabel: UILabel!
	@IBOutlet weak var breatheOutTimeLabel: UILabel!
	@IBOutlet weak var pauseAfterBreathOutTimeLabel: UILabel!
	
	@IBOutlet weak var breatheInTimeSlider: UISlider!
	@IBOutlet weak var pauseAfterBreatheInTimeSlider: UISlider!
	@IBOutlet weak var breatheOutTimeSlider: UISlider!
	@IBOutlet weak var pauseAfterBreathOutTimeSlider: UISlider!
	
	var sliders: [UISlider] = []
	var labels: [UILabel] = []
	let userDefaultsKeys = [BreatheInTimeKey, PauseTimeAfterBreathInKey, BreatheOutTimeKey, PauseTimeAfterBreathOutKey]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		sliders = [breatheInTimeSlider, pauseAfterBreatheInTimeSlider, breatheOutTimeSlider, pauseAfterBreathOutTimeSlider]
		labels = [breatheInTimeLabel, pauseAfterBreathInTimeLabel, breatheOutTimeLabel, pauseAfterBreathOutTimeLabel]
		
		refreshInterface()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(_ animated: Bool) {
	}
	
	@IBAction func sliderValueChanged(_ sender: UISlider) {
		durationValueChanged(sender)
	}
	@IBAction func sliderTouchUpInside(_ sender: UISlider) {
		durationValueChanged(sender, snapSlider:true)
	}
	
	func durationValueChanged(_ slider: UISlider, snapSlider: Bool = false) {
		let newValue = Int(round(slider.value))
		let index = sliders.index(of: slider)
		labels[index!].text = labelTextForDuration(newValue)
		UserDefaults.standard.set(newValue, forKey:userDefaultsKeys[index!])
		
		if snapSlider {
			slider.value = Float(newValue)
		}
	}
	
	func refreshInterface() {
		for (index, defaultKey) in userDefaultsKeys.enumerated() {
			let value = UserDefaults.standard.integer(forKey: defaultKey)
			labels[index].text = labelTextForDuration(value)
			sliders[index].value = Float(value)
		}
	}
	
	func labelTextForDuration(_ duration: Int) -> String {
		return "\(duration) second" + (duration == 1 ? "" : "s")
	}
}
