//
//  ThumbnailViewController.swift
//  quickCaptureFramework
//
//  Created by cumulations on 09/01/23.
//

import UIKit

class ThumbnailViewController: UIViewController,UITextFieldDelegate {
    var image = UIImage()
    var isKeyboardPresent = false
    public var completionHandler:((UIImage)->Void)?
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    var thumbnailImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardDidHideNotification, object: nil)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.hidesBackButton = false

        // Do any additional setup after loading the view.
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
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func createThumbnail(_ sender: Any) {
        var pixels = (textfield.text as! NSString).floatValue
        if(pixels <= 0){
            return
        }
        self.thumbnailImage = createThumbnail(pixel: pixels)
        completionHandler?(thumbnailImage)
        navigationController?.popViewController(animated: true)
    }
    func createThumbnail(pixel:Float) -> UIImage{
        if let imageData = image.pngData(){
            let options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: pixel] as CFDictionary
            
            imageData.withUnsafeBytes { ptr in
                guard let bytes = ptr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, imageData.count){
                    let source = CGImageSourceCreateWithData(cfData, nil)!
                    let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
                    let thumbnail = UIImage(cgImage: imageReference)
                    self.thumbnailImage = thumbnail
                }
            }
            return thumbnailImage
        }
        return thumbnailImage
    }
}
