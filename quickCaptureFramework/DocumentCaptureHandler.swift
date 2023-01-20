//
//  DocumentCaptureHandler.swift
//  quickCaptureFramework
//
//  Created by cumulations on 22/12/22.
//

import Foundation
import PDFKit
import VisionKit

@available(iOS 13.0, *)
public class doccap:VNDocumentCameraViewController,VNDocumentCameraViewControllerDelegate{
var imagesArray = [UIImage]()
var pdfDoc:PDFDocument?
public var completionHandlerImages: (([UIImage]?)->())?
public override func viewDidLoad() {
    super.viewDidLoad()
    print("view did load doccap")
    configureDocumentView()
}
private func configureDocumentView() {
    print("configuredocumentview")
    guard #available(iOS 13.0, *) else {
        print("* , ios 13")
//            let vc  = storyboard?.instantiateViewController(withIdentifier: "customimg") as! customImagesViewController
//            navigationController?.pushViewController(vc, animated: true)
//            handleAuthorisedd()
        return
    }
    let scannerViewController = VNDocumentCameraViewController()
    scannerViewController.delegate = self
    self.present(scannerViewController, animated: false, completion: nil)
}
func actionPdf(_ sender:Any) {
    print(imagesArray)
        pdfDoc = PDFDocument()
    if(imagesArray != nil){
        var j = 0
        for i in imagesArray{
            if #available(iOS 11.0, *) {
                let page = PDFPage(image: i)
                pdfDoc?.insert(page!, at: j)
                j+=1
            } else {
                // Fallback on earlier versions
            }
        }
        savepdf(pdfDocument: pdfDoc!,sender: sender)
    }
}
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
    
    @available(iOS 13.0, *)
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageNum in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageNum)
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            print(image)
            self.imagesArray.append(image)
            print(imagesArray)
        }
        completionHandlerImages!(imagesArray)
        controller.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: false)
        }
    }

    @available(iOS 13.0, *)
    public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
    //    controller.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }

    @available(iOS 13.0, *)
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        controller.dismiss(animated: true)
    }
}

