//
//  resizeViewController.swift
//  quickCaptureFramework
//
//  Created by cumulations on 04/01/23.
//

import UIKit

class resizeViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var imageview: UIImageView!
    public var completionHandler:((UIImage)->Void)?
    var image = UIImage()
    var resizedImage = UIImage()
    var aspectra = true
    var heightE:Float?
    var widthE:Float?
    var isKeyboardPresent = false
    @IBOutlet weak var SwitchButton: UISwitch!
    @IBOutlet weak var ResizeButton: UIButton!
    @IBOutlet weak var widthTextfueld: UITextField!
    @IBOutlet weak var heightTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardDidHideNotification, object: nil)
        SwitchButton.addTarget(self, action: #selector(AspectRatiooptionChange), for: .valueChanged)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.hidesBackButton = false
    }
    @objc private func keyboardWillShow(notification: NSNotification){
        if(!isKeyboardPresent){
        isKeyboardPresent = true
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        isKeyboardPresent = false
        self.view.frame.origin.y = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        self.imageview.image = image
        heightE = Float(image.size.height)
        widthE = Float(image.size.width)
        changeBUttonTitle(height: heightE!, width: widthE!)
        self.heightTextfield.text = "\(heightE!)"
        self.widthTextfueld.text = "\(widthE!)"
        heightTextfield.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        widthTextfueld.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    @objc func AspectRatiooptionChange(_ sender: UISwitch) {
        if(sender.isOn == true){
            self.aspectra = true
            changeBUttonTitle(height: heightE!, width: widthE!)
        }
        else{
            self.aspectra = false
            changeBUttonTitle(height: heightE!, width: widthE!)
        }
    }
    func changeBUttonTitle(height:Float,width:Float){
        if(self.aspectra){
       if(height >= width){
           self.ResizeButton.setTitle("Resize(\(height) X Ratio)", for: .normal)
       }
       else{
           self.ResizeButton.setTitle("Resize(Ratio X \(width))", for: .normal)
       }
        }
        else{
            self.ResizeButton.setTitle("Resize(\(height) X \(width))", for: .normal)
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        heightE = (heightTextfield.text as! NSString).floatValue
        widthE = (widthTextfueld.text as! NSString).floatValue
        changeBUttonTitle(height: heightE ?? 0, width: widthE ?? 0)
    }
    @IBAction func actionresize(_ sender: Any) {
        let height = (heightTextfield.text as! NSString).floatValue
        let width = (widthTextfueld.text as! NSString).floatValue
        self.resizedImage = resizeImage(image: image, height: CGFloat(height), width: CGFloat(width)) ?? image
        completionHandler?(resizedImage)
        navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var targetSize:CGSize?
    public func resizeImage(image: UIImage,height: CGFloat,width:CGFloat) -> UIImage? {
        let size = image.size
        targetSize = CGSize(width: width, height: height)
        let widthRatio  = targetSize!.width  / size.width
        let heightRatio = targetSize!.height / size.height
        var newSize: CGSize
        if(aspectra){
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        }
        else{
        newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
        }
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//        UIImageWriteToSavedPhotosAlbum(newImage!, nil, nil, nil)
        return newImage
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
