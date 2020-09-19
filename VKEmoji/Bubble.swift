//
//  Bubble.swift
//  VKEmoji
//
//  Created by Alexey on 18.09.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//
import MapKit
struct Bubble: Equatable{
    static func == (lhs: Bubble, rhs: Bubble) -> Bool {
        return lhs.title == rhs.title
    }
    
    var idOfBubble: Int
    var title: String
    var type: TypeEmojiView
    var emoji: String
    var location = CLLocationCoordinate2DMake(228, 13)
    var metaEmoji: EmojiPolicy
    var pic: String
}

struct MetaEmoji{
    
}
enum EmojiPolicy{
    case low
    case positive
    case energy
    case negative
    var emoji: String {
        switch self {
        case .low:      return "😴"
        case .positive: return "😃"
        case .energy:   return "😜"
        case .negative: return "🙁"
        }
    }
}
