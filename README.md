# SKOTPView
A fully customizable OTP view for iOS platform. 

Use the provided two custom modes, or create your own and bend it to your will.

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

