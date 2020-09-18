//
//  PresentDudeViewController.swift
//  VKEmoji
//
//  Created by Alexey on 18.09.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import UIKit

class PresentDudeViewController: UIViewController {

    @IBOutlet weak var aDude: UIImageView!
    @IBOutlet weak var imageOfDude: UIImageView!
    @IBOutlet weak var labelWithStatusMoodDude: UILabel!
    private var bubble: Bubble?
    override func viewDidLoad() {
        super.viewDidLoad()
        aDude.layer.cornerRadius = aDude.bounds.height / 2
        switch bubble?.metaEmoji {
        case .energy:
            labelWithStatusMoodDude.text! += "настроение безумное \(bubble!.metaEmoji.emoji)"
            break
        case .low:
            labelWithStatusMoodDude.text! += "настроение спокойное \(bubble!.metaEmoji.emoji)"
            break
        case .negative:
            labelWithStatusMoodDude.text! += "настроение грусное \(bubble!.metaEmoji.emoji)"
            break
        case .positive:
            labelWithStatusMoodDude.text! += "настроение веселое \(bubble!.metaEmoji.emoji)"
            break
        case .none:
            labelWithStatusMoodDude.text! += "настроение ???"
        }
        imageOfDude.image = UIImage(named: bubble!.pic)
        imageOfDude.contentMode = .scaleAspectFill
        
    }
    func setData(bubble: Bubble){
        self.bubble = bubble
    }

    

}
