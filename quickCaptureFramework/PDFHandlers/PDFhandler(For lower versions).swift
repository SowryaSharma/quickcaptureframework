//
//  PDFhandler(For lower versions).swift
//  quickCaptureFramework
//
//  Created by cumulations on 27/12/22.
//

import Foundation
import UIKit
class savePDF{
    static var shared = savePDF()
    func actionSave(_ sender: Any,images:[UIImage],viewcontroller:UIViewController) {
        let data = createPDFS(arrImages: images)
        let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let DirPath = DocumentDirectory.appendingPathComponent("QuickCap111")
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
    func createPDFS(arrImages: [UIImage]) -> NSData? {
        
        var pageHeight = 0.0
        var pageWidth = 0.0
        
        for img in arrImages
        {
            pageHeight =  pageHeight+Double(img.size.height)
            if Double(img.size.width) > pageWidth
            {
                pageWidth = Double(img.size.width)
            }
            print(pageWidth,pageHeight)
        }
        
        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        
        var mediaBox = CGRect.init(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
        
        for img in arrImages
        {
            var mediaBox2 = CGRect.init(x: 0, y: 0, width: img.size.width, height: img.size.height)
            
            pdfContext.beginPage(mediaBox: &mediaBox2)
            pdfContext.draw(img.cgImage!, in: CGRect.init(x: 0.0, y: 0, width: pageWidth+100, height: Double(img.size.height)))
            
            pdfContext.endPage()
        }
        
        return pdfData
    }
    
}
