//
//  DocumentCaptureViewController.swift
//  quickCaptureFramework
//
//  Created by cumulations on 22/12/22.
//

import UIKit
import PDFKit
import VisionKit
@available(iOS 11.0, *)
public class DocumentCaptureViewController: UIViewController {
    var imagesArray = [UIImage]()
    var controller:UIViewController?
    var pdfDoc:PDFDocument?
    public var completionHandlerImages: (([UIImage]?)->())?
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        if(controller != nil){
        HandleUI(controller: self.controller!)
        }
        else{
            print("Call sender method (documentcaptureviewcontroller.sender(sender:self) before presenting view controller")
            navigationController?.popViewController(animated: false)
        }
    }
    public func sender(sender:UIViewController){
        self.controller = sender
    }
    public func HandleUI(controller:UIViewController){
        let vc  = storyboard?.instantiateViewController(withIdentifier: "ImagepickerVC") as! customImagesViewController
        //        print(controller,vc)
        if(controller == self || controller == vc){
//            print(controller)
            navigationController?.popViewController(animated: false)
        }
        else{
            configureDocumentView()
        }
    }
    private func configureDocumentView() {
        //        print("configuredocumentview")
        if #available(iOS 13.0, *) {
            let scannerViewController = VNDocumentCameraViewController()
            scannerViewController.delegate = self
            self.present(scannerViewController, animated: false, completion: nil)
        } else {
            return
        }
    }
    func actionPdf(_ sender:Any) {
//        print(imagesArray)
        pdfDoc = PDFDocument()
        if(imagesArray != nil){
            var j = 0
            for i in imagesArray{
                let page = PDFPage(image: i)
                pdfDoc?.insert(page!, at: j)
                j+=1
            }
        }
        savepdf(pdfDocument: pdfDoc!,sender: sender)
    }
    
    @available(iOS 11.0, *)
    func savepdf(pdfDocument:PDFDocument,sender:Any){
        let data = pdfDocument.dataRepresentation()
        let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let DirPath = DocumentDirectory.appendingPathComponent("QuickCapture")
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
        let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = (sender as AnyObject).frame
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    func popvc(){
        navigationController?.popViewController(animated: false)
    }
}
@available(iOS 11.0, *)
extension DocumentCaptureViewController: VNDocumentCameraViewControllerDelegate {
    @available(iOS 13.0, *)
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageNum in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageNum)
            //            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
//            print(image)
            self.imagesArray.append(image)
//            print(imagesArray)
        }
        completionHandlerImages!(imagesArray)
        controller.dismiss(animated: true, completion: nil)
        HandleUI(controller: self)
        //        DispatchQueue.main.async {
        //            self.navigationController?.popViewController(animated: false)
        //        }
    }
    
    @available(iOS 13.0, *)
    public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
        HandleUI(controller: self)
        
    }
    
    @available(iOS 13.0, *)
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        controller.dismiss(animated: true)
    }
}
