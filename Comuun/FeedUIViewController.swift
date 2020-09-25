//
//  FeedUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/02.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//FeedUIViewController内で使うもののうちclass内に定義できないもの
//フィードに来る投稿
let feed1 = post1
let feed2 = post2
let feed3 = post3
//フィードに来る投稿をまとめる
let feeds = [ feed1, feed2, feed3 ]



class FeedUIViewController: UIViewController {
    //フィードのスクロールビューの高さを変数で置く
    var feedScrollViewHeight:CGFloat = 30
    //フィードのカードのy座標を変数で置く
    var feedCardYcoord:CGFloat = 20
    //イメージビュー（メインヘッダーを表示するための領域）を設定
    let mainHeaderRect:UIImageView = {
        let imageView = UIImageView(image:rectOfMainHeader)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowOpacity = 0.16
        return imageView
    }()
    //メインヘッダーの画像を生成
    let comuunGrayIcon:UIImageView = {
        let image = UIImage(named: "comuunGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 15, y: 32.5, width: 23.9, height: 25)
        return imageView
    }()
    let stockPinkIcon:UIImageView = {
        let image = UIImage(named: "stockPink")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth/2-15.9, y: 30, width: 31.8, height: 30)
        return imageView
    }()
    //透明なボタンを作成するメソッド
    func makeMoveToTimelineButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(FeedUIViewController.moveToTimeline(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //ボタンで実行するメソッド
    @objc func moveToTimeline(_ sender:UIButton) {
        self.navigationController?.popToViewController(navigationController!.viewControllers[2], animated: true)
        
    }
    //イメージビュー（StockヘッダーLeftを表示するための領域）を設定
    let leftStockHeaderRect:UIImageView = {
        let imageView = UIImageView(image:rectOfStockHeader)
        imageView.frame.origin = CGPoint(x: 0, y: 70)
        return imageView
    }()
    //StockヘッダーLeftのピックアップのラベルを設定
    let leftStockHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: screenWidth/2, height: 15)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .center
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"ピックアップ", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //イメージビュー（StockヘッダーRightを表示するための領域）を設定
    let rightStockHeaderRect:UIImageView = {
        let imageView = UIImageView(image:rectOfStockHeader)
        imageView.frame.origin = CGPoint(x: screenWidth/2, y: 70)
        return imageView
    }()
    //フィードの題名をUILabelで設定
    let rightStockHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: screenWidth/2, height: 15)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .center
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:mainColor,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"フィード", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //イメージビュー（StockヘッダーLeftとRightの分割線）を設定
    let stockHeaderPartline:UIImageView = {
        let imageView = UIImageView(image:partlineOfStockHeader)
        return imageView
    }()
    //イメージビュー（StockヘッダーLeftとRightの下線）を設定
    let stockHeaderUnderline:UIImageView = {
        let imageView = UIImageView(image:underlineOfStockHeader)
        return imageView
    }()
    //透明なボタンを作成するメソッド
    func makeMoveToPickupButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 70, width: screenWidth/2, height: 45)
        button.addTarget(self, action: #selector(FeedUIViewController.moveToPickup(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //ボタンで実行するメソッド
    @objc func moveToPickup(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    //スクロールビューを設定
    var feedScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 115, width: screenWidth, height: screenHeight-115)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = basicBgColor
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景色を指定
        self.view.backgroundColor = basicBgColor
        // ヘッダーの領域を表示
        self.view.addSubview(mainHeaderRect)
        //ヘッダーのサイドアイコンを表示
        mainHeaderRect.addSubview(comuunGrayIcon)
        mainHeaderRect.addSubview(stockPinkIcon)
        //ヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let moveToTimelineButton = makeMoveToTimelineButton()
        self.view.addSubview(moveToTimelineButton)
        //ヘッダーLRの領域を表示
        self.view.addSubview(leftStockHeaderRect)
        self.view.addSubview(rightStockHeaderRect)
        //ヘッダーLRの間の線を表示
        self.view.addSubview(stockHeaderPartline)
        //ヘッダーLRの下線を表示
        self.view.addSubview(stockHeaderUnderline)
        //ヘッダーLRの題名を表示
        leftStockHeaderLabel.frame.origin = CGPoint(x:leftStockHeaderRect.bounds.width/2-screenWidth/4, y:leftStockHeaderRect.bounds.height/2-22.5)
        leftStockHeaderRect.addSubview(leftStockHeaderLabel)
        rightStockHeaderLabel.frame.origin = CGPoint(x:rightStockHeaderRect.bounds.width/2-screenWidth/4, y:rightStockHeaderRect.bounds.height/2-22.5)
        rightStockHeaderRect.addSubview(rightStockHeaderLabel)
        //ヘッダーLにボタンを設置
        let moveToPickupButton = makeMoveToPickupButton()
        self.view.addSubview(moveToPickupButton)
        //スクロールビューを配置
        view.addSubview(feedScrollView)
        //初期値を指定しない配列（フィードの領域etcのため）を用意しておき、for文の中でフィードの要素の数に応じて、設定・配置をしていく
        var feedCardShadowRects = [String:UIImageView]()//イメージビュー（カードの影）
        var feedCardRects = [String:UIImageView]()//イメージビュー（カードの領域）
        var feedOrgNames = [UILabel]()//団体名
        var feedPersonalNames = [UILabel]()//投稿者名
        var feedDeadlines = [String:UILabel]()//回答期限
        var feedNumOfRes = [String:UILabel]()//回答数
        var feedMultipleChoices = [String:UILabel]()//複数選択か単一選択か
        var feedTitles = [UILabel]()//題名
        var feedContents = [UILabel]()//内容
        //for文を記入
        for i in 1...feeds.count {
            //フィードのカードを表示するための領域を作成
            let rectOfFeedCardShadow = makeClearRect(width: screenWidth-30, height: 100)
            let rectOfFeedCard = makeWhiteRect(width: screenWidth-30, height: 100)
            //イメージビュー（コンテンツの影を表示するための領域）
            let feedCardShadowRect:UIImageView = {
                let imageView = UIImageView(image:rectOfFeedCardShadow)
                imageView.layer.masksToBounds = false
                imageView.layer.shadowOpacity = 0.16
                return imageView
            }()
            feedCardShadowRects["\(i-1)"] = feedCardShadowRect
            feedScrollView.addSubview(feedCardShadowRects["\(i-1)"]!)
            //イメージビュー（コンテンツを表示するための領域）
            let feedCardRect:UIImageView = {
                let imageView = UIImageView(image:rectOfFeedCard)
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 10
                return imageView
            }()
            feedCardRects["\(i-1)"] = feedCardRect
            feedCardShadowRects["\(i-1)"]!.addSubview(feedCardRects["\(i-1)"]!)
            //団体名
            let feedOrgName:UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: 56, y: 14, width: 150, height: 12)
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                    .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor:black
                    ]
                let labelText = NSAttributedString(string:feeds[i-1]["orgName"] as! String, attributes:labelTextAttr)
                label.attributedText = labelText
                return label
            }()
            feedOrgNames.append(feedOrgName)
            feedCardRects["\(i-1)"]!.addSubview(feedOrgNames[i-1])
            //投稿者名
            let feedPersonalName:UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: 56, y: 32, width: 160, height: 10)
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
                .foregroundColor:gray
                ]
                let labelText = NSAttributedString(string:feeds[i-1]["personalName"] as! String, attributes:labelTextAttr)
                label.attributedText = labelText
                return label
            }()
            feedPersonalNames.append(feedPersonalName)
            feedCardRects["\(i-1)"]!.addSubview(feedPersonalNames[i-1])
            //回答期限
            if let string = feeds[i-1]["deadline"] as? String {
                let feedDeadline:UILabel = {
                    let label = UILabel()
                    label.frame = CGRect(x: feedCardRects["\(i-1)"]!.bounds.width-80, y: 10, width: 70, height: 8)
                    let labelPar = NSMutableParagraphStyle()
                    labelPar.alignment = .right
                    let labelTextAttr: [NSAttributedStringKey : Any] = [
                        .font:UIFont(name:"HiraKakuProN-W3", size: 8) ?? UIFont.systemFont(ofSize: 8),
                        .foregroundColor:gray,
                        .paragraphStyle:labelPar
                    ]
                    let labelText = NSAttributedString(string:"期限：\(string)", attributes:labelTextAttr)
                    label.attributedText = labelText
                    return label
                }()
                feedDeadlines["\(i-1)"] = feedDeadline
                feedCardRects["\(i-1)"]!.addSubview(feedDeadlines["\(i-1)"]!)
            }
            //回答数
            if let int = feeds[i-1]["numOfRe"] as? Int {
                let feedNumOfRe:UILabel = {
                    let label = UILabel()
                    label.frame = CGRect(x: feedCardRects["\(i-1)"]!.bounds.width-80, y: 23, width: 70, height: 8)
                    let labelPar = NSMutableParagraphStyle()
                    labelPar.alignment = .right
                    let labelTextAttr: [NSAttributedStringKey : Any] = [
                        .font:UIFont(name:"HiraKakuProN-W3", size: 8) ?? UIFont.systemFont(ofSize: 8),
                        .foregroundColor:gray,
                        .paragraphStyle:labelPar
                    ]
                    let labelText = NSAttributedString(string:"回答数：\(int)", attributes:labelTextAttr)
                    label.attributedText = labelText
                    return label
            }()
            feedNumOfRes["\(i-1)"] = feedNumOfRe
            feedCardRects["\(i-1)"]!.addSubview(feedNumOfRes["\(i-1)"]!)
            }
            //複数選択か単一選択か
            if let bool = feeds[i-1]["multipleChoice"] as? Bool {
                let feedMultipleChoice:UILabel = {
                    let label = UILabel()
                    label.frame = CGRect(x: feedCardRects["\(i-1)"]!.bounds.width-80, y: 36, width: 70, height: 8)
                    let labelPar = NSMutableParagraphStyle()
                    labelPar.alignment = .right
                    let labelTextAttr: [NSAttributedStringKey : Any] = [
                        .font:UIFont(name:"HiraKakuProN-W6", size: 8) ?? UIFont.boldSystemFont(ofSize: 8),
                        .foregroundColor:mainColor,
                        .paragraphStyle:labelPar
                    ]
                    if bool {
                        let labelText = NSAttributedString(string:"複数選択できます", attributes:labelTextAttr)
                        label.attributedText = labelText
                        return label
                    } else {
                        let labelText = NSAttributedString(string:"単一選択です", attributes:labelTextAttr)
                        label.attributedText = labelText
                        return label
                    }
                }()
                feedMultipleChoices["\(i-1)"] = feedMultipleChoice
                feedCardRects["\(i-1)"]!.addSubview(feedMultipleChoices["\(i-1)"]!)
            }
            //投稿の種類に応じた領域を設置する
            var feedAttachedRect = UIImageView(image: rectOfNone)
            if let attached = feeds[i-1]["attached"] as? Attached {
                switch attached {
                case .image:
                    feedAttachedRect = UIImageView(image: rectOfImage)
                case .tripleChoice:
                    feedAttachedRect = UIImageView(image: rectOfTripleChoice)
                case .questionnaire2:
                    feedAttachedRect = UIImageView(image: rectOfQuestionnaire2)
                case .questionnaire3:
                    feedAttachedRect = UIImageView(image: rectOfQuestionnaire3)
                case .questionnaire4:
                    feedAttachedRect = UIImageView(image: rectOfQuestionnaire4)
                case .questionnaire5:
                    feedAttachedRect = UIImageView(image: rectOfQuestionnaire5)
                case .questionnaire6:
                    feedAttachedRect = UIImageView(image: rectOfQuestionnaire6)
                case .questionnaire7:
                    feedAttachedRect = UIImageView(image: rectOfQuestionnaire7)
                case .questionnaire8:
                    feedAttachedRect = UIImageView(image: rectOfQuestionnaire8)
                case .questionnaire9:
                    feedAttachedRect = UIImageView(image: rectOfQuestionnaire9)
                }
            }
            feedAttachedRect.frame.origin = CGPoint(x: 0, y: 54)
            feedCardRects["\(i-1)"]!.addSubview(feedAttachedRect)
            //題名
            let feedTitle:UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: 10, y: feedAttachedRect.bounds.height+64, width: screenWidth-50, height: 12)
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                    .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor:black
                ]
                let labelText = NSAttributedString(string:feeds[i-1]["title"] as! String, attributes:labelTextAttr)
                label.attributedText = labelText
                return label
            }()
            feedTitles.append(feedTitle)
            feedCardRects["\(i-1)"]!.addSubview(feedTitles[i-1])
            //内容
            let feedContent:UILabel = {
                let label = UILabel()
                label.numberOfLines = 0
                let labelPar = NSMutableParagraphStyle()
                labelPar.lineSpacing = 20.0
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                    .font:UIFont(name:"HiraKakuProN-W3", size: 12) ?? UIFont.systemFont(ofSize: 12),
                    .foregroundColor:black,
                    .paragraphStyle:labelPar
                ]
                let labelText = NSAttributedString(string:feeds[i-1]["content"] as! String, attributes:labelTextAttr)
                label.attributedText = labelText
                //内容を表示するUILabelの高さを文量に応じて調整
                let labelSize = label.sizeThatFits(CGSize(width:screenWidth-50, height:0))
                label.frame = CGRect(x: 10, y: feedAttachedRect.bounds.height+86, width:screenWidth-50, height:labelSize.height)
                return label
            }()
            feedContents.append(feedContent)
            feedCardRects["\(i-1)"]!.addSubview(feedContents[i-1])
            //フィードのカードの高さを変数で置く
            var feedCardHeight:CGFloat = 106
            //フィードのカードの高さを調整
            feedCardHeight += feedAttachedRect.bounds.height + feedContents[i-1].frame.height
            //フィードのカードのy座標を調整
            feedCardYcoord += 10
            if i != 1 {
                feedCardYcoord += feedCardRects["\(i-2)"]!.bounds.height
            }
            //調整後のフィードのカードの影のframeを指定
            feedCardShadowRect.frame = CGRect(x:15, y:feedCardYcoord, width:screenWidth-30, height:feedCardHeight)
            //調整後のフィードのカードのframeを指定
            feedCardRect.frame = CGRect(x:0, y:0, width:screenWidth-30, height:feedCardHeight)
            //スクロールビューの高さを調整
            feedScrollViewHeight += feedCardHeight + 10
            //調整した高さを元にスクロールビューのサイズを指定
            feedScrollView.contentSize = CGSize(width: screenWidth-30, height: feedScrollViewHeight)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
