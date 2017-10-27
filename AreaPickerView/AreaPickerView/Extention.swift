//
//  Extention.swift
//  qimiaozhenxiang
//
//  Created by 贺思佳 on 2016/9/22.
//  Copyright © 2016年 Roger. All rights reserved.
//

import Foundation
import UIKit
//import SVProgressHUD


let SJKeyWindow = UIApplication.shared.keyWindow ?? (UIApplication.shared.delegate as! AppDelegate).window
let SJScreeW = UIScreen.main.bounds.size.width
let SJScreeH = UIScreen.main.bounds.size.height

let PageDefualt: Int = 1

//MARK: - Foundation
//MARK: - DATE日期处理
extension Date{
    /**
     把给定时间按照指定格式转化为字符串
     
     - parameter date:   需要转换的时候 不填默认为当前时间
     - parameter formet: 字符串时间格式"yyyy-MM-dd HH:mm:ss"
     
     - returns: 转化后的时间字符串
     */
    static func dateStringDate(date :Date = Date(), dateFormetString formet :String) ->String{
        
        let dateFormet = DateFormatter()
        dateFormet.dateFormat = formet
        return dateFormet.string(from: date)
    }
    
    func getWeakData() -> Int{
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.weekday, from: self)
    }
    
    /// 把给定时间按照指定格式转化为字符串
    ///
    /// - Parameters:
    ///   - timeInterval: Since1970毫秒数
    ///   - formet: 时间格式化字符串
    /// - Returns: 转化后的时间字符串
    static func dateStringTimeIntervalSince1970(timeInterval :Double, dateFormetString formet :String = "yyyy-MM-dd HH:mm") ->String{
        let date = Date(timeIntervalSince1970: timeInterval * 0.001)
        let dateFormet = DateFormatter()
        dateFormet.dateFormat = formet
        return dateFormet.string(from: date)
    }
    
    static func dateStringTimeIntervalSince1970(timeInterval :Int, dateFormetString formet :String = "yyyy-MM-dd HH:mm") ->String{

        return dateStringTimeIntervalSince1970(timeInterval: Double(timeInterval), dateFormetString: formet)
    }
    
    static func getDaysInMonth( year: Int, month: Int) -> Int
    {
        let calendar = Calendar.current
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        
        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = month == 12 ? 1 : month + 1
        endComps.year = month == 12 ? year + 1 : year
        
        let startDate = calendar.date(from: startComps)!
        let endDate = calendar.date(from: endComps)!
        let diff = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return diff.day!
    }
    
    static func dateFromString(dateStr :String, formetStr : String) ->Date{
        let dateFormet = DateFormatter()
        dateFormet.dateFormat = formetStr
        return dateFormet.date(from: dateStr)!
    }
    func dateCompoents() -> DateComponents {
        
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
    }
    
    func dataString(dateFormetStr :String) -> String{
        return Date.dateStringDate(date: self, dateFormetString: dateFormetStr)
    }
    
    //加一天
    func dateAddOneDay(count: Int = 1) -> Date{
        
        var dateCom = DateComponents()
        dateCom.day = count
        
        return  Calendar.current.date(byAdding: dateCom, to: self)!
    }
    
    //加一月
    func dateAddOneMonth(count: Int = 1) -> Date{
        
        var dateCom = DateComponents()
        dateCom.month = count
        
        return  Calendar.current.date(byAdding: dateCom, to: self)!
    }
    
    //减一天
    func dateSubtractingOneDay(count: Int = 1) -> Date{
        let timeInter = self.timeIntervalSince1970 - TimeInterval(3600 * count * 24)
        return Date(timeIntervalSince1970: timeInter)
    }
    
    func isToday() -> Bool{
        return self.dataString(dateFormetStr: "yyyy-MM-dd") == Date().dataString(dateFormetStr: "yyyy-MM-dd")
    }
    
    func isLater(date: Date = Date()) -> Bool{
        
        return self.timeIntervalSince(date) > 0
    }
    
}


//MARK: - NSObject
extension NSObject {
    
    private struct associatedKeys {
        static var safe_observersArray = "observers"
    }
    
    
    private var observers: [[String : NSObject]] {
        get {
            if let observers = objc_getAssociatedObject(self, &associatedKeys.safe_observersArray) as? [[String : NSObject]] {
                return observers
            } else {
                self.observers = [[String : NSObject]]()
                return self.observers
            }
        } set {
            objc_setAssociatedObject(self, &associatedKeys.safe_observersArray, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    public func safe_addObserver(observer: NSObject, forKeyPath keyPath: String) {
        let observerInfo = [keyPath : observer]
        
        if observers.index(where: { $0 == observerInfo }) == nil {
            observers.append(observerInfo)
            addObserver(observer, forKeyPath: keyPath, options: .new, context: nil)
        }
    }
    
    public func safe_removeObserver(observer: NSObject, forKeyPath keyPath: String) {
        let observerInfo = [keyPath : observer]
        if let index = observers.index(where: { $0 == observerInfo}) {
            observers.remove(at: index)
            removeObserver(observer, forKeyPath: keyPath)
        }
    }
    
    
    
}

extension Optional where Wrapped == String {
    
    var safeValue: String{
        if let str = self{
            return str
        }
        return ""
    }
}

extension String {
    

    
    var intValue: Int?{
        
        return Int(self)
    }
    
    func substring(to: Int) -> String{
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<index])
    }
    
    func substring(from: Int) -> String{
        let index = self.index(self.startIndex, offsetBy: from)
        return String(self[index...endIndex])
    }
    
    
    
    //    func md5() -> String {
    //        let str = self.cString(using: String.Encoding.utf8)
    //        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
    //        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    //        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
    //
    //
    //        CC_MD5(str!, strLen, result)
    //        let hash = NSMutableString()
    //        for i in 0 ..< digestLen {
    //            hash.appendFormat("%02x", result[i])
    //        }
    //        result.deinitialize()
    //
    //        return String(format: hash as String)
    //    }
}






protocol RandomNumType{
    associatedtype Element
    func random() -> Element
}

extension Int: RandomNumType{
    typealias Element = Int
    
    func random() -> Element {
        return Int(arc4random_uniform(UInt32(self)))
    }
    
    func stringValue() -> String?{
        return "\(self)"
    }
}

extension Array: RandomNumType{
    func random() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

extension Array where Element: Equatable{
    //数组元素随机打乱
    func upset() -> Array{
        var arry = self
        var result: [Element] = []
        for _ in 0 ..< arry.count{
            let element = arry.random()
            result.append(element)
            let index = arry.index(where: {$0 == element})
            if let index = index {
                arry.remove(at: index)
            }
        }
        return result
    }
}



public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
    
    
    
    /// 延时执行
    ///
    /// - Parameters:
    ///   - duration: 延时时间(秒)
    ///   - block: 待执行任务
    public class func afterDelay(duration: TimeInterval = 1.0 , block:@escaping ()->Void){
        self.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: block)
    }
}


public extension FileManager{
    
    static func documentsURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func getSizeInt(path: String) -> Int
    {
        if FileManager.default.fileExists(atPath: path){
            var fileinfo = try! FileManager.default.attributesOfItem(atPath: path)
            
            let size = Int(fileinfo[FileAttributeKey.size] as! Int)
            return size
            
            
        }else {
            return 0
        }
    }
    
    //    static func getSizeText(path: String) -> String{
    //        let size = getSizeInt(path: path)
    //        if size / 1024 <= 1 {
    //            return "\(size)"
    //        }
    //    }
}

//MARK: - UIKit

public extension UIImage{
    
    func addContent(content: String, frame: CGRect) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        self.draw(at: CGPoint.zero)
        let dic = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 40)]
        let str = content as NSString
        str.draw(in: frame, withAttributes: dic)
        let imageNew = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return imageNew!;
    }
    
    func compress(size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let imageNew = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return imageNew!;
    }
}


extension UIView{
    var x: CGFloat{
        get{
            return frame.origin.x
        }
        set{
            frame.origin.x = newValue
        }
    }
    var y: CGFloat{
        get{
            return frame.origin.y
        }
        set{
            frame.origin.y = newValue
        }
    }
    var width: CGFloat{
        get{
            return frame.size.width
        }
        set{
            frame.size.width = newValue
        }
    }
    var height: CGFloat{
        get{
            return frame.size.height
        }
        set{
            frame.size.height = newValue
        }
    }
    
    var viewCenter: CGPoint{
        get{
            return CGPoint(x: width * 0.5, y: height * 0.5)
        }
    }
    
    var centerX: CGFloat{
        get{
            return width * 0.5
        }
        set{
            center.x = newValue
        }
    }
    var setCenterY: CGFloat{
        get{
            return height * 0.5
        }
        set{
            center.y = newValue
        }
    }
    
    var centerY: CGFloat{
        get{
            return height * 0.5
        }
        set{
            center.y = newValue
        }
    }
    
    var inSuperViewCenterY: CGFloat{
        return y + centerY
    }
    
    var maxX: CGFloat{
        get{
            return self.x + self.width
        }
        set{
            x = newValue - self.width
        }
    }
    var maxY: CGFloat{
        get{
            return self.y + self.height
        }
        set{
            y = newValue - self.height
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat{
        
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
        
    }
    
    @IBInspectable var borderWidth: CGFloat{
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor?{
        get{
            return UIColor(cgColor: layer.borderColor!)
        }
        set{
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    
    /// 截取当前屏幕
    ///
    /// - Returns: 返回图片
    func printScreen() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    class func loadFromXib() -> UIView{
        let className = NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
        return Bundle.main.loadNibNamed(className, owner: nil, options: nil)?.first as! UIView
    }
    
    func getNavController(_ vc: UIViewController = (SJKeyWindow!.rootViewController)!) -> UINavigationController?{
        if let vc = vc as? UITabBarController{
            return getNavController(vc.selectedViewController!)
        }else if let vc = vc as? UINavigationController{
            return vc
        }
        return nil
    }
}

//MARK: - UITableView
extension UITableView{
    func animateTable(duration: TimeInterval = 1.0 ) {
        self.reloadData()
        
        let cells = self.visibleCells
        let tableHeight = self.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        for cell in cells {
            UIView.animate(withDuration: duration, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            index += 1
        }
    }
}

extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

//MARK: - UILable
extension UILabel{
    func ranged(range: NSRange, color: UIColor?, fontNumber: CGFloat?){
        let str = NSMutableAttributedString(string: text!)
        if fontNumber != nil {
            str.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontNumber!)], range: range)
        }
        
        if color != nil {
            str.addAttribute(NSAttributedStringKey.foregroundColor, value: color!, range: range)
        }
        self.attributedText = str
    }
    
    func contentString(contentStr: String, color: UIColor){
        let range = (text! as NSString).range(of: contentStr)
        ranged(range: range, color: color, fontNumber: nil)
    }
}

//MARK: - UIColor
extension UIColor{
    
    class func colorFromRGB(rgbValue: UInt) -> UIColor {
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

//MARK: - UIStoryboard
extension UIStoryboard{
    class func instantiateInitialViewController(name: String) -> UIViewController{
        let storyBoard = UIStoryboard.init(name: name, bundle: nil)
        
        return storyBoard.instantiateInitialViewController()!
    }
}

//MARK: - UIViewController
extension UIViewController{
    
    
    
    
    func alert(message: String) {
        let alc = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alc.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alc, animated: true, completion: nil)
    }

    
    func alert(message: String, doneBlock: @escaping ((UIAlertAction)->()),cancleBlock: @escaping ((UIAlertAction)->())) {
        let alc = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alc.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: cancleBlock))
        alc.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: doneBlock))
        
        self.present(alc, animated: true, completion: nil)
    }
}

extension NSObject{
    func alert(message: String, doneBlock: @escaping ((UIAlertAction)->())) {
        let alc = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alc.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil))
        alc.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: doneBlock))
        SJKeyWindow?.rootViewController?.present(alc, animated: true, completion: nil)
    }
    
}


//MARK: - ShowLoading
protocol ShowLoadingProtocol {
    func showLoding()
    func dismiss()
    
    func showError(_: String)
    func showSuccess(_: String)
}

//extension ShowLoadingProtocol{
//    func showLoding(){
//        SVProgressHUD.show(withStatus: "加载中")
//    }
//
//    func dismiss(){
//        SVProgressHUD.dismiss()
//    }
//
//    func showError(_ str: String){
//        SVProgressHUD.showError(withStatus: str)
//    }
//
//    func showSuccess(_ str: String){
//        SVProgressHUD.showSuccess(withStatus: str)
//    }
//}

//extension UIViewController: ShowLoadingProtocol{}

//MARK: - ConverToJson
protocol ConverToJsonStringProtocal {
    var jsonString: String{get}
}
extension ConverToJsonStringProtocal{
    var jsonString: String{
        
        do {
            let stringData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let string = String(data: stringData, encoding: String.Encoding.utf8){
                return string
            }
        } catch let error as NSError {
            print("转换json失败")
            print(error)
            return ""
        }
        return ""
    }
}

extension Array: ConverToJsonStringProtocal{}
extension Dictionary: ConverToJsonStringProtocal{}

//MARK: - 遵守这个协议后,控制台可以打印模型的属性值
extension CustomStringConvertible{
    var description: String{
        let mirror = Mirror(reflecting: self)
        var des = ""
        for p in mirror.children {
            let propertyNameString = p.label! //属性名使用!，因为label是optional类型
            let value = p.value //属性的值
            print()
            des.append("\(propertyNameString)的值为\(value)\n")
        }
        return des
    }
}

//MARK: - HTTP
class HttpUtil{
    /// HEADER请求
    ///
    /// - Parameters:
    ///   - urlStr: 目标url
    ///   - handle:  headerHandle
    class func getHeadersUrl(_ urlStr: String,handle:@escaping ((String) ->())){
        let session = URLSession.shared
        //let url = URL(string: urlStr)!
        var requset =  URLRequest(url: URL(string: urlStr)!)
        requset.httpMethod = "HEAD"
        
        session.dataTask(with: requset) { (_, response, error) in
            
            DispatchQueue.main.async {
                if let contentType = response?.mimeType{
                    handle(contentType)
                }else{
                    handle("")
                }
            }
            
            
            }.resume()
    }
}

