//
//  pdfHandler.swift
//  quickCaptureFramework
//
//  Created by cumulations on 26/12/22.
//

import Foundation
import PDFKit

@available(iOS 11.0, *)
public class PDFHandler{
    public init() {}
    var pdfDoc:PDFDocument?
    static var sharedInstance = PDFHandler()
    public func actionPdf(_ sender:Any,imagesArray:[UIImage],viewcontroller:UIViewController) {
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
        savepdf(pdfDocument: pdfDoc!,sender: sender,viewcontroller: viewcontroller)
    }
    
    @available(iOS 11.0, *)
    func savepdf(pdfDocument:PDFDocument,sender:Any,viewcontroller:UIViewController){
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
            activityViewController.popoverPresentationController?.sourceView = viewcontroller.view
            activityViewController.popoverPresentationController?.sourceRect = (sender as AnyObject).frame
        }
        viewcontroller.present(activityViewController, animated: true, completion: nil)
    }
}
