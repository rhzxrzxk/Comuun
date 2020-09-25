//
//  PickupUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/05/30.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//PickupUIViewController内で使うもののうちclass内に定義できないもの
//リマインド
let remind1 = post1
let remind2 = post3
// リマインドをまとめる
let reminds = [remind1, remind2]
//未回答
let unans1 = post1
let unans2 = post3
let unans3 = post3
let unans4 = post3
// 未回答をまとめる
let unanswers = [ unans1, unans2, unans3, unans4 ]



class PickupUIViewController: UIViewController {
    //イメージビュー（メインヘッダーを表示するための領域）を設定
    let mainHeaderRect:UIImageView = {
        let imageView = UIImageView(image:rectOfMainHeader)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
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
    //メインヘッダーの透明なボタンを作成するメソッド
    func makeMoveToTimelineButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(PickupUIViewController.moveToTimeline(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //メインヘッダーのボタンで実行するメソッド
    @objc func moveToTimeline(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //イメージビュー（StockヘッダーLeftを表示するための領域）を設定
    let leftStockHeaderRect:UIImageView = {
        let imageView = UIImageView(image:rectOfStockHeader)
        imageView.frame.origin = CGPoint(x: 0, y: 70)
        return imageView
    }()
    //ピックアップの題名をUILabelで設定
    let leftStockHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: screenWidth/2, height: 15)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .center
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:mainColor,
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
            .foregroundColor:gray,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"フィード", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //イメージビュー（StockヘッダーLeftとRightの間の線）を設定
    let stockHeaderPartline:UIImageView = {
        let imageView = UIImageView(image:partlineOfStockHeader)
        return imageView
    }()
    //イメージビュー（StockヘッダーLeftとRightの下線）を設定
    let stockHeaderUnderline:UIImageView = {
        let imageView = UIImageView(image:underlineOfStockHeader)
        return imageView
    }()
    //Stockヘッダーの透明なボタンを作成するメソッド
    func makeMoveToFeedButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: screenWidth/2, y: 70, width: screenWidth/2, height: 45)
        button.addTarget(self, action: #selector(PickupUIViewController.moveToFeed(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //Stockヘッダーのボタンで実行するメソッド
    @objc func moveToFeed(_ sender:UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "Feed") as! FeedUIViewController
        self.navigationController?.pushViewController(nextVC, animated: false )
    }
    //スクロールビューを設定
    var pickupScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 115, width: screenWidth, height: screenHeight-115)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = basicBgColor
        return scrollView
    }()
    //イメージビュー（リマインドの題名を表示するための領域）を設定
    let remindHeaderRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 36)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 30)
        return imageView
    }()
    //イメージビュー（リマインドの題名の上線）を設定
    let remindHeaderOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（リマインドの題名の下線）を設定
    let remindHeaderUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:36, x1:screenWidth, y1:36)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //リマインドの題名をUILabelで設定
    let remindHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 12, width: 80, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:mainColor,
            ]
        let labelText = NSAttributedString(string:"リマインド", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //リマインドのコンテンツについてはviewDidLoad内に記入
    //イメージビュー（未回答の題名を表示するための領域）を設定
    let unansHeaderRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 36)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 96+80*reminds.count)
        return imageView
    }()
    //イメージビュー（未回答の題名の上線）を設定
    let unansHeaderOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（未回答の題名の下線）を設定
    let unansHeaderUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:36, x1:screenWidth, y1:36)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //未回答の題名をUILabelで設定
    let unansHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 12, width: 80, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:mainColor,
            ]
        let labelText = NSAttributedString(string:"未回答/未決定", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //未回答のコンテンツについてはviewDidLoad内に記入
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景色を指定
        self.view.backgroundColor = basicBgColor
        //メインヘッダーの領域を表示
        self.view.addSubview(mainHeaderRect)
        //メインヘッダーのサイドアイコンを表示
        mainHeaderRect.addSubview(comuunGrayIcon)
        mainHeaderRect.addSubview(stockPinkIcon)
        //メインヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let moveToComuunButton = makeMoveToTimelineButton()
        self.view.addSubview(moveToComuunButton)
        //stockヘッダーの領域を表示
        self.view.addSubview(leftStockHeaderRect)
        self.view.addSubview(rightStockHeaderRect)
        //stockヘッダーの左右の分割線を表示
        self.view.addSubview(stockHeaderPartline)
        //stockヘッダーの下線を表示
        self.view.addSubview(stockHeaderUnderline)
        //stockヘッダーの題名を表示
        leftStockHeaderLabel.frame.origin = CGPoint(x:leftStockHeaderRect.bounds.width/2-screenWidth/4, y:leftStockHeaderRect.bounds.height/2-22.5)
        leftStockHeaderRect.addSubview(leftStockHeaderLabel)
        rightStockHeaderLabel.frame.origin = CGPoint(x:rightStockHeaderRect.bounds.width/2-screenWidth/4, y:rightStockHeaderRect.bounds.height/2-22.5)
        rightStockHeaderRect.addSubview(rightStockHeaderLabel)
        //stockヘッダーRightにボタンを設置
        let moveToFeedButton = makeMoveToFeedButton()
        self.view.addSubview(moveToFeedButton)
        //スクロールビューを配置
        view.addSubview(pickupScrollView)
        //イメージビュー（リマインドのヘッダーを表示するための領域）を配置
        pickupScrollView.addSubview(remindHeaderRect)
        //イメージビュー（リマインドのヘッダーの上線）を配置
        remindHeaderRect.addSubview(remindHeaderOverline)
        //イメージビュー（リマインドのヘッダーの下線）を配置
        remindHeaderRect.addSubview(remindHeaderUnderline)
        //ラベル(リマインドのヘッダーの題名)を配置
        remindHeaderRect.addSubview(remindHeaderLabel)
        //初期値を指定しない配列（リマインドの領域etcのため）を用意しておき、for文の中でリマインダーの要素の数に応じて、設定・配置をしていく
        var remindRects = [UIImageView]()//領域
        var remindLabels = [UILabel]()//題名
        var remindDeadlineAlerts = [UILabel]()//"〇〇の回答期限が近づいています"
        var remindDeadlines = [UILabel]()//回答期限
        //リマインダーのためのfor文を記入
        for i in 1...reminds.count {
            //イメージビュー（コンテンツを表示するための領域）
            let remindRect:UIImageView = {
                let image = makeWhiteRect(width: screenWidth, height: 80)
                let imageView = UIImageView(image:image)
                imageView.frame.origin = CGPoint(x: 0, y: 80*i-14)
                return imageView
            }()
            remindRects.append(remindRect)
            pickupScrollView.addSubview(remindRects[i-1])
            //イメージビュー（リマインドのコンテンツの下線）
            let remindUnderline:UIImageView = {
                let drawImage = drawLine(x0:0, y0:80, x1:screenWidth, y1:80)
                let imageView = UIImageView(image: drawImage)
                return imageView
            }()
            remindRects[i-1].addSubview(remindUnderline)
           //リマインドのコンテンツの、投稿の題名
            let remindLabel:UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: 90, y: 25, width: screenWidth-105, height: 12)
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                    .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor:black,
                    ]
                let labelText = NSAttributedString(string:"\(reminds[i-1]["title"] as! String)", attributes:labelTextAttr)
                label.attributedText = labelText
                return label
            }()
            remindLabels.append(remindLabel)
            remindRects[i-1].addSubview(remindLabels[i-1])
            //リマインドのコンテンツの"〇〇の回答期限が近づいています"
            let remindDeadlineAlert:UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: 90, y: 43, width: screenWidth-105, height: 10)
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                    .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
                    .foregroundColor:gray,
                    ]
                let labelText = NSAttributedString(string:"の回答期限が近づいています", attributes:labelTextAttr)
                label.attributedText = labelText
                return label
            }()
            remindDeadlineAlerts.append(remindDeadlineAlert)
            remindRects[i-1].addSubview(remindDeadlineAlerts[i-1])
            //回答期限
            let remindDeadline:UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: screenWidth-80, y: 10, width: 70, height: 8)
                let labelTextPar = NSMutableParagraphStyle()
                labelTextPar.alignment = .right
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                    .font:UIFont(name:"HiraKakuProN-W3", size: 8) ?? UIFont.systemFont(ofSize: 8),
                    .foregroundColor:gray,
                    .paragraphStyle:labelTextPar
                ]
                let labelText = NSAttributedString(string:"期限：\(reminds[i-1]["deadline"] as! String)", attributes:labelTextAttr)
                label.attributedText = labelText
                return label
            }()
            remindDeadlines.append(remindDeadline)
            remindRects[i-1].addSubview(remindDeadlines[i-1])
        }
        
        //イメージビュー（未回答のヘッダーを表示するための領域）を配置
        pickupScrollView.addSubview(unansHeaderRect)
        //イメージビュー（未回答のヘッダーの上線）を配置
        unansHeaderRect.addSubview(unansHeaderOverline)
        //イメージビュー（未回答のヘッダーの下線）を配置
        unansHeaderRect.addSubview(unansHeaderUnderline)
        //ラベル(未回答のヘッダーの題名)を配置
        unansHeaderRect.addSubview(unansHeaderLabel)
        //初期値を指定しない配列（未回答の領域etcのため）を用意しておき、for文の中で未回答の要素の数に応じて、設定・配置をしていく
        var unansRects = [UIImageView]()//領域
        var unansLabels = [UILabel]()//題名
        var unansOrgAndPersonalNames = [UILabel]()//団体名/個人名
        var unansDeadlines = [UILabel]()//回答期限
        //未回答のためのfor文を記入
        for i in 1...unanswers.count {
            //イメージビュー（コンテンツを表示するための領域）
            let unansRect:UIImageView = {
                let image = makeWhiteRect(width: screenWidth, height: 80)
                let imageView = UIImageView(image:image)
                imageView.frame.origin = CGPoint(x: 0, y: 52+80*(i+reminds.count))
                return imageView
            }()
            unansRects.append(unansRect)
            pickupScrollView.addSubview(unansRects[i-1])
            //イメージビュー（リマインドのコンテンツの下線）
            let unansUnderline:UIImageView = {
                let drawImage = drawLine(x0:0, y0:80, x1:screenWidth, y1:80)
                let imageView = UIImageView(image: drawImage)
                return imageView
            }()
            unansRects[i-1].addSubview(unansUnderline)
            //投稿の題名
            let unansLabel:UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: 90, y: 25, width: screenWidth-105, height: 12)
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                    .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor:black,
                    ]
                let labelText = NSAttributedString(string:"\(unanswers[i-1]["title"] as! String)", attributes:labelTextAttr)
                label.attributedText = labelText
                return label
            }()
            unansLabels.append(unansLabel)
            unansRects[i-1].addSubview(unansLabels[i-1])
            //"団体名/個人名"
            let unansOrgAndPersonalName:UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: 90, y: 43, width: screenWidth-105, height: 10)
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                    .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
                    .foregroundColor:gray,
                    ]
                let labelText = NSAttributedString(string:"\(unanswers[i-1]["orgName"] as! String)/\(unanswers[i-1]["personalName"] as! String)", attributes:labelTextAttr)
                label.attributedText = labelText
                return label
            }()
            unansOrgAndPersonalNames.append(unansOrgAndPersonalName)
            unansRects[i-1].addSubview(unansOrgAndPersonalNames[i-1])
            //回答期限
            let unansDeadline:UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: screenWidth-80, y: 10, width: 70, height: 8)
                let labelTextPar = NSMutableParagraphStyle()
                labelTextPar.alignment = .right
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                    .font:UIFont(name:"HiraKakuProN-W3", size: 8) ?? UIFont.systemFont(ofSize: 8),
                    .foregroundColor:gray,
                    .paragraphStyle:labelTextPar
                ]
                let labelText = NSAttributedString(string:"期限：\(unanswers[i-1]["deadline"] as! String)", attributes:labelTextAttr)
                label.attributedText = labelText
                return label
            }()
            unansDeadlines.append(unansDeadline)
            unansRects[i-1].addSubview(unansDeadlines[i-1])
        }
        //リマインド、未回答/未定を元にスクロールビューの高さを決定
        let pickupScrollViewHeight = CGFloat(132+80*(reminds.count+unanswers.count))
        pickupScrollView.contentSize = CGSize(width: screenWidth, height: pickupScrollViewHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
