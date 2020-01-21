//
//  ViewController.swift
//  ImagePicker
//
//  Created by Alex Paul on 1/20/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import AVFoundation // we want to use AVMakeRect() to maintain image aspect ratio.  Image could look distorted or stretched out.  fix a rectangle just in case

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imageObjects = [ImageObject]()
    
    private let imagePickerController = UIImagePickerController()
    
    private var selectedImage: UIImage? {
        didSet {
            // gets called when new image is seleceted
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        imagePickerController.delegate = self
        
    }
    
    
    @IBAction func addPictureButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    
    private func appendNewPhotoToCollection() {
        guard let image = selectedImage,
            let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("image is nil")
            return
        }
        
        print("original image size :\(image.size)")
        
        //create an ImageObject
        let imageObject = ImageObject(imageData: imageData, date: Date())
        
        //insert new imageObject into imageObjects
        imageObjects.insert(imageObject, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
        
        
    }
    
    
}

// MARK: - UICollectionViewDataSource
extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell else {
            fatalError("could not downcast to an ImageCell")
        }
        
        let imageObject = imageObjects[indexPath.row]
        cell.configureCell(imageObject: imageObject)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let itemWidth: CGFloat = maxWidth * 0.80
        return CGSize(width: itemWidth, height: itemWidth)  }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagesViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.] as? UIImage else {
            print("Image selected not found")
            return
        }
        
        selectedImage = image
        
        dismiss(animated: true, completion: nil)
    }
}

// more here: https://nshipster.com/image-resizing/
// MARK: - UIImage extension
extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

