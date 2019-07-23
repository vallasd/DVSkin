//
//  FlickrPhotoVC.swift
//  PhotoApp
//
//  Created by David Vallas on 5/6/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import UIKit
import Kingfisher

public class PersonVC: UIViewController {
    
    var person: Person? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func moreButton(_ sender: UIButton) {
        print("TODO: Need to Display Web Page")
        if person?.url == "" { return }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        // check if person is set, if not, return
        guard let p = person else { return }
        
        // update image
        imageView.kf.setImage(with: p.imageURL, placeholder: nil, options: nil, progressBlock: nil) { [weak self] (result) in
            switch result {
            case .success(_): break
            case .failure(_): self?.imageView.image = UIImage(named: "nophoto")
            }
        }
        
        // update description
        descriptionTextView.text = p.description
        
        // update label sizes
        descriptionTextView.sizeToFit()
    }
}
