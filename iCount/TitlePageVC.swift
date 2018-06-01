//
//  TitlePageVC.swift
//  iCount
//
//  Created by Sadie Flick on 5/29/18.
//  Copyright © 2018 Sadie Flick. All rights reserved.
//

import UIKit

class TitlePageVC: UIViewController {
    
    @IBOutlet weak var iCountImageView: UIImageView!
    var countImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sunset.jpeg")!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        
        var imageArray : [UIImage] = []
        
        for imageCount in 0..<total {
            let imageName = "\(imagePrefix)-\(imageCount).jpg"
            let image = UIImage(named: imageName)!
            
            imageArray.append(image)
        }
        
        return imageArray
    }
    
    func animate(imageView: UIImageView, image: [UIImage]) {
        imageView.animationImages = countImages
        imageView.animationDuration = 10.0
        imageView.animationRepeatCount = 4
        imageView.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        countImages = createImageArray(total: 5, imagePrefix: "count")
        animate(imageView: iCountImageView, image: countImages)
    }


}
