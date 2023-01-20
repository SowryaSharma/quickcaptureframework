//
//  ViewController.swift
//  ScanAndCropDemoApp
//
//  Created by Cumulations Technologies Private Limited on 17/12/22.
//

import UIKit
import CoreImage
import CropViewController
class cropViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, CropViewControllerDelegate {
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    var img = UIImage()
    var thumbnailImage = UIImage()
    var croppedImg:UIImage?
    var documentsCGrect:[CIFeature]?
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet var panGestureRecogniser1: UIPanGestureRecognizer!
    @IBOutlet var panGestureRecogniser2: UIPanGestureRecognizer!
    @IBOutlet var panGestureRecogniser3: UIPanGestureRecognizer!
    @IBOutlet weak var imageAfterAlteration: UIImageView!
    @IBOutlet var panGestureRecogniser4: UIPanGestureRecognizer!
    let shapeLayer = CAShapeLayer()
    //    public var completionHandlerCroppedVC:((UIImage?)->Void)?
    public var completionHandler:((Bool)->())?
    var x1 = Double()
    var y1 = Double()
    var x2 = Double()
    var y2 = Double()
    var x3 = Double()
    var y3 = Double()
    var x4 = Double()
    var y4 = Double()
    let path = UIBezierPath()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationItem.hidesBackButton = true
        documentsCGrect = detectImages(images: img)
        if(documentsCGrect?.count ?? 0 > 0){
            print(documentsCGrect?[0].bounds)
            if let cgrect = documentsCGrect?[0].bounds{
                if let ciimage = img.ciImage?.cropped(to: cgrect){
                    self.img = UIImage(ciImage: ciimage)
                }
            }
        }
        else{
            print("not detected")
        }
        
        
        panGestureRecogniser1.delegate = self
        panGestureRecogniser2.delegate = self
        panGestureRecogniser3.delegate = self
        panGestureRecogniser4.delegate = self
        
        
        
        
        view1.makeCircleView(view: view1)
        view2.makeCircleView(view: view2)
        view3.makeCircleView(view: view3)
        view4.makeCircleView(view: view4)
        
        
        let view1Center = view1.center
        x1 = view1Center.x
        y1 = view1Center.y
        //        print("x1:\(x1),y1:\(y1)")
        let view2Center = view2.center
        x2 = view2Center.x
        y2 = view2Center.y
        //        print("x2:\(x2),y2:\(y2)")
        
        let view3Center = view3.center
        x3 = view3Center.x
        y3 = view3Center.y
        //        print("x3:\(x3),y3:\(y3)")
        let view4Center = view4.center
        x4 = view4Center.x
        y4 = view4Center.y
        //        print("x4:\(x4),y4:\(y4)")
        
        //        path.move(to: view1.center)
        //        path.addLine(to: view2.center)
        //        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        transparentView.layer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.lineDashPattern = [5, 5]
        shapeLayer.fillColor = UIColor.clear.cgColor
        transparentView.layer.addSublayer(shapeLayer)
        
        
        shapeLayer.isHidden = true
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = true
        view4.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.imageAfterAlteration.image = croppedImg ?? img
        setupUI()
        //        updateShapeLayerPath()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y2))
        path.addLine(to: CGPoint(x: x3, y: y3))
        path.addLine(to: CGPoint(x: x4, y: y4))
        
        path.close()
    }
    func updateShapeLayerPath() {
        let path = UIBezierPath()
        path.move(to: view1.center)
        path.addLine(to: view2.center)
        path.addLine(to: view4.center)
        path.addLine(to: view3.center)
        path.addLine(to: view1.center)
        shapeLayer.path = path.cgPath
    }
    
    @IBAction func resizeIMage(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "resize") as! resizeViewController
//        vc.image = self.croppedImg ?? self.img
//        vc.completionHandler = {resizedimage in
//            print(resizedimage)
//            self.croppedImg = resizedimage
//            self.img = resizedimage
//            self.imageAfterAlteration.image = self.croppedImg
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
        showPickerController(sender: sender)
    }
//        //MARK:- for testing purpose
//        //todo:- add textfields to get width and height from user
//        let obj = resizeHandler()
//        if(img != nil){
//        let i = obj.resizeImage(image: img, height: 200, width: 200)
//        if let resizedImage = i{
//            self.croppedImg = i
//            self.imageAfterAlteration.image = croppedImg
//            let alert = UIAlertController(title: "Alert", message: "Succesfully resized", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        }
//        else{
//            let alert = UIAlertController(title: "Alert", message: "No images found", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
    
    //actionCropImage
    @IBAction func actionCropImage(_ sender: Any) {
        
        
        let point1 = CGPoint(x: x1, y: y1)
        let point2 = CGPoint(x: x2, y: y2)
        let point4 = CGPoint(x: x3, y: y3)
        let point3 = CGPoint(x: x4, y: y4)
        
        let minX = min(point1.x, point2.x, point3.x, point4.x)
        let minY = min(point1.y, point2.y, point3.y, point4.y)
        let maxX = max(point1.x, point2.x, point3.x, point4.x)
        let maxY = max(point1.y, point2.y, point3.y, point4.y)
        
        let rectToCrop = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        
        let croppedImage: UIImage
        let scale = imageAfterAlteration.frame.width/img.size.width
        //        print(img)
        croppedImage = cropImage2(image: img, rect: rectToCrop, scale: scale)!
        shapeLayer.isHidden = true
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = true
        view4.isHidden = true
        imageAfterAlteration.image = croppedImage
        self.croppedImg = croppedImage
    }
    
    //actionRetake
    @IBAction func actionRetakeImage(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    func saveData2(image:UIImage){
        self.img = image
    }
    
    func setupUI(){
//        shapeLayer.isHidden = false
//        view1.isHidden = false
//        view2.isHidden = false
//        view3.isHidden = false
//        view4.isHidden = false
        
        imageAfterAlteration.image = img
    }
    func cropImage1(image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage!
        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!, scale: image.scale, orientation: image.imageOrientation)
    }
    
    func cropImage2(image: UIImage, rect: CGRect, scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / scale, height: rect.size.height / scale), true, 0.0)
        image.draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
    
    
    //actionsCropDrag
        @IBAction func panGesture1Dragged(_ sender: UIPanGestureRecognizer) {
            if(sender.state == .began || sender.state == .changed){
                let translation = sender.translation(in: sender.view)
                let changeX = (sender.view?.center.x)! + translation.x
                let changeY = (sender.view?.center.y)! + translation.y
                
                sender.view?.center = CGPoint(x: changeX, y: changeY)
//                print("x1:\(changeX), y1:\(changeY)")
                x1 = changeX
                y1 = changeY
                sender.setTranslation(CGPoint.zero, in: sender.view)
                updateShapeLayerPath()
                
            }
        }
        
        @IBAction func panGesture2Dragged(_ sender: UIPanGestureRecognizer) {
            //        shapeLayer.removeFromSuperlayer()
            if(sender.state == .began || sender.state == .changed){
                let translation = sender.translation(in: sender.view)
                let changeX = (sender.view?.center.x)! + translation.x
                let changeY = (sender.view?.center.y)! + translation.y
                
                sender.view?.center = CGPoint(x: changeX, y: changeY)
//                print("x2:\(changeX), y2:\(changeY)")
                
                x2 = changeX
                y2 = changeY
                sender.setTranslation(CGPoint.zero, in: sender.view)
                
                updateShapeLayerPath()
            }
        }
        
        @IBAction func panGesture3Dragged(_ sender: UIPanGestureRecognizer) {
            if(sender.state == .began || sender.state == .changed){
                let translation = sender.translation(in: sender.view)
                let changeX = (sender.view?.center.x)! + translation.x
                let changeY = (sender.view?.center.y)! + translation.y
                
                sender.view?.center = CGPoint(x: changeX, y: changeY)
//                print("x3:\(changeX), y3:\(changeY)")
                
                x3 = changeX
                y3 = changeY
                sender.setTranslation(CGPoint.zero, in: sender.view)
                updateShapeLayerPath()
            }
        }
        
        @IBAction func panGesture4Dragged(_ sender: UIPanGestureRecognizer) {
            if(sender.state == .began || sender.state == .changed){
                let translation = sender.translation(in: sender.view)
                let changeX = (sender.view?.center.x)! + translation.x
                let changeY = (sender.view?.center.y)! + translation.y
                
                sender.view?.center = CGPoint(x: changeX, y: changeY)
//                print("x4:\(changeX), y4:\(changeY)")
                
                x4 = changeX
                y4 = changeY
                sender.setTranslation(CGPoint.zero, in: sender.view)
                updateShapeLayerPath()
            }
        }
    var cameraView = customImagesViewController()
    var i = 0
    @IBOutlet weak var imageview: UIImageView!
    var image:UIImage?
    var imagesArray = [UIImage]()
    public func detection(image:UIImage){
        self.image = image
        let faces = detectImages(images: image) ?? nil
        guard let face = faces else{return}
        if(face.count>0){
            let width = face[0].bounds.width
            let height = face[0].bounds.height
            let x = face[0].bounds.minX
            let y = face[0].bounds.minY
            
            let rect = CGRect(x: x, y: y, width: width, height: height)
            //            let rect = face[0].bounds
            //            print(rect)
            //            print(image.size)
            guard let cimage = image.cgImage else{return}
            let imageRef: CGImage = cimage.cropping(to: rect)!
            let imagea: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
            self.img = imagea
        }
        else{
            self.img = image
        }
        //        self.imagesArray.append(image)
    }
    func detectImages(images:UIImage) -> [CIFeature]?{
        //        print(images)
        guard let CImage = CIImage(image: images) else {
            return nil
        }
        let DocumentDetector = CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        let Documents = DocumentDetector!.features(in: CImage)
        //        print("\(Documents)")
        return Documents
    }
    
    
//        func saveImagetodirectory(){
//            do {
//                // get the documents directory url
//                let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//    //            print("documentsDirectory:", documentsDirectory.path)
//                // choose a name for your image
//                let fileName = "image\(i).jpg"
//                i+=1
//                let fileURL = documentsDirectory.appendingPathComponent(fileName)
//                if let data = image?.jpegData(compressionQuality:  1),
//                   !FileManager.default.fileExists(atPath: fileURL.path) {
//                    try data.write(to: fileURL)
//    //                print("file saved")
//                }
//            } catch {
//                print("error:", error)
//            }
//        }
    @IBAction func actionedit(_ sender: Any) {
        let vc = CropViewController(image: croppedImg ?? img)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedImg = image
        self.img = image
        if(croppedImg == image){
            print("copied")
        }
        cropViewController.dismiss(animated: true, completion: nil)
        self.imageAfterAlteration.image = croppedImg
    }
    
    //action create thumbnail
    func showPickerController(sender:Any) {
        let alertController = UIAlertController(title: "Edit Images", message: nil, preferredStyle: .actionSheet)

//        alertController.view.translatesAutoresizingMaskIntoConstraints = false
//        alertController.view.heightAnchor.constraint(equalToConstant: 430).isActive = true


        let CameraAction = UIAlertAction(title: "Resize", style: .default) { (action) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "resize") as! resizeViewController
            vc.image = self.croppedImg ?? self.img
            vc.completionHandler = {resizedimage in
                print(resizedimage)
                self.croppedImg = resizedimage
                self.img = resizedimage
                self.imageAfterAlteration.image = self.croppedImg
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let galleryAction = UIAlertAction(title: "Make Thumbnail", style: .default) { action in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "thumbnail") as! ThumbnailViewController
            vc.image = self.croppedImg ?? self.img
            vc.completionHandler = {resizedimage in
                print(resizedimage)
                self.croppedImg = resizedimage
                self.img = resizedimage
                self.imageAfterAlteration.image = self.croppedImg
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(CameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = self.view
//            alertController.popoverPresentationController?.sourceView = sender as! UIButton
            alertController.popoverPresentationController?.sourceRect = (sender as AnyObject).frame
        }
        self.present(alertController, animated: true, completion: nil)
    }
    func createThumbnail(){
        if let imageData = img.pngData(){
            let options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary
            
            imageData.withUnsafeBytes { ptr in
                guard let bytes = ptr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, imageData.count){
                    let source = CGImageSourceCreateWithData(cfData, nil)!
                    let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
                    let thumbnail = UIImage(cgImage: imageReference)
                    self.thumbnailImage = thumbnail
                    self.croppedImg = thumbnailImage
                    self.imageAfterAlteration.image = thumbnailImage
                }
            }
        }
    }
    //actionAddMore
    @IBAction func AddmoreImages(_ sender: Any) {
        ImagesDataModel.shared.ImagesArray.append(croppedImg ?? img)
        navigationController?.popViewController(animated: false)
    }
    //actionAddFromPhotos
    @IBAction func ActionAddfromPhotos(_ sender: Any) {
        ImagesDataModel.shared.ImagesArray.append(croppedImg ?? img)
        let vc = storyboard?.instantiateViewController(withIdentifier: "photolibvc") as! ImagePickerFromPhotosLibraryViewController
        vc.sender(from: self)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    //actionCompleted
    @IBAction func saveImages(_ sender: Any) {
        //        let vc2  = storyboard?.instantiateViewController(withIdentifier: "customimg") as! customImagesViewController
        //        vc2.sender(sender: self)
        ImagesDataModel.shared.ImagesArray.append(croppedImg ?? img)
        //        print(ImagesDataModel.shared.imagesArray)
        completionHandler?(true)
        guard let navigationController = navigationController else {return}
        let count = navigationController.viewControllers.count
        var navigationarray = navigationController.viewControllers
        if(count >= 2){
            navigationarray.remove(at: count-2)
        }
        navigationController.viewControllers = navigationarray
        navigationController.popViewController(animated: false)
    }
}

