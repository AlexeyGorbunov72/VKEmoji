//
//  EmojiCollectionViewCell.swift
//  VKEmoji
//
//  Created by Alexey on 18.09.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var subEmoji: UILabel!
    @IBOutlet weak var mainEmoji: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subVeiw: UIView!
    private var titleRaw = ""
    var delegateSelect: SelectEmoji?
    func setUp(subEmoji: EmojiPolicy, mainEmoji: String, title: String){
        self.subEmoji.text = subEmoji.emoji
        self.mainEmoji.text = mainEmoji
        self.title.text = title
        titleRaw = title
        subVeiw.layer.cornerRadius = subVeiw.bounds.height / 2
        mainView.layer.cornerRadius = mainView.bounds.height / 2
        mainView.layer.borderWidth = 1
        subVeiw.layer.borderWidth = 1
        mainView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.14)
        subVeiw.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.05)
        subVeiw.layer.masksToBounds = false
        subVeiw.layer.shadowColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.08)
        subVeiw.layer.shadowOpacity = 1
        subVeiw.layer.shadowRadius = 1
        subVeiw.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.contentView.layer.masksToBounds = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnMe(_:)))
        self.contentView.addGestureRecognizer(tapGestureRecognizer)

    }
    @objc func tapOnMe(_ sender: UITapGestureRecognizer){
        delegateSelect?.didSelectEmojiBottom(title: titleRaw)
    }
    
}
