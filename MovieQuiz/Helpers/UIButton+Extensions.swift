//
//  UIButton+Extensions.swift
//  MovieQuiz
//
//  Created by Алина on 20.11.2024.
//
import UIKit

extension UIButton {
    
    func applyStyleButtonsActiveSmall(title: String?, colorTitle: UIColor, nameFontTitle: String?, sizeTitle: CGFloat, alignText: NSTextAlignment, heighButton: CGFloat, backgroundColor: UIColor, radius: CGFloat){
        guard let title = title else { return }
        guard let nameFontTitle = nameFontTitle else { return }
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: nameFontTitle, size: sizeTitle)
        self.setTitleColor(colorTitle, for: .normal)
        self.frame.size.height = heighButton
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
        
        self.titleLabel?.textAlignment = alignText
        
    }
}

