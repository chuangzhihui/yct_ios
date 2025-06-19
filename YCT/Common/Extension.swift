//
//  Extension.swift
//  YCT
//
//  Created by Fenris on 7/19/24.
//

import Foundation
import UIKit
import AVFoundation
import Photos
extension String
{
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
extension UIView {
    func hide(){
        self.isHidden = true
    }
    func show(){
        self.isHidden = false
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.cornerRadius = 10
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func rotateView() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
   
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel()
        toastLabel.textColor = .white
        toastLabel.font = UIFont.boldSystemFont(ofSize: 16)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 4
        toastLabel.clipsToBounds = true
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(toastLabel)
        
        // Constraints for toast label
        toastLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toastLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant:15).isActive = true
        toastLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20).isActive = true
        toastLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -20).isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseIn, animations: {
                toastLabel.alpha = 0.0
            }) { (_) in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
import Foundation
import UIKit

@objc public protocol GrowingTextViewDelegate: UITextViewDelegate {
    @objc optional func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat)
}

@IBDesignable @objc
open class GrowingTextView: UITextView {
    override open var text: String! {
        didSet { setNeedsDisplay() }
    }
    private var heightConstraint: NSLayoutConstraint?
    
    // Maximum length of text. 0 means no limit.
    @IBInspectable open var maxLength: Int = 0
    
    // Trim white space and newline characters when end editing. Default is true
    @IBInspectable open var trimWhiteSpaceWhenEndEditing: Bool = true
    
    // Customization
    @IBInspectable open var minHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }
    @IBInspectable open var maxHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }
    @IBInspectable open var placeholder: String? {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable open var placeholderColor: UIColor = UIColor(white: 0.8, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable open var attributedPlaceholder: NSAttributedString? {
        didSet { setNeedsDisplay() }
    }
    
    // Initialize
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentMode = .redraw
        associateConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }
    
    private func associateConstraints() {
        // iterate through all text view's constraints and identify
        // height,from: https://github.com/legranddamien/MBAutoGrowingTextView
        for constraint in constraints {
            if (constraint.firstAttribute == .height) {
                if (constraint.relation == .equal) {
                    heightConstraint = constraint;
                }
            }
        }
    }
    
    // Calculate and adjust textview's height
    private var oldText: String = ""
    private var oldSize: CGSize = .zero
    
    private func forceLayoutSubviews() {
        oldSize = .zero
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private var shouldScrollAfterHeightChanged = false
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if text == oldText && bounds.size == oldSize { return }
        oldText = text
        oldSize = bounds.size
        
        let size = sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height
        
        // Constrain minimum height
        height = minHeight > 0 ? max(height, minHeight) : height
        
        // Constrain maximum height
        height = maxHeight > 0 ? min(height, maxHeight) : height
        
        // Add height constraint if it is not found
        if (heightConstraint == nil) {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
            addConstraint(heightConstraint!)
        }
        
        // Update height constraint if needed
        if height != heightConstraint!.constant {
            shouldScrollAfterHeightChanged = true
            heightConstraint!.constant = height
            if let delegate = delegate as? GrowingTextViewDelegate {
                delegate.textViewDidChangeHeight?(self, height: height)
            }
        } else if shouldScrollAfterHeightChanged {
            shouldScrollAfterHeightChanged = false
            scrollToCorrectPosition()
        }
    }
    
    private func scrollToCorrectPosition() {
        if self.isFirstResponder {
            self.scrollRangeToVisible(NSMakeRange(-1, 0)) // Scroll to bottom
        } else {
            self.scrollRangeToVisible(NSMakeRange(0, 0)) // Scroll to top
        }
    }
    
    // Show placeholder if needed
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if text.isEmpty {
            let xValue = textContainerInset.left + textContainer.lineFragmentPadding
            let yValue = textContainerInset.top
            let width = rect.size.width - xValue - textContainerInset.right
            let height = rect.size.height - yValue - textContainerInset.bottom
            let placeholderRect = CGRect(x: xValue, y: yValue, width: width, height: height)
            
            if let attributedPlaceholder = attributedPlaceholder {
                // Prefer to use attributedPlaceholder
                attributedPlaceholder.draw(in: placeholderRect)
            } else if let placeholder = placeholder {
                // Otherwise user placeholder and inherit `text` attributes
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = textAlignment
                var attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: placeholderColor,
                    .paragraphStyle: paragraphStyle
                ]
                if let font = font {
                    attributes[.font] = font
                }
                
                placeholder.draw(in: placeholderRect, withAttributes: attributes)
            }
        }
    }
    
    // Trim white space and new line characters when end editing.
    @objc func textDidEndEditing(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            if trimWhiteSpaceWhenEndEditing {
                text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                setNeedsDisplay()
            }
            scrollToCorrectPosition()
        }
    }
    
    // Limit the length of text
    @objc func textDidChange(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            if maxLength > 0 && text.count > maxLength {
                let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                text = String(text[..<endIndex])
                undoManager?.removeAllActions()
            }
            setNeedsDisplay()
        }
    }
}
extension UIView {

    func applyShadowWithCornerRadius(color:UIColor, opacity:Float, radius: CGFloat, edge:AIEdge, shadowSpace:CGFloat)    {

        var sizeOffset:CGSize = CGSize.zero
        switch edge {
        case .Top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .Left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .Bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .Right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)


        case .Top_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .Top_Right:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .Bottom_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .Bottom_Right:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)


        case .All:
            sizeOffset = CGSize(width: 0, height: 0)
        case .None:
            sizeOffset = CGSize.zero
        }

        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true;

        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false

        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }
}

enum AIEdge:Int {
    case
    Top,
    Left,
    Bottom,
    Right,
    Top_Left,
    Top_Right,
    Bottom_Left,
    Bottom_Right,
    All,
    None
}


extension Date {
    
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    var earlierThisWeek: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    }
    
    var thisMonth: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var thisYear: Int {
        return Calendar.current.component(.year,  from: self)
    }
    
   
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func stringFromDateWithOnlyTime() -> String{
        let formate = DateFormatter()
        formate.dateFormat = "hh:mm a"
        formate.timeZone = TimeZone.autoupdatingCurrent
        return formate.string(from:self)
    }
    
    func stringDateWithTime() -> String{
        let formate = DateFormatter()
        formate.dateFormat = "dd MMM yyyy, hh:mm a"
        formate.timeZone = TimeZone.autoupdatingCurrent
        return formate.string(from:self)
    }
    
    func stringFromDateWithTime() -> String{
        let formate = ISO8601DateFormatter()
        formate.timeZone = TimeZone.autoupdatingCurrent
        formate.formatOptions = [.withFullDate,.withFullTime,.withColonSeparatorInTime,.withTimeZone,.withColonSeparatorInTimeZone]
        return formate.string(from:self)
    }
    
    func toDateString(format: String = "MMMM dd, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toDateStringMonthShort(format: String = "MMM dd, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toDateMonthThreeCharString(format: String = "MMM dd, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func DateToString() -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        dateFormater.timeZone = TimeZone.autoupdatingCurrent
        let dateString = dateFormater.string(from: self)
        
        return dateString
    }
    
    func DateToString(formate:String = "YYYY-MM-dd") -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = formate
        dateFormater.timeZone = TimeZone.autoupdatingCurrent
        let dateString = dateFormater.string(from: self)
        
        return dateString
    }
    
    func DateAndTimeToString() -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        dateFormater.timeZone = TimeZone.autoupdatingCurrent
        let dateString = dateFormater.string(from: self)
        
        return dateString
    }
    
    func toStringFromDate() -> String{
        let formate = DateFormatter()
        formate.dateFormat = "MMM dd, yyyy"
        formate.timeZone = .current
        return formate.string(from:self)
    }
    
    func toTimeStringWithZone() -> String{
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .medium
        dateformatter.dateStyle = .none
        let dateStr = dateformatter.string(from: Date())
        
        let formate = ISO8601DateFormatter()
        
        
        formate.formatOptions = [.withTime,.withTimeZone,.withColonSeparatorInTimeZone]
        print("String Date: \(formate.string(from:dateformatter.date(from: dateStr)!))")
        return formate.string(from:dateformatter.date(from: dateStr)!)
        
    }
    
    func stringFromDate() -> String{
        
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .none
        dateformatter.dateStyle = .medium
        let dateStr = dateformatter.string(from: self)
        
        let formate = ISO8601DateFormatter()
        formate.timeZone = TimeZone.autoupdatingCurrent
        formate.formatOptions = [.withFullDate,.withTime,.withTimeZone,.withColonSeparatorInTime,.withColonSeparatorInTimeZone]
        print("String Date: \(formate.string(from:dateformatter.date(from: dateStr)!))")
        return formate.string(from:dateformatter.date(from: dateStr)!)
    }
    
    func formatDateForChat() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: self)
        }
    }
}




public protocol ImagePickerDelegate: AnyObject {
    func imageDidSelect(image: UIImage?,imageUrl:URL?,imageExtension:String,imageName:String)
}

open class ImagePicker: NSObject, UINavigationControllerDelegate {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.sourceType = .savedPhotosAlbum
//        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if type == .camera && !(self.checkCameraAccess())
            {
                
            }
            else if type == .photoLibrary && !(self.checkPhotoLibraryPermission())
            {
                
            }
            else
            {
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
            }
        }
    }
    
    public func presentCameraOnly() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        if !(self.checkCameraAccess())
        {
            
        }
        else
        {
            self.pickerController.sourceType = .camera
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func checkCameraAccess() -> Bool{
        var isProceed = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            self.presentCameraSettings(message: "Camera access is denied")
            isProceed = false
        case .restricted:
            print("Restricted, device owner must approve")
            isProceed = false
        case .authorized:
            print("Authorized, proceed")
            isProceed = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    isProceed = true
                } else {
                    print("Permission denied")
                    isProceed = false
                }
            }
        @unknown default:
            fatalError()
        }
        return isProceed
    }
    
    func checkPhotoLibraryPermission() -> Bool{
        var isProceed = false
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                isProceed = true
                break
            //handle authorized status
            case .denied, .restricted :
                isProceed = false
                self.presentCameraSettings(message: "Photo library access is denied")
                break
            //handle denied status
            case .notDetermined:
                // ask for permissions
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        isProceed = true
                        break
                    // as above
                    case .denied, .restricted:
                        isProceed = false
                        self.presentCameraSettings(message: "Photo library access is denied")
                        break
                    // as above
                    case .notDetermined:
                        isProceed = false
                        break
                    // won't happen but still
                    case .limited:
                        isProceed = true
                        break
                    @unknown default:
                        fatalError()
                    }
                }
            case .limited:
                isProceed = true
                break
            @unknown default:
                fatalError()
            }
        
        return isProceed
        }
    

    public func presentCameraSettings(message:String) {
        let alertController = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })

        DispatchQueue.main.async {
            self.presentationController?.present(alertController, animated: true)
        }
        
    }
    
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "camera") {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .photoLibrary, title: "photoLibrary") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let alertPopoverPresentationController : UIPopoverPresentationController  = alertController.popoverPresentationController!;
            alertPopoverPresentationController.sourceRect = sourceView.bounds;
            alertPopoverPresentationController.sourceView = sourceView;
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?,imageName:String,imageExtention:String,imageUrl:URL?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.imageDidSelect(image: image,imageUrl:imageUrl,imageExtension:imageExtention,imageName:imageName)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, imageName: "", imageExtention: "", imageUrl: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if  let image = info[.editedImage] as? UIImage {
            
            let imgName = "msg-\(NSDate().timeIntervalSince1970)"
            let success = FileUtilities.sharedUtilites.saveImageFromData(data: image.jpegData(compressionQuality: 0.5)!, fileName: imgName)
            if success{
                
                guard let imgUrl:URL = FileUtilities.sharedUtilites.getImageURL(name: imgName) else{
                    return
                }
                //                self.fileUrl = imgUrl
                let fileURL = String(describing: imgUrl)
                let fullNameArr = fileURL.split{$0 == "/"}.map(String.init)
                print("File Name \(fullNameArr.last!)")
                let fileName = fullNameArr.last!
                let fileExtent = fileURL.split{$0 == "."}.map(String.init)
                let fileExtention = fileExtent.last
                let fileUrl = imgUrl
                self.pickerController(picker, didSelect: image, imageName: fileName, imageExtention: fileExtention ?? ".png", imageUrl: fileUrl)
            }
        }
        
        if  let image = info[.originalImage] as? UIImage {
            
            let imgName = "msg-\(NSDate().timeIntervalSince1970)"
            let success = FileUtilities.sharedUtilites.saveImageFromData(data: image.jpegData(compressionQuality: 0.5)!, fileName: imgName)
            if success{
                
                guard let imgUrl:URL = FileUtilities.sharedUtilites.getImageURL(name: imgName) else{
                    return
                }
                //                self.fileUrl = imgUrl
                let fileURL = String(describing: imgUrl)
                let fullNameArr = fileURL.split{$0 == "/"}.map(String.init)
                print("File Name \(fullNameArr.last!)")
                let fileName = fullNameArr.last!
                let fileExtent = fileURL.split{$0 == "."}.map(String.init)
                let fileExtention = fileExtent.last
                let fileUrl = imgUrl
                self.pickerController(picker, didSelect: image, imageName: fileName, imageExtention: fileExtention ?? ".png", imageUrl: fileUrl)
            }
            }
        }
}

class FileUtilities: NSObject {
    static let sharedUtilites = FileUtilities()
    
    func saveImageFromData(data:Data,fileName:String!)->Bool{
        do{
            let pth =  getImageURL(name:fileName)
            if FileManager.default.fileExists(atPath: pth!.path) {
                try FileManager.default.removeItem(at: pth!)
            }
            try data.write(to: getImageURL(name: fileName), options: NSData.WritingOptions.atomicWrite)
            return true
        }catch{
            print("error copying image")
            return false
        }
    }
    func getImageURL(name:String!)->URL!{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name+".jpg")
    }
    func removePics(){
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do{
            let pths = try FileManager.default.contentsOfDirectory(atPath: docDir.path)
            for p in pths{
                if p.contains(".jpg"){
                    try FileManager.default.removeItem(atPath: docDir.appendingPathComponent(p).path)
                }
            }
        }catch{
            print(error)
        }
        
    }
}


//MARK: - UIColor
extension UIColor {
    
    @objc class var primary: UIColor {
        return UIColor(red: 21, green: 115, blue: 142, alpha: 1)
    }
    
    @objc class var thumbOnColor: UIColor {
        return UIColor(red: 37/255, green: 203/255, blue: 208/255, alpha: 1)
    }
    
    @objc class var thumbOffColor: UIColor {
        return UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
    }
    
    @objc class var covidAcceptEnabled:UIColor {
        return UIColor(red: 32.0 / 255.0, green: 193.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
    }
    
    @objc class var covidAcceptDisable:UIColor {
        return UIColor(red: 32.0 / 255.0, green: 193.0 / 255.0, blue: 203.0 / 255.0, alpha: 0.55)
    }
    
    @objc class var backgroundSelectedDay:UIColor {
        return UIColor(red: 234.0 / 255.0, green: 244.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
    }
    
    @objc class var error: UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "colorError") ?? UIColor.red
        } else {
            return UIColor(red: 224, green: 32, blue: 32, alpha: 1)
        }
    }
    @objc class var darkBlack: UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "lableBlack") ?? UIColor.black
        } else {
            return UIColor(red: 36, green: 36, blue: 36, alpha: 1)
        }
    }
    @objc class var warmPink: UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "colorWarmPink") ?? UIColor.red
        } else {
            return UIColor(red: 252, green: 89, blue: 137, alpha: 1)
        }
    }
    @objc class var ColorAppLight: UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "ColorAppLight") ?? UIColor.green
        } else {
            return UIColor(red: 33, green: 192, blue: 200, alpha: 1)
        }
    }
 
    @objc class var warmPink2: UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "colorWarmPink2") ?? UIColor.red
        } else {
            return UIColor(red: 255, green: 60, blue: 96, alpha: 1)
        }
    }
    
    convenience init?(hexString: String) {
            let r, g, b, a: CGFloat

            if hexString.hasPrefix("#") {
                let start = hexString.index(hexString.startIndex, offsetBy: 1)
                let hexColor = String(hexString[start...])

                if hexColor.count == 6 {
                    let scanner = Scanner(string: hexColor)
                    var hexNumber: UInt64 = 0

                    if scanner.scanHexInt64(&hexNumber) {
                        r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                        g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                        b = CGFloat(hexNumber & 0x0000FF) / 255
                        a = 1.0
                        self.init(red: r, green: g, blue: b, alpha: a)
                        return
                    }
                }
            }

            return nil
        }
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
