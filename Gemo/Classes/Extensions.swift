
import Foundation

// MARK: - Strings

public extension String {
    
    public static var empty: string {
        return ""
    }
    
    public var isLink: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+").evaluate(with: self)
    }
    
    public var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    /// use it with string numbers to convert it to english
    public func convert() -> string {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "EN")
        return formatter.number(from: self)?.stringValue ?? string.empty
    }
    
    // converts
    public var toData: Data {
        return data(using: .utf8, allowLossyConversion: false) ?? Data()
    }
    
    public var toInt: int {
        return NumberFormatter().number(from: self)?.intValue ?? .zero
    }
    
    public var toDouble: double {
        return NumberFormatter().number(from: self)?.doubleValue ?? .zero
    }
    
    /// converting base64 string to UIImage
    public var toImage: UIImage? {
        return UIImage(data: Data(base64Encoded: self, options: .ignoreUnknownCharacters) ?? Data())
    }
    
}


// MARK: - Number
public extension Number {
    
    internal static var zero: Number {
        return 0
    }
    
}


// MARK: - Errors

public extension NSError {
    
    public var toString: string {
        return string(describing: self)
    }
    
}



// MARK: - image caching
private let imageCache = NSCache<NSString,UIImage>()

public extension UIImageView {
    
    public func loadImage(from link: string,_ onComplete: ((_ isLoaded: Bool)-> ())? = nil)-> void {
        UIApplication.showIndicator(by: true)
        image = nil
        if (!link.isLink || link.isEmpty) {
            print("empty image link or invalid link")
            onComplete?(false)
            UIApplication.showIndicator(by: false)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: link as NSString) {
            image = cachedImage
            onComplete?(true)
            UIApplication.showIndicator(by: false)
            return
        }
        // download and cache image
        // download
        if let url = URL(string: link as string) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if (error != nil) {
                    onComplete?(false)
                    UIApplication.showIndicator(by: false)
                    return
                }
                if let imageData = data, let imageToCache = UIImage(data: imageData) {
                    DispatchQueue.main.async { [weak self] in
                        // cache image
                        imageCache.setObject(imageToCache, forKey: link as NSString)
                        self?.image = imageToCache
                        onComplete?(true)
                        UIApplication.showIndicator(by: false)
                    }
                } else {
                    onComplete?(false)
                    UIApplication.showIndicator(by: false)
                }
                }.resume()
        }
    }
    
    public func rounded(withBorder color: Color = Color.clear, borderWidth width: cgFloat = 0.0, cornerRadius radius: cgFloat)-> void {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    /// converting image file to string base 64
    public var toBase64: string? {
        return image?.toData(quality: 1.0).base64EncodedString(options: .lineLength64Characters)
    }
    
}

public enum ImageQuality: cgFloat {
    case heigh = 1.0, medium = 0.50, low = 0.25
}


// MARK: - UIImage

public extension UIImage {
    
    public func toData(quality: cgFloat = ImageQuality.medium.rawValue)-> Data {
        return UIImageJPEGRepresentation(self, quality) ?? Data()
    }
    
}


// MARK: - Application

public extension UIApplication {
    
    public class func showIndicator(by isOn: bool)-> void {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isOn
        }
    }
    
    /// run user interactions
    public class func playActions()-> void {
        if (UIApplication.shared.isIgnoringInteractionEvents) {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    /// stop user interactions
    public class func stopActions()-> void {
        if (!UIApplication.shared.isIgnoringInteractionEvents) {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    
}


// MARK: - Colors

public extension Color {
    
    public convenience init?(hex hash: string) {
        let r, g, b, a: CGFloat
        if (hash.hasPrefix("#")) {
            let start = hash.index(hash.startIndex, offsetBy: 1)
            let hexColor = String(hash[start...])
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            if (scanner.scanHexInt64(&hexNumber)) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        return nil
    }
    
    
    
}


// MARK: - UIView

public extension UIView {
    
    public func setShadow(with offset: CGSize, radius: CGFloat, opacity: CGFloat, color: Color)-> Void {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = Float(opacity)
    }
    
    public func setBorder(with width: cgFloat, and color: Color)-> void {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    public func setCorner(radius: cgFloat)-> void {
        layer.cornerRadius = radius
    }
    
}



// MARK: - Size

public extension Size {
    
    public init(right: cgFloat, top: cgFloat) {
        width = right
        height = top
    }
    
}


// MARK:- Fonts

public extension Font {
    
    public class func getFonts() -> void {
        Font.familyNames.forEach { (family) in
            print("--------------------------\(family)--------------------------")
            Font.fontNames(forFamilyName: family).forEach { (font) in
                print("font name is: ", font)
            }
        }
    }
    
}



// MARK: - Int extension

public extension int {
    
    public var toString: string {
        return string(describing: self)
    }
    
    public var toDouble: double {
        return double(self)
    }
    
    public var toCGFloat: cgFloat {
        return cgFloat(self)
    }
    
    public static var zero: Int {
        return Number.zero.intValue
    }
    
}

// MARK: - Double

public extension double {
    
    public var toString: string {
        return string(describing: self)
    }
    
    public static var zero: double {
        return Number.zero.doubleValue
    }
    
}


// MARK: - CGFloat

public extension cgFloat {
    
    public var toInt: int {
        return int(self)
    }
    
    public static var zero: cgFloat {
        return 0.0
    }
}






















































