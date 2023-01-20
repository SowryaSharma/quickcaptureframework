import Foundation
import UIKit

public class SavePdfHandler{
    public init(){}
   static var shared = SavePdfHandler()
    public func SaveAsPdf(sender:Any, imagesArray: [UIImage], viewcontroller: UIViewController){
        if #available(iOS 11.0, *) {
            PDFHandler.sharedInstance.actionPdf(sender, imagesArray: imagesArray, viewcontroller: viewcontroller)
        } else {
//            print("lower ios")
            savePDF.shared.actionSave(sender, images: imagesArray, viewcontroller: viewcontroller)
        }
    }
}
