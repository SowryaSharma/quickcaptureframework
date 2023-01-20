
//
//  ImagePickerFromPhotosLibraryViewController.swift
//  quickCaptureFramework
//
//  Created by cumulations on 03/01/23.
//

import UIKit

public class ImagePickerFromPhotosLibraryViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var img = UIImage()
    var sender:UIViewController?
    public var completionHandler:(([UIImage]?,String)->Void)?
    var imagePicker = UIImagePickerController()
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationItem.hidesBackButton = false
        self.navigationItem.leftBarButtonItem = nil
    }
   public override func viewDidAppear(_ animated: Bool) {
       guard let sender = sender else {
           print("call sender function before presenting this view controller")
           navigationController?.popViewController(animated: false)
           return
       }

       HandleUI(controller: sender)
    }
    public func sender(from viewcontroller:UIViewController){
        self.sender = viewcontroller
    }
    public func HandleUI(controller:UIViewController){
//        print("controller.title=\(controller.title),\(controller)")
//        let vc  =  EditScanViewController()
//        print(controller,vc)
        if(controller == self){
            print(controller)
            navigationController?.popViewController(animated: false)
        }
        else{
            PickImagefromGallery()
        }
    }
    func PickImagefromGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
//            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            completionHandler?(nil,"Error accessing Photos library")
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            img = info[.originalImage] as! UIImage
            picker.dismiss(animated: true, completion: nil)
            let vc = storyboard?.instantiateViewController(withIdentifier: "cropVC") as! cropViewController
            vc.saveData2(image: img)
            vc.completionHandler = {status in
                self.completionHandler?(ImagesDataModel.shared.ImagesArray,"success")
                ImagesDataModel.shared.ImagesArray.removeAll() 
            }
            navigationController?.pushViewController(vc, animated: false)
        }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled")
        picker.dismiss(animated: true, completion: nil)
        HandleUI(controller: self)
    }
}
