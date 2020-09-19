//
//  EmojiMapViewController.swift
//  VKEmoji
//
//  Created by Alexey on 18.09.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Differ
import Combine
protocol SelectBubble{
    func didSelectBubble(bubble: Bubble)
}
protocol SelectEmoji {
    func didSelectEmojiBottom(title: String)
}
class CustomAnnotation: NSObject, MKAnnotation
{
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var bubble: Bubble
    required init(bubble: Bubble)
    {
        coordinate = bubble.location
        self.bubble = bubble
    }
}
final class LocationAnnotationView: MKAnnotationView{

    private var owner: SelectBubble?
    var bubble: Bubble?
    required init(annotation: MKAnnotation?, reuseIdentifier: String?, owner: SelectBubble, bubble: Bubble) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        self.owner = owner
        self.bubble = bubble
        setupUI(type: bubble.type, title: bubble.title, emoji: bubble.emoji)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(type: TypeEmojiView, title: String = "", emoji: String) {
        var _title = title
        switch type {
        case .large:
            self.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
            
            break
        case .medium:
            self.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            
            break
        case .tiny:
            _title = ""
            self.frame = CGRect(x: 0, y: 0, width: 88, height: 88)
            
            break
        case .point:
            _title = ""
            self.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
            break
        }
        
        let view = EmojiView(type: type, frame: self.frame, emoji: emoji, title: _title)
        let tapGestoreRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnMe(_ : )))
        view.addGestureRecognizer(tapGestoreRecognizer)
        addSubview(view)
    }
    @objc func tapOnMe(_ gestue: UITapGestureRecognizer){
        owner?.didSelectBubble(bubble: bubble!)
    }
}
struct BottomEmojiCollection {
    var mainEmoji: String
    var subEmoji: String
    var title: String
}
class EmojiMapViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var topEmojiLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var emojiSearchBar: UISearchBar!
    
    let bottomEmojies = [BottomEmojiCollection(mainEmoji: "🎧", subEmoji: "😃", title: "Музыка"),
                         BottomEmojiCollection(mainEmoji: "🍿", subEmoji: "😃", title: "Фильмы"),
                         BottomEmojiCollection(mainEmoji: "🍂", subEmoji: "😌", title: "Осень"),
                         BottomEmojiCollection(mainEmoji: "👔", subEmoji: "😜", title: "Работа"),
                         BottomEmojiCollection(mainEmoji: "😷", subEmoji: "😐", title: "Карантин")]
    var bubbles: [Bubble] = []
    var setOfEmojies = [
        ["emoji" : "💻", "title" : "IT", "metaEmoji": EmojiPolicy.energy, "pic": "it"],
        ["emoji" : "📷", "title" : "Фото", "metaEmoji": EmojiPolicy.low, "pic": "photo"],
        ["emoji" : "🚗", "title" : "Пробка", "metaEmoji": EmojiPolicy.negative, "pic": "car"],
        ["emoji" : "🎧️", "title" : "Музыка", "metaEmoji": EmojiPolicy.energy, "pic": "music"],
        ["emoji" : "🍿", "title" : "Кино", "metaEmoji": EmojiPolicy.positive, "pic": "cinima"],
        ["emoji" : "🍷", "title" : "Ресторан", "metaEmoji": EmojiPolicy.positive, "pic": "res"],
        ["emoji" : "👔", "title" : "Работа", "metaEmoji": EmojiPolicy.energy, "pic": "work"],
        ["emoji" : "😷", "title" : "Карантин", "metaEmoji": EmojiPolicy.negative, "pic": "mask"],
        ["emoji" : "🍂", "title" : "Осень", "metaEmoji": EmojiPolicy.low, "pic": "atumn"]]
    var setClass: [Bubble] = []
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setOfEmojies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCollectionViewCell
        let data = setClass[indexPath.row]
        cell.setUp(subEmoji: data.metaEmoji, mainEmoji: data.emoji, title: data.title)
        cell.delegateSelect = self
        return cell
    }
    @Published var centerMapLocation: CLLocationCoordinate2D?
    var subscriber: AnyCancellable?
    @IBOutlet weak var buttomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var EmojiMap: MKMapView!
    @IBOutlet weak var emojiCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriber = AnyCancellable($centerMapLocation
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .sink(){[unowned self] _ in
                
                let visibles = self.EmojiMap.visibleAnnotations()
                
                if visibles.count > 0{
                    var dict: [EmojiPolicy: Int] = [
                        .energy: 0,
                        .low: 0,
                        .negative: 0,
                        .positive: 0]
                    for visible in visibles{
                        print(visible.bubble.type.rawValue)
                        dict[visible.bubble.metaEmoji]! += visible.bubble.type.rawValue
                    }
                    let maxPolicyEmoji = dict.max { a, b in a.value < b.value }
                    let emoji = maxPolicyEmoji?.key.emoji
                    var moodText = ""
                    switch maxPolicyEmoji?.key{
                        case .energy:
                            moodText = "Безумное настроение"
                            break
                        case .low:
                            moodText = "Спокойное настроение"
                            break
                        case .negative:
                            moodText = "Плохое настроение"
                            break
                        case .positive:
                            moodText = "Веселое настроение"
                            break
                        case .none:
                            break
                    }
                    self.appearTopView(emoji: emoji!, moodText: moodText)
                    
                } else {
                    self.hideTopView()
                }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        for elm in setOfEmojies{
            setClass.append(Bubble(idOfBubble: 0, title: elm["title"] as! String, type: TypeEmojiView.medium, emoji: elm["emoji"] as! String, location: CLLocationCoordinate2DMake(0, 0), metaEmoji: elm["metaEmoji"] as! EmojiPolicy, pic: elm["pic"] as! String))
        }
        emojiSearchBar.delegate = self
        topView.layer.cornerRadius = 10
        topView.layer.masksToBounds = false
        topView.layer.shadowRadius = 2
        topView.layer.shadowOpacity = 1
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.08)
        generateBubbles()
        emojiCollection.showsHorizontalScrollIndicator = false
        emojiCollection.delegate = self
        emojiCollection.dataSource = self
        bottomView.layer.shadowOpacity = 1
        bottomView.layer.shadowColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.08)
        bottomView.layer.shadowRadius = 1
        bottomView.layer.masksToBounds = false
        EmojiMap.delegate = self
        let location = CLLocationCoordinate2DMake(59.9394619, 30.3146286)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        EmojiMap.setRegion(region, animated: true)
            
        EmojiMap.register(LocationAnnotationView.self, forAnnotationViewWithReuseIdentifier: "bubble")
        
        addCustomAnnotation()
        self.mapViewDidChangeVisibleRegion(EmojiMap)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @objc func keyboardWillShow(_ notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        self.buttomConstraint.constant = keyboardSize.cgRectValue.height - 20
        UIView.transition(with: view, duration: 0.3, options: .curveEaseIn, animations: { [unowned self] in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @objc func keyboardWillHide(_ notification: Notification){
        self.buttomConstraint.constant = 0
        UIView.transition(with: view, duration: 0.3, options: .curveEaseIn, animations: { [unowned self] in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            centerMapLocation = mapView.centerCoordinate
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        if let annotation = annotation as? CustomAnnotation{
            let annotationView = LocationAnnotationView(annotation: annotation, reuseIdentifier: "bubble", owner: self as SelectBubble, bubble: annotation.bubble)
            return annotationView
        }
        
        
        return nil
    }
    func addCustomAnnotation() {
        
        var pins: [CustomAnnotation] = []
        for bubble in bubbles{
            pins.append(CustomAnnotation(bubble: bubble))
        }
        self.EmojiMap.addAnnotations(pins)
    }
    private func hideTopView(){
        self.topViewConstraint.constant = -300
        UIView.transition(with: self.topView, duration: 0.5, options: .curveEaseIn, animations: { [unowned self] in
                self.view.layoutIfNeeded()
                }, completion: nil)
    }
    private func appearTopView(emoji: String, moodText: String){
        if self.topViewConstraint.constant == 0{
            self.reloadTopView(emoji: emoji, moodText: moodText)
            return
        }
        self.topViewConstraint.constant = 0
        UIView.transition(with: self.topView, duration: 0.5, options: .curveEaseIn, animations: { [unowned self] in
                self.view.layoutIfNeeded()
                }, completion: nil)
    }
    private func reloadTopView(emoji: String, moodText: String){
        DispatchQueue.main.async { [unowned self] in
            
            UIView.transition(with: self.topView, duration: 0.3, options: .curveEaseIn, animations: {
                self.topLabel.text = moodText
                self.topEmojiLabel.text = emoji
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    private func sortDataAnimate(title: String){
        let new = setClass.sorted {
            return compare(lht: $0.title.lowercased(), rht: $1.title.lowercased(), title: title.lowercased())
        }
        emojiCollection.animateItemChanges(oldData: self.setClass, newData: new, updateData: { self.setClass = new})
    }
    private func compare(lht: String, rht: String, title: String) -> Bool{
        var leftCounter = 0
        var rightCounter = 0
        for c in lht{
            for cs in title{
                if c == cs{
                    leftCounter += 1
                }
            }
        }
        for c in rht{
            for cs in title{
                if c == cs{
                    rightCounter += 1
                }
            }
        }
        return leftCounter > rightCounter
    }
    private func generateBubbles(){
        let latitude    = 59.938879
        let longitude   = 30.315212
        let max = 0.26
        let min = -0.16
        
        for i in 0...100{
            let bubbleLatitude = latitude + Double.random(in: min...max)
            let bubbleLongitude = longitude + Double.random(in: min...max)
            let emojiPack = setOfEmojies.randomElement()!
            let bubble = Bubble(idOfBubble: i,
                                title: emojiPack["title"] as! String,
                                type: TypeEmojiView.allCases.randomElement()!,
                                emoji: emojiPack["emoji"] as! String,
                                location: CLLocationCoordinate2DMake(bubbleLatitude, bubbleLongitude), metaEmoji: emojiPack["metaEmoji"] as! EmojiPolicy,
                                pic: emojiPack["pic"] as! String)
            bubbles.append(bubble)
        }
    }
    
}
extension EmojiMapViewController: SelectBubble{
    func didSelectBubble(bubble: Bubble) {
        let vc = (storyboard?.instantiateViewController(identifier: "dude"))! as PresentDudeViewController
        vc.setData(bubble: bubble)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
extension MKMapView {
    func visibleAnnotations() -> [CustomAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> CustomAnnotation in return obj as! CustomAnnotation }
    }
}

extension EmojiMapViewController: SelectEmoji{
    func didSelectEmojiBottom(title: String) {
        for bubble in bubbles{
            if bubble.title == title{
                let region = MKCoordinateRegion(center: bubble.location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                EmojiMap.setRegion(region, animated: true)
            }
        }
    }
}

extension EmojiMapViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        sortDataAnimate(title: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        view.endEditing(true)
        
    }
    
}

