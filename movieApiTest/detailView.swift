//
//  detailView.swift
//  movieAssignment
//
//  Created by Animesh Mohanty on 25/05/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
import UIKit
class detailView:UIView{
    
    @IBOutlet weak var testView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var topConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var overView: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemYellow
        
        Bundle.main.loadNibNamed("View", owner: self, options: nil)
        addSubview(testView)
        testView.frame = self.bounds
        popupView.layer.cornerRadius = 5
        testView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        topConstarint.constant = 2000
    }
    func animateIn() {

        
        UIView.animate(withDuration: 0.3 / 1.5, animations: {
            self.popupView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
//            self.topConstarint.constant = 300
        }) { finished in
            UIView.animate(withDuration: 0.3 / 2, animations: {
                self.popupView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }) { finished in
                UIView.animate(withDuration: 0.3 / 2, animations: {
                    self.popupView.transform = CGAffineTransform.identity
                })
            }
        }
        
        
        
        
        
       }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
