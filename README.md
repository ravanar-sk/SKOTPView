# SKOTPView
A fully customizable OTP view for iOS platform. 

Use the provided two custom modes, or create your own and bend it to your will.

## Preview
![Simulator Screen Shot - iPhone 11 - 2021-05-13 at 21 15 33](https://user-images.githubusercontent.com/15936624/118153401-7e495900-b433-11eb-858f-3b9452b2f970.png)
![Simulator Screen Recording - iPhone 11 - 2021-05-13 at 21 14 48](https://user-images.githubusercontent.com/15936624/118153641-c0729a80-b433-11eb-9a9a-72ff0aa4fc87.gif)
![Simulator Screen Recording - iPhone 11 - 2021-05-13 at 21 15 27](https://user-images.githubusercontent.com/15936624/118153668-c6687b80-b433-11eb-8367-ec09c557a07c.gif)





## Installation

### CocoaPods

Add the following line to your Podfile:

```ruby
pod 'SKOTPView'
```

Then run the following in the same directory as your Podfile:
```ruby
pod install
```

## Usage

### Code

```swift
import SKOTPView                                                // IMPORTANT 

class ViewController: UIViewController {

    @IBOutlet var viewOTP: SKOTPView!                           // IMPORTANT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewOTP.numberOfDigits = 6                              // IMPORTANT
        viewOTP.reloadData()                                    // IMPORTANT
        // viewOTP.delegate = self           // Storyboard connection or code 
    }
 
 }
 

 extension ViewController: SKOTPViewDelegate {
     func viewForIndex(_ index: Int) -> OTPItemView {
         
         return SKOTPItemCircle(frame: .zero) // Circle or Curved       // IMPORTANT
         
 // or
         
 //        return SKOTPItemSquare(frame: .zero) // Square or Rectange
     }
     
     func onCodeChange(_ code: String) {
         // code change action
     }
     
     func onCodeComplete(_ code: String) {
         // code complete action
         // Indicated code all code entered
         // Use the value here to call any other API with the enterd code.
     }
 }
 
 ```

