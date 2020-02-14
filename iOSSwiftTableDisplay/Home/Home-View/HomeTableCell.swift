
//
//  HomeTableCell.swift
//  iOSSwiftTableDisplay
//
//  Created by Ravindran Esakkimuthu on 12/02/20.
//  Copyright © 2020 Ravindran Esakkimuthu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HomeTableCell: UITableViewCell{
    
    var row:TableRows? {
        didSet {
            guard let rowItem = row else {return}
            
            if let title = rowItem.title {
                
                self.titleLabel.text = "\(title)"
            }
            if let description = rowItem.description {
                self.descriptionLabel.text = "\(description)"
            }
            //Alamofire for Image Download
            if let imageFile = rowItem.imageHref {
                //Image loading
                AF.request(imageFile).responseData { (response) in
                    if response.error == nil {
                        if let data = response.data {
                            DispatchQueue.main.async { [weak self] in
                                self?.cellImageView.image = UIImage(data: data)
                            }
                        }
                        else{
                            print ("Image Data Response error")
                        }
                    }
                    else{
                        print ("Image File Response error")
                    }
                }
            }
            //For GCD approach
            //            if let imageFile = rowItem.imageHref {
            //                let fileURL = URL(string: "\(imageFile)")
            //                self.loadImage(url: fileURL!)
            //            }
        }
    }
    //GCD for Image Download
    /*func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.cellImageView.image = image
                    }
                }
            }
        }
    }*/
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       //Initialize custom cell
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        containerView.addSubview(cellImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        self.contentView.addSubview(containerView)
        self.activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //Cell Image
    let cellImageView:UIImageView = {
        let imageObj = UIImageView()
        imageObj.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        imageObj.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        imageObj.layer.cornerRadius = 10
        imageObj.clipsToBounds = true
        imageObj.tag = tagCellImage
        
        return imageObj
    }()
    //Cell Title
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor =  .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.tag = tagCellTitle
        return label
    }()
    
    //Cell detail
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor =  .black
        label.backgroundColor =  .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.tag = tagCellDescription
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        view.tag = tagCellContainer
        return view
    }()
    
    //Activate required object constraint
    func activateConstraints(){
        
        let marginGuide = contentView.layoutMarginsGuide
        
        containerView.centerYAnchor.constraint(equalTo:marginGuide.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:marginGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo:marginGuide.trailingAnchor, constant:-10).isActive = true
        
        cellImageView.topAnchor.constraint(equalTo:containerView.topAnchor).isActive = true
        cellImageView.leadingAnchor.constraint(equalTo:marginGuide.leadingAnchor).isActive = true
        cellImageView.widthAnchor.constraint(equalToConstant:90).isActive = true
        cellImageView.heightAnchor.constraint(equalToConstant:90).isActive = true
        titleLabel.topAnchor.constraint(equalTo:self.cellImageView.bottomAnchor).isActive = true
        //
        titleLabel.leadingAnchor.constraint(equalTo:marginGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:marginGuide.trailingAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo:marginGuide.leadingAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo:marginGuide.bottomAnchor).isActive = true
        
        
        var allConstraints: [NSLayoutConstraint] = []
        let imageHConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[imageData]",
            metrics: nil,
            views:  ["imageData": self.cellImageView])
        allConstraints += imageHConstraint
        
        let labelConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[bodyLabel]-10-|",
            metrics: nil,
            views:  ["bodyLabel": self.titleLabel])
        allConstraints += labelConstraint
        
        let detailLabelConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[detailLabel]-10-|",
            metrics: nil,
            views:  ["detailLabel": self.descriptionLabel])
        allConstraints += detailLabelConstraint
        
        let labelsConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[imageData]-5-[bodyLabel]-[detailLabel]-5-|",
            metrics: nil,
            views:  ["imageData":self.cellImageView,"bodyLabel": self.titleLabel, "detailLabel": self.descriptionLabel])
    
        allConstraints += labelsConstraint
        
        NSLayoutConstraint.activate(allConstraints)
    }
}

