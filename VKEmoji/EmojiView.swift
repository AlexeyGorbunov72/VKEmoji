//
//  EmojiView.swift
//  VKEmoji
//
//  Created by Alexey on 18.09.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import UIKit
enum TypeEmojiView: Int, CaseIterable{
    case large = 4
    case medium = 3
    case tiny = 2
    case point = 1
    
    
}
class EmojiView: UIView{
    
    var emoji : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var title : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    init(type: TypeEmojiView, frame: CGRect, emoji: String, title: String = ""){
        super.init(frame: frame)
        self.title.text = title
        self.emoji.text = emoji
        
        self.frame = frame
        self.addSubview(self.emoji)
        switch type {
        case .large:
            self.title.font = UIFont.boldSystemFont(ofSize: 16)
            self.emoji.font = UIFont.systemFont(ofSize: 60)
            self.addSubview(self.title)
            NSLayoutConstraint.activate([
                self.emoji.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
                self.emoji.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.title.topAnchor.constraint(equalTo: self.emoji.bottomAnchor, constant: 8),
                self.title.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
            break
        case .medium:
            
            self.emoji.font = UIFont.systemFont(ofSize: 36)
            self.title.font = UIFont.boldSystemFont(ofSize: 13)
            self.addSubview(self.title)
            NSLayoutConstraint.activate([
                self.emoji.topAnchor.constraint(equalTo: self.topAnchor, constant: 23),
                self.emoji.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.title.topAnchor.constraint(equalTo: self.emoji.bottomAnchor, constant: 1),
                self.title.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
            break
        case .tiny:
            self.emoji.font = UIFont.systemFont(ofSize: 40)
            NSLayoutConstraint.activate([
                self.emoji.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.emoji.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            break
        case .point:
            self.emoji.font = UIFont.systemFont(ofSize: 28)
            NSLayoutConstraint.activate([
                self.emoji.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.emoji.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            break
        }
        
        self.layer.cornerRadius = self.bounds.height / 2
        
        self.backgroundColor = .white
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.12)
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
