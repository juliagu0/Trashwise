//
//  ViewController.swift
//  TrashWise
//
//  Created by julia on 2023-11-12.
//


/*
 #ABD699 GREEN
 #FFE26A YELLOW
 #75C9B7 MINT
 #C7DDCC LIGHT GREEN
 #16123F BLACK BLUE
 
 

 
 */
import UIKit
import CoreML
import Vision
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var resultsLabel: UILabel!
    var totalStr=""
    
    //var UIimage = UIImage()
    var imagePicker = UIImagePickerController()
 
    @IBOutlet weak var picture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
 
//    func detect(image: CIImage) {
//        guard let model = try? VNCoreMLModel(for: TrashwiseClassifier().model) else {
//            fatalError("ther is error Failed to load Core ML model")
//        }
//        
//        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
//            guard let results = request.results as? [VNCoreMLFeatureValueObservation],
//                  let topResult = results.first else {
//                print("No results or unexpected result format")
//                return
//            }
//            
//            // Accessing the multi-array result
//            if let multiArray = topResult.featureValue.multiArrayValue {
//                var maxIndex = 0
//                var maxValue: Double = 0.0
//                
//                for i in 0..<multiArray.count {
//                    let value = multiArray[i].doubleValue
//                    if value > maxValue {
//                        maxValue = value
//                        maxIndex = i
//                    }
//                }
//                
//                let confidence = maxValue // Confidence score for the prediction
//                
//                // Example: Displaying the top result
//                DispatchQueue.main.async {
//                    self?.resultsLabel.text = "Predicted Class: \(maxIndex) with confidence \(confidence)"
//                }
//            } else {
//                print("No multi-array value found or unexpected format")
//            }
//        }
//        
//        let handler = VNImageRequestHandler(ciImage: image)
//        
//        do {
//            try handler.perform([request])
//        } catch {
//            print("Error performing VNImageRequestHandler: \(error)")
//        }
//    }


    func detect(image: CIImage) {
   
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for:TrashwiseAiModel().model) else {
            fatalError("can't load ML model")
            print("can nooot found")
        }
 
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first
              
                 
                else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            print(topResult)
//            self.totalStr += ("First: \(results[0].identifier) \n")
//            self.totalStr += ("Second: \(results[1].identifier) \n")
//            self.totalStr += ("Third: \(results[2].identifier) \n")
//            self.resultsLabel.text = self.totalStr

        }
 
        let handler = VNImageRequestHandler(ciImage: image)
 
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    
    


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        if let image = info[.originalImage] as? UIImage {
            self.picture.image = image
            //self.photoImageView.image = image
            self.imagePicker.dismiss(animated: true, completion: nil)
            guard let ciImage = CIImage(image: image) else {
                fatalError("couldn't convert uiimage to CIImage")
            }
            self.detect(image: ciImage)
            
            //print("The image" , image)
        }
        
    }
    
    
    @IBAction func cameraButtonisPress(_ sender:UIButton){
        openCamers()
           // print("press")
      
    }
    

    
    func openCamers(){
        //self.imagePicker.sourceType = .camera
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
}
    
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
