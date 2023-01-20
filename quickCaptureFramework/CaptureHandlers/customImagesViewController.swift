//
//  customImagesViewController.swift
//  QuickCapture
//
//  Created by cumulations on 20/12/22.
//

import UIKit

public class customImagesViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageview: UIImageView!
    var imgArray = NSMutableArray()
    var controller:UIViewController?
    var presented = true
    public var completionHandler:(([UIImage]?,String)->Void)?
    public override func viewDidLoad() {
        super.viewDidLoad()
        if(self.isBeingPresented){
            print("presenting")
            presented = true
        }
        else if(navigationController?.presentingViewController?.presentedViewController == navigationController){
            presented = false
            print("pushed to navigationcontroller")
        }
        else{
            presented = false
        }
    }
    public override func viewWillAppear(_ animated: Bool) {
        //        handleAuthorisedd()
        if(controller != nil){
        HandleUI(controller: controller!)
        }
        else{
            print("Call sender method (customImagesViewController.sender(sender:self) before presenting view controller")
            if(presented){
                self.dismiss(animated: false, completion: nil)
            }
            else{
            navigationController?.popViewController(animated: false)
            }
        }
        navigationController?.navigationBar.isHidden = true
        self.navigationItem.leftBarButtonItem = nil
//        print(navigationController?.viewControllers)
    }
    public func sender(sender:UIViewController){
//        print("sender = \(sender.title)")
        self.controller = sender
    }
    public func HandleUI(controller:UIViewController){
//        print("controller.title=\(controller.title),\(controller)")
//        let vc  =  EditScanViewController()
//        print(controller,vc)
        if(controller == self){
//            print(controller)
            completionHandler?(nil,"Cancelled")
            if(presented){
                self.dismiss(animated: false, completion: nil)
            }
            else{
            navigationController?.popViewController(animated: false)
            }
        }
        else{
            handleAuthorisedd()
        }
    }
    func handleAuthorisedd(){
        let vc = UIImagePickerController()
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: false)
        }
        else{
            navigationController?.popViewController(animated: false)
            completionHandler?(nil,"Camera not detected")
            return
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false)
//        print(info)
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let DirPath = DocumentDirectory.appendingPathComponent("QuickCapture\(Date())")
        let data = image.jpegData(compressionQuality:  1)
        do
        {
            try FileManager.default.createDirectory(atPath: DirPath!.path, withIntermediateDirectories: false, attributes: nil)
        }
        catch let error as NSError
        {
            print("Unable to create directory \(error.debugDescription)")
        }
        print("Path = \(DirPath!)")
        
        let docURL = DirPath!.appendingPathComponent("Scanned-Docs\(Date()).pdf")
        
        do{
            try data?.write(to: docURL)
            print(docURL)
        }catch(let error){
            print("error is \(error.localizedDescription)")
        }
//        print(image.size)
//        self.imgArray.append(image)
        let vc = storyboard?.instantiateViewController(withIdentifier: "cropVC") as! cropViewController
        vc.saveData2(image: image)
        vc.completionHandler = {status in
            self.completionHandler?(ImagesDataModel.shared.ImagesArray,"success")
            ImagesDataModel.shared.ImagesArray.removeAll()
        }
        navigationController?.pushViewController(vc, animated: false)
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        HandleUI(controller: self)
    }
}
