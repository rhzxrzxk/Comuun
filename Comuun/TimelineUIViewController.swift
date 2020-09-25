//
//  ComuunUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/05/28.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit
import Koloda



//複数の.swiftに共通の部分
//サイズ
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
//色
let basicBgColor = UIColor(displayP3Red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
let mainColor = UIColor(displayP3Red: 0.9, green: 0.17, blue: 0.46, alpha: 1.0)
let modalColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
let lineColor = UIColor(displayP3Red: 0.87, green: 0.87, blue: 0.88, alpha: 1.0)
let white = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
let black = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
let gray = UIColor(displayP3Red: 0.44, green: 0.44, blue: 0.44, alpha: 1.0)
let clear = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
let red = UIColor(displayP3Red: 1.0, green: 0.22, blue: 0.14, alpha: 1.0)
let green = UIColor(displayP3Red: 0.27, green: 0.86, blue: 0.37, alpha: 1.0)
//サーバー上のユーザー一覧
var serverUsers:[String:[String:Any?]] = [:]
//サーバー上の団体一覧
var serverOrgs:[String:[String:Any?]] = [:]
//サーバー上の投稿一覧
var serverPosts:[String:[String:Any?]] = [:]


//投稿の例、将来的には団体Xに所属するAくんがpostingを投稿→post=postingに代入されて、団体Xに所属するAくん以外のタイムラインにpostが表示される。Aくんは自分の投稿一覧から、回答状況を確認することができる
let post1:[String:Any?] = [
    "orgName":"仙台建築都市学生会議",
    "personalName":"遠藤空瑠",
    "deadline":"4/15 21:00",
    "numOfRe":124,
    "multipleChoice":true,
    "attached":Attached.questionnaire3,
    "title":"新歓の日程調整",
    "content":"2年生の遠藤です。\n新入生が入ってきたので、4月の後半に新歓を行いたいと思います！\n全員の予定が空いている日はなかなかないと思うので、多数決で日程を決めようと思います。\n期限は4/15の21:00までです。よろしくお願いします。"
]
let post2:[String:Any?] = [
    "orgName":"SDL2018STAFF",
    "personalName":"山口智弥",
    "deadline":nil,
    "numOfRe":nil,
    "multipleChoice":nil,
    "attached":Attached.image,
    "title":"落し物",
    "content":"山口です\n5FバックヤードでiPhoneの落し物がありました。\n持ち主がいたら連絡くださいー\nLINE：kkkkkkk"
]
let post3:[String:Any?] = [
    "orgName":"仙台建築都市学生会議",
    "personalName":"中谷圭介",
    "deadline":"4/21 21:00",
    "numOfRe":87,
    "multipleChoice":nil,
    "attached":Attached.tripleChoice,
    "title":"来週の通常会議",
    "content":"代表の中谷です！\n来週の通常会議では、1年生への局紹介と局配属があるので、ぜひ参加してください。\nフランスの有名建築のプレゼンも行います！"
]
//投稿をまとめる
let posts = [ post1, post2, post3 ]
//作成していく投稿
var posting1:[String:Any?] = [
    "orgName":nil,
    "personalName":nil,
    "deadline":nil,
    "multipleChoice":nil,
    "attached":nil,
    "title":nil,
    "content":nil,
    "remind":nil
]


//白い長方形を描画する関数
func makeWhiteRect(width w:CGFloat, height h:CGFloat) -> UIImage {
    let size = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let context = UIGraphicsGetCurrentContext()
    let drawRect = CGRect(x: 0, y: 0, width: w, height: h)
    let drawPath = UIBezierPath(rect: drawRect)
    context?.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha:1.0)
    drawPath.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
//灰色の長方形を描画する関数
func makeGrayRect(width w:CGFloat, height h:CGFloat) -> UIImage {
    let size = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let context = UIGraphicsGetCurrentContext()
    let drawRect = CGRect(x: 0, y: 0, width: w, height: h)
    let drawPath = UIBezierPath(rect: drawRect)
    context?.setFillColor(red: 0.98, green: 0.98, blue: 1.0, alpha:1.0)
    drawPath.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
//透明な長方形を描画する関数（影を作るときなどに使用する）
func makeClearRect(width w:CGFloat, height h:CGFloat) -> UIImage {
    let size = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let context = UIGraphicsGetCurrentContext()
    let drawRect = CGRect(x: 0, y: 0, width: w, height: h)
    let drawPath = UIBezierPath(rect: drawRect)
    context?.setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha:0.0)
    drawPath.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
//直線を描画する関数（分割線を作るときなどに使用する）
func drawLine(x0:CGFloat, y0:CGFloat, x1:CGFloat, y1:CGFloat) -> UIImage {
    let pointA = CGPoint(x:x0, y:y0)
    let pointB = CGPoint(x:x1, y:y1)
    let size = CGSize(width: screenWidth, height: screenHeight)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let drawPath = UIBezierPath()
    drawPath.move(to: pointA)
    drawPath.addLine(to: pointB)
    lineColor.setStroke()
    drawPath.lineWidth = 1.0
    drawPath.stroke()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
//白い楕円を描画する関数
func makeWhiteOval(witdh w:CGFloat, height h:CGFloat) -> UIImage {
    let size = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let context = UIGraphicsGetCurrentContext()
    let ovalRect = CGRect(x: 0, y: 0, width: w, height: h)
    let drawPath = UIBezierPath(ovalIn: ovalRect)
    context?.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    drawPath.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
//透明な楕円を描画する関数（タイムラインの円形ボタンを作るときなどに利用する）
func makeClearOval(witdh w:CGFloat, height h:CGFloat) -> UIImage {
    let size = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let context = UIGraphicsGetCurrentContext()
    let ovalRect = CGRect(x: 0, y: 0, width: w, height: h)
    let drawPath = UIBezierPath(ovalIn: ovalRect)
    context?.setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    drawPath.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
//メインヘッダー(タイムラインなど最上位レイヤーのヘッダー)の長方形を用意しておく
let rectOfMainHeader = makeWhiteRect(width: screenWidth, height: 70)
//メインヘッダーの下線を用意しておく
let underlineOfMainHeader = drawLine(x0:0, y0:70, x1:screenWidth, y1:70)
//サブヘッダー（設定など一つ下のレイヤーのヘッダー）の長方形を用意しておく
let rectOfSubHeader = makeWhiteRect(width: screenWidth, height: 65)
//サブヘッダーの下線を用意しておく
let underlineOfSubHeader = drawLine(x0:0, y0:65, x1:screenWidth, y1:65)
//Stockヘッダー（Stockの画面にだけ存在する、PickupとFeedを選択するヘッダー）の長方形を用意しておく
let rectOfStockHeader = makeWhiteRect(width: screenWidth/2, height: 70)
//Stockヘッダーの、左右を分割する線を用意しておく
let partlineOfStockHeader = drawLine(x0:screenWidth/2, y0:77.5, x1:screenWidth/2, y1:107.5)
//Stockヘッダーの下線を用意しておく
let underlineOfStockHeader = drawLine(x0:0, y0:115, x1:screenWidth, y1:115)
//投稿タイプごとの添付物の領域を用意しておく
let rectOfNone = makeWhiteRect(width: screenWidth-30, height: 1)
let rectOfImage = makeWhiteRect(width: screenWidth-30, height: screenWidth-30)
let rectOfTripleChoice = makeWhiteRect(width: screenWidth-30, height: 138)
let rectOfQuestionnaire2 = makeWhiteRect(width: screenWidth-30, height: 80)
let rectOfQuestionnaire3 = makeWhiteRect(width: screenWidth-30, height: 112)
let rectOfQuestionnaire4 = makeWhiteRect(width: screenWidth-30, height: 144)
let rectOfQuestionnaire5 = makeWhiteRect(width: screenWidth-30, height: 176)
let rectOfQuestionnaire6 = makeWhiteRect(width: screenWidth-30, height: 208)
let rectOfQuestionnaire7 = makeWhiteRect(width: screenWidth-30, height: 240)
let rectOfQuestionnaire8 = makeWhiteRect(width: screenWidth-30, height: 272)
let rectOfQuestionnaire9 = makeWhiteRect(width: screenWidth-30, height: 304)



//TimelineUIViewController内で使うもののうちclass内に定義できないもの
//「投稿」「Stock」のボタンの円を用意しておく
let postAndStockCircle = makeWhiteOval(witdh: 60, height: 60)



class TimelineUIViewController: UIViewController {
    //KolodaViewのインスタンスを生成
    let kolodaView = KolodaView()
    //メインヘッダーのイメージビューを設定
    let mainHeaderRect:UIImageView = {
        let imageView = UIImageView(image:rectOfMainHeader)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        return imageView
    }()
    //イメージビュー（ヘッダーの下線）を設定
    let mainHeaderUnderline:UIImageView = {
        let imageView = UIImageView(image:underlineOfMainHeader)
        return imageView
    }()
    //メインヘッダーの画像を生成
    let orgGrayIcon:UIImageView = {
        let image = UIImage(named: "orgGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 15, y: 32.5, width: 14.9, height: 25)
        return imageView
    }()
    let comuunPinkIcon:UIImageView = {
        let image = UIImage(named: "comuunPink")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth/2-14.35, y: 30, width: 28.7, height: 30)
        return imageView
    }()
    let stockGrayIcon:UIImageView = {
        let image = UIImage(named: "stockGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-42.7, y: 32.5, width: 27.7, height: 25)
        return imageView
    }()
    //メインヘッダーの透明なボタンを作成するメソッド
    func makeMoveToOrgButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(TimelineUIViewController.moveToOrg(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    func makeMoveToStockButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(TimelineUIViewController.moveToStock(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //メインヘッダーのボタンで実行するメソッド
    @objc func moveToOrg(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func moveToStock(_ sender:UIButton) {
        let nextVC = PickupUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //イメージビュー（postとstockの円形ボタンを表示するための領域）を設定
    let postButtonCircle:UIImageView = {
        let imageView = UIImageView(image:postAndStockCircle)
        imageView.frame.origin = CGPoint(x: screenWidth/2-90, y: screenHeight-75)
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.04
        return imageView
    }()
    let stockButtonCircle:UIImageView = {
        let imageView = UIImageView(image:postAndStockCircle)
        imageView.frame.origin = CGPoint(x: screenWidth/2+30, y: screenHeight-75)
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.04
        return imageView
    }()
    //postButtonとstockButtonの画像を設定
    let postRedIcon:UIImageView = {
        let image = UIImage(named: "postRed")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth/2-75.85, y: screenHeight-60, width: 31.7, height: 30)
        return imageView
    }()
    let stockBlueIcon:UIImageView = {
        var image = UIImage(named: "stockBlue")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth/2+44.15, y: screenHeight-60, width: 31.7, height: 30)
        return imageView
    }()
    //透明なpostとstockの円形ボタンを作成するメソッド
    func makePostButton() -> UIButton {
        let button = UIButton()
        let image = makeClearOval(witdh: 60, height: 60)
        button.setBackgroundImage(image, for: .normal)
        button.frame = postButtonCircle.frame
        button.addTarget(self, action: #selector(TimelineUIViewController.post(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    func makeStockButton() -> UIButton {
        let button = UIButton()
        let image = makeClearOval(witdh: 60, height: 60)
        button.setBackgroundImage(image, for: .normal)
        button.frame = stockButtonCircle.frame
        button.addTarget(self, action: #selector(TimelineUIViewController.stock(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //postとstockの円形ボタンで実行するメソッド
    @objc func post(_ sender:UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "PostOrg") as! PostOrgUIViewController
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(nextVC, animated: false )
    }
    @objc func stock(_ sender:UIButton) {
        kolodaView.swipe(SwipeResultDirection.right)
    }
    //投稿がなくなった時に見える画像
    let noPostIcon:UIImageView = {
        let image = UIImage(named: "noPost")
        let imageView = UIImageView(image: image)
        imageView.frame.size = CGSize(width: 100, height: 146)
        imageView.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景色を指定
        self.view.backgroundColor = basicBgColor
        // メインヘッダーの領域を表示
        self.view.addSubview(mainHeaderRect)
        //メインヘッダーの下線を表示
        mainHeaderRect.addSubview(mainHeaderUnderline)
        //メインヘッダーのサイドアイコンを表示
        mainHeaderRect.addSubview(orgGrayIcon)
        mainHeaderRect.addSubview(comuunPinkIcon)
        mainHeaderRect.addSubview(stockGrayIcon)
        //メインヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let moveToOrgButton = makeMoveToOrgButton()
        self.view.addSubview(moveToOrgButton)
        let moveToStockButton = makeMoveToStockButton()
        self.view.addSubview(moveToStockButton)
        //イメージビュー（postButtonとstockButtonを表示するための領域）を表示
        self.view.addSubview(postButtonCircle)
        self.view.addSubview(stockButtonCircle)
        //postButtonとstockButtonの画像を表示
        self.view.addSubview(postRedIcon)
        self.view.addSubview(stockBlueIcon)
        //透明なpostButtonとstockButtonを表示
        let postButton = makePostButton()
        self.view.addSubview(postButton)
        let stockButton = makeStockButton()
        self.view.addSubview(stockButton)
        //投稿がなくなった時に見える画像を表示
        self.view.addSubview(noPostIcon)
        //kolodaViewの領域を指定し、表示
        kolodaView.frame = CGRect(x: 0, y: 0, width: screenWidth-30, height: screenHeight-170)
        kolodaView.center = CGPoint(x:screenWidth/2, y:screenHeight/2-5)
        self.view.addSubview(kolodaView)
        //各種delegateを指定する
        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



//必要なメソッドがあれば記述する
extension TimelineUIViewController: KolodaViewDelegate {
}



//カードの上に表示するものを作成していく
extension TimelineUIViewController: KolodaViewDataSource {
    //表示する件数を指定
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return posts.count
    }
    //カードを投げた時の速度を指定
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    //カードがなくなった時の処理を記入
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        stockBlueIcon.image = UIImage(named: "stockGray")
    }
    //実際にカードの上に表示するものを作成していく
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        //カードの基本になるviewの領域を指定
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: screenWidth-30, height: screenHeight-170)
        view.layer.cornerRadius = 10
        view.layer.backgroundColor = white.cgColor
        view.layer.shadowColor = black.cgColor
        view.layer.shadowOpacity = 0.16
        //団体名をUILabelで表示
        let orgName = UILabel()
        orgName.frame = CGRect(x: 56, y: 14, width: 150, height: 12)
        let orgNameTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
        ]
        let orgNameText = NSAttributedString(string:posts[index]["orgName"] as! String, attributes:orgNameTextAttr)
        orgName.attributedText = orgNameText
        view.addSubview(orgName)
        //投稿者名をUILabelで表示
        let personalName = UILabel()
        personalName.frame = CGRect(x: 56, y: 32, width: 160, height: 10)
        let personalNameTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
            .foregroundColor:gray,
            ]
        let personalNameText = NSAttributedString(string:posts[index]["personalName"] as! String, attributes:personalNameTextAttr)
        personalName.attributedText = personalNameText
        view.addSubview(personalName)
        //回答期限をUILabelで表示
        if let string = posts[index]["deadline"] as? String {
            let deadline = UILabel()
            deadline.frame = CGRect(x: view.bounds.width-80, y: 10, width: 70, height: 8)
            let deadlinePar = NSMutableParagraphStyle()
            deadlinePar.alignment = .right
            let deadlineTextAttr: [NSAttributedStringKey : Any] = [
                .font:UIFont(name:"HiraKakuProN-W3", size: 8) ?? UIFont.systemFont(ofSize: 8),
                .foregroundColor:gray,
                .paragraphStyle:deadlinePar
                ]
            let deadlineText = NSAttributedString(string:"期限：\(string)", attributes:deadlineTextAttr)
            deadline.attributedText = deadlineText
            view.addSubview(deadline)
        }
        //回答数をUILabelで表示
        if let int = posts[index]["numOfRe"] as? Int {
            let numOfRe = UILabel()
            numOfRe.frame = CGRect(x: view.bounds.width-80, y: 23, width: 70, height: 8)
            let numOfRePar = NSMutableParagraphStyle()
            numOfRePar.alignment = .right
            let numOfReTextAttr: [NSAttributedStringKey : Any] = [
                .font:UIFont(name:"HiraKakuProN-W3", size: 8) ?? UIFont.systemFont(ofSize: 8),
                .foregroundColor:gray,
                .paragraphStyle:numOfRePar
                ]
            let numOfReText = NSAttributedString(string:"回答数：\(int)", attributes:numOfReTextAttr)
            numOfRe.attributedText = numOfReText
            view.addSubview(numOfRe)
        }
        //複数選択か単一選択かをUILabelで表示
        if let bool = posts[index]["multipleChoice"] as? Bool {
            let multipleChoice = UILabel()
            multipleChoice.frame = CGRect(x: view.bounds.width-80, y: 36, width: 70, height: 8)
            let multipleChoicePar = NSMutableParagraphStyle()
            multipleChoicePar.alignment = .right
            let multipleChoiceTextAttr: [NSAttributedStringKey : Any] = [
                .font:UIFont(name:"HiraKakuProN-W6", size: 8) ?? UIFont.boldSystemFont(ofSize: 8),
                .foregroundColor:mainColor,
                .paragraphStyle:multipleChoicePar
                ]
            if bool {
                let multipleChoiceText = NSAttributedString(string:"複数選択できます", attributes:multipleChoiceTextAttr)
                multipleChoice.attributedText = multipleChoiceText
                view.addSubview(multipleChoice)
            } else {
                let multipleChoiceText = NSAttributedString(string:"単一選択です", attributes:multipleChoiceTextAttr)
                multipleChoice.attributedText = multipleChoiceText
                view.addSubview(multipleChoice)
            }
        }
        //添付物、題名、内容を表示するためのスクロールビューを作成
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 54, width: screenWidth-30, height: screenHeight-254)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        //投稿の種類に応じた領域を設置する
        var attachedRect = UIImageView(image: rectOfNone)
                if let attached = posts[index]["attached"] as? Attached {
                    switch attached {
                    case .image:
                        attachedRect = UIImageView(image: rectOfImage)
                    case .tripleChoice:
                        attachedRect = UIImageView(image: rectOfTripleChoice)
                    case .questionnaire2:
                        attachedRect = UIImageView(image: rectOfQuestionnaire2)
                    case .questionnaire3:
                        attachedRect = UIImageView(image: rectOfQuestionnaire3)
                    case .questionnaire4:
                        attachedRect = UIImageView(image: rectOfQuestionnaire4)
                    case .questionnaire5:
                        attachedRect = UIImageView(image: rectOfQuestionnaire5)
                    case .questionnaire6:
                        attachedRect = UIImageView(image: rectOfQuestionnaire6)
                    case .questionnaire7:
                        attachedRect = UIImageView(image: rectOfQuestionnaire7)
                    case .questionnaire8:
                        attachedRect = UIImageView(image: rectOfQuestionnaire8)
                    case .questionnaire9:
                        attachedRect = UIImageView(image: rectOfQuestionnaire9)
                    }
                }
        attachedRect.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.addSubview(attachedRect)
        //投稿の題名をUILabelで表示
        let title = UILabel()
        title.frame = CGRect(x: 10, y: attachedRect.bounds.height+10, width: screenWidth-50, height: 12)
        let titleTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let titleText = NSAttributedString(string:posts[index]["title"] as! String, attributes:titleTextAttr)
        title.attributedText = titleText
        scrollView.addSubview(title)
        //投稿の内容をUILabelで表示
        let content = UILabel()
        content.numberOfLines = 0
        let contentPar = NSMutableParagraphStyle()
        contentPar.lineSpacing = 20.0
        let contentTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W3", size: 12) ?? UIFont.systemFont(ofSize: 12),
            .foregroundColor:black,
            .paragraphStyle:contentPar
            ]
        let contentText = NSAttributedString(string:posts[index]["content"] as! String, attributes:contentTextAttr)
        content.attributedText = contentText
        //投稿内容を表示するUILabelの高さを文量に応じて調整
        let contentSize = content.sizeThatFits(CGSize(width:screenWidth-50, height:0))
        content.frame = CGRect(x: 10, y: attachedRect.bounds.height+32, width:screenWidth-50, height:contentSize.height)
        scrollView.addSubview(content)
        //添付物、題名、内容を元にスクロールビューの高さを決定
        scrollView.contentSize = CGSize(width: screenWidth-30, height: attachedRect.bounds.height+contentSize.height+32)
        //最後にUIViewのインスタンスviewを返す
        return view
    }
}



