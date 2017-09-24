# Gemo

[![CI Status](http://img.shields.io/travis/gemgemo/Gemo.svg?style=flat)](https://travis-ci.org/gemgemo/Gemo)
[![Version](https://img.shields.io/cocoapods/v/Gemo.svg?style=flat)](http://cocoapods.org/pods/Gemo)
[![License](https://img.shields.io/cocoapods/l/Gemo.svg?style=flat)](http://cocoapods.org/pods/Gemo)
[![Platform](https://img.shields.io/cocoapods/p/Gemo.svg?style=flat)](http://cocoapods.org/pods/Gemo)
![Swift version](https://img.shields.io/badge/swift-4.0-orange.svg)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
swift 4
xcode 9

## Usage

```swift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Gemo.request(link: "https://quarkbackend.com/getfile/gemgemo/mony", method: .get)
            .response(Money.self) { (result) in
                switch (result) {
                    case .failure(let error):
                        print(error)

                    case .jsonString(let jsonString):
                        print(jsonString)

                    case .success(let object):
                        print("object:", object)
                }
            }

    }
}



struct Money: Codable {

    let isMyMoney: Bool

    private enum CodingKeys: String, CodingKey {
        case isMyMoney = "taked"
    }

}

```

## Installation

Gemo is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Gemo'
```

## Author

Gamal, gamalal3yk@gmail.com

## License

Gemo is available under the MIT license. See the LICENSE file for more info.

