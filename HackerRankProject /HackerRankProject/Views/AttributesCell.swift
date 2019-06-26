//
//  AttributesCell.swift
//  HackerRankProject
//
//  Created by HARISH V V on 6/24/19.
//  Copyright © 2019 Company. All rights reserved.
//

import UIKit

class AttributesCell: UITableViewCell {
    
    var row : Row? {
        didSet {
            rowTitle.text = row?.title
            rowDescription.text = row?.description
        }
    }
    
    private let rowTitle : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let rowDescription : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    public let rowImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.rowImage)
        self.addSubview(self.rowTitle)
        self.addSubview(self.rowDescription)
        
        //set min height for cell
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(CONSTANTS_STRUCT.CELL_HEIGHT)).isActive = true
        
        //set constraints for cell elements
        self.rowImage.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 90, enableInsets: false)
        self.rowTitle.anchor(top: self.topAnchor, left: self.rowImage.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0 , height: 0, enableInsets: false)
        self.rowDescription.anchor(top: self.rowTitle.bottomAnchor, left: self.rowImage.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 20, paddingRight: 10, width: 0 , height: 0, enableInsets: false)
    }
    
    override func prepareForReuse() {
        self.rowImage.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
