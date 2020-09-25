//
//  MemberUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/06.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//OrgUIViewCotroller内で使うもののうちclass内に定義できないもの
//プロフィールのカードを表示するための領域を作成
let rectOfProfileCardShadow = makeClearRect(width: screenWidth-30, height: 80)
let rectOfProfileCard = makeWhiteRect(width: screenWidth-30, height: 80)
//押された団体のボタンごとに、団体を保存しておく変数
var pressedOrgNum: Int = Int()

class OrgUIViewController: UIViewController {
    //イメージビュー（メインヘッダーを表示するための領域）を設定
    let mainHeaderRect:UIImageView = {
        let imageView = UIImageView(image:rectOfMainHeader)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        return imageView
    }()
    //イメージビュー（メインヘッダーの下線）を設定
    let mainHeaderUnderline:UIImageView = {
        let imageView = UIImageView(image:underlineOfMainHeader)
        return imageView
    }()
    //メインヘッダーの画像を生成
    let settingGrayIcon:UIImageView = {
        let image = UIImage(named: "settingGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 15, y: 32.5, width: 25.3, height: 25)
        return imageView
    }()
    let orgPinkIcon:UIImageView = {
        let image = UIImage(named: "orgPink")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth/2-8.5, y: 30, width: 17, height: 30)
        return imageView
    }()
    let comuunGrayIcon:UIImageView = {
        let image = UIImage(named: "comuunGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-38.9, y: 32.5, width: 23.9, height: 25)
        return imageView
    }()
    //メインヘッダーの透明なボタンを作成するメソッド
    func makeMoveToSettingButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(OrgUIViewController.moveToSetting(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    func makeMoveToTimelineButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(OrgUIViewController.moveToTimeline(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //メインヘッダーのボタンで実行するメソッド
    @objc func moveToSetting(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func moveToTimeline(_ sender:UIButton) {
        let nextVC = TimelineUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //イメージビュー（プロフの影を表示するための領域）
    let profileShadowRect:UIImageView = {
        let imageView = UIImageView(image:rectOfProfileCardShadow)
        imageView.frame.origin = CGPoint(x: 15, y: 80)
        imageView.layer.masksToBounds = false
        imageView.layer.shadowOpacity = 0.16
        return imageView
    }()
    //イメージビュー（プロフを表示するための領域）
    let profileRect:UIImageView = {
        let imageView = UIImageView(image:rectOfProfileCard)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    //個人名を設定
    let profileNameLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 85, y: 25, width: 120, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"\(profileName as String)", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //プロフィールの透明なボタンを作成するメソッド
    func makeMoveToProfileModalButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 80, width: screenWidth-30, height: 80)
        button.addTarget(self, action: #selector(OrgUIViewController.moveToProfileModal(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //プロフィールのボタンで実行するメソッド
    @objc func moveToProfileModal(_ sender:UIButton) {
        let provNextVC = ProfileModalUIViewController()
        let trueNextVC: UINavigationController? = UINavigationController(rootViewController: provNextVC)
        trueNextVC?.modalPresentationStyle = .overCurrentContext
        trueNextVC?.modalTransitionStyle = .crossDissolve
        trueNextVC?.view.backgroundColor = modalColor
        present(trueNextVC!, animated: true, completion: nil)
    }
    //団体作成/参加のアイコン
    let createOrSearchOrgPinkIcon:UIImageView = {
        let image = UIImage(named: "createOrSearchOrgPink")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 12, y: 9, width: 36, height: 36)
        return imageView
    }()
    //右矢印のアイコン
    let nextGrayIcon:UIImageView = {
        let image = UIImage(named: "nextGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-29, y: 20, width: 7.32, height: 14)
        return imageView
    }()
    //長方形を用意しておく
    let rectOfOrgIndex = makeWhiteRect(width: screenWidth, height: 54)
    //長方形を用意しておく
    let rectOfOrgIndexPressed = makeGrayRect(width: screenWidth, height: 54)
    //グループ作成/参加のボタンを作成
    func makeMoveToCreateOrSearchOrgButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 190, width: screenWidth, height: 54)
        button.setBackgroundImage(rectOfOrgIndex, for: .normal)
        button.setBackgroundImage(rectOfOrgIndexPressed, for: .highlighted)
        button.addTarget(self, action: #selector(OrgUIViewController.moveToCreateOrSearchOrg(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //グループ作成/参加のボタンで実行するメソッド
    @objc func moveToCreateOrSearchOrg(_ sender:UIButton) {
        let nextVC = CreateOrSearchOrgUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //イメージビュー（団体作成欄の上線）を設定
    let orgHeaderOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（団体作成欄の下線）を設定
    let orgHeaderUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //団体作成欄の題名を設定
    let orgHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 60, y: 13, width: screenWidth-60, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black,
            ]
        let labelText = NSAttributedString(string:"グループ作成/参加", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //団体作成の説明文を設定
    let orgHeaderExplanation:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 60, y: 31, width: screenWidth-60, height: 10)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
            .foregroundColor:gray,
            ]
        let labelText = NSAttributedString(string:"グループの作成や参加をします", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景色を指定
        self.view.backgroundColor = basicBgColor
        // ヘッダーの領域を表示
        self.view.addSubview(mainHeaderRect)
        //ヘッダーの下線を表示
        mainHeaderRect.addSubview(mainHeaderUnderline)
        //ヘッダーのサイドアイコンを表示
        mainHeaderRect.addSubview(settingGrayIcon)
        mainHeaderRect.addSubview(orgPinkIcon)
        mainHeaderRect.addSubview(comuunGrayIcon)
        //ヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let moveToSettingButton = makeMoveToSettingButton()
        self.view.addSubview(moveToSettingButton)
        let moveToTimelineButton = makeMoveToTimelineButton()
        self.view.addSubview(moveToTimelineButton)
        //プロフィール用の領域を表示
        self.view.addSubview(profileShadowRect)
        profileShadowRect.addSubview(profileRect)
        basicProfileImageView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        basicProfileImageView.layer.cornerRadius = 60 * 0.5
        basicProfileImageView.clipsToBounds = true
        profileRect.addSubview(basicProfileImageView)
        profileRect.addSubview(profileNameLabel)
        let moveToProfileModalButton = makeMoveToProfileModalButton()
        self.view.addSubview(moveToProfileModalButton)
        //イメージビュー（団体作成欄を表示するための領域）を配置
        let moveToCreateOrSearchOrgButton = makeMoveToCreateOrSearchOrgButton()
        self.view.addSubview(moveToCreateOrSearchOrgButton)
        // イメージビュー（団体作成欄の上線）を配置
        moveToCreateOrSearchOrgButton.addSubview(orgHeaderOverline)
        // イメージビュー（団体作成欄の下線）を配置
        moveToCreateOrSearchOrgButton.addSubview(orgHeaderUnderline)
        //イメージビュー(団体作成欄の円形アイコン)
        moveToCreateOrSearchOrgButton.addSubview(createOrSearchOrgPinkIcon)
        //イメージビュー(団体作成欄の右矢印アイコン)
        moveToCreateOrSearchOrgButton.addSubview(nextGrayIcon)
        //団体作成欄の題名を配置
        moveToCreateOrSearchOrgButton.addSubview(orgHeaderLabel)
        //団体作成欄のメッセージを表示
        moveToCreateOrSearchOrgButton.addSubview(orgHeaderExplanation)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //参加グループ数を設定
        let profileNumOfOrgLabel:UILabel = {
            let label = UILabel()
            label.frame = CGRect(x: 85, y: 43, width: 120, height: 10)
            let labelTextAttr: [NSAttributedStringKey : Any] = [
                .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
                .foregroundColor:gray,
                ]
            //団体のためのfor文を記入
            var labelText = NSAttributedString()
            if UserDefaults.standard.array(forKey: "belongingOrgs") != nil {
                let belongingOrgsForOrg = UserDefaults.standard.array(forKey: "belongingOrgs") as! [[String : Any?]]
                labelText = NSAttributedString(string:"参加グループ：\(belongingOrgsForOrg.count)", attributes:labelTextAttr)
            } else {
                labelText = NSAttributedString(string:"参加グループ：0", attributes:labelTextAttr)
            }
            label.attributedText = labelText
            return label
        }()
        profileNumOfOrgLabel.removeFromSuperview()
        profileRect.addSubview(profileNumOfOrgLabel)
        //初期値を指定しない配列（団体の領域etcのため）を用意しておき、for文の中で団体の要素の数に応じて、設定・配置をしていく
        var moveToOrgModalButtons = [UIButton]()
        var orgTitles = [UILabel]()
        var numOfOrgMembers = [UILabel]()
        //団体のためのfor文を記入
        if UserDefaults.standard.array(forKey: "belongingOrgs") != nil {
            var belongingOrgs = UserDefaults.standard.array(forKey: "belongingOrgs") as! [[String : Any?]]
            for i in 0...belongingOrgs.count-1 {
                //イメージビュー（団体を表示するための領域）
                //各団体のボタンを作成する
                func makeMoveToOrgModalButton() -> UIButton {
                    let button = UIButton()
                    button.frame = CGRect(x: 0, y: 54*(i+1)+190, width: Int(screenWidth), height: 54)
                    button.setBackgroundImage(rectOfOrgIndex, for: .normal)
                    button.setBackgroundImage(rectOfOrgIndexPressed, for: .highlighted)
                    button.addTarget(self, action: #selector(OrgUIViewController.moveToOrgModal(_:)), for: UIControlEvents.touchUpInside)
                    button.tag = i
                    return button
                }
                let moveToOrgModalButton = makeMoveToOrgModalButton()
                moveToOrgModalButtons.append(moveToOrgModalButton)
                self.view.addSubview(moveToOrgModalButtons[i])
                //イメージビュー（団体のコンテンツの下線）
                let orgUnderline:UIImageView = {
                    let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
                    let imageView = UIImageView(image: drawImage)
                    return imageView
                }()
                moveToOrgModalButtons[i].addSubview(orgUnderline)
                //ここからは団体画像の表示についての記述。。まずは団体のIDを取得し、それを利用し対応するが団体画像を特定する
                let pressedOrgId = belongingOrgs[i]["id"] as! String
                //画像を取得する。
                let path = UserDefaults.standard.url(forKey: "orgBasic\(pressedOrgId)")
                let path2 = UserDefaults.standard.url(forKey: "orgExpanded\(pressedOrgId)")
                let path3 = UserDefaults.standard.url(forKey: "orgAcount\(pressedOrgId)")
                if path != nil && path2 != nil && path3 != nil {
                    let path = path?.path
                    let path2 = path2?.path
                    let path3 = path3?.path
                    let image = UIImage(contentsOfFile: path!)
                    let imageView = UIImageView(image: image)
                    let image2 = UIImage(contentsOfFile: path2!)
                    let imageView2 = UIImageView(image: image2)
                    let image3 = UIImage(contentsOfFile: path3!)
                    let imageView3 = UIImageView(image: image3)
                    basicOrgImageViews[pressedOrgId] = imageView
                    expandedOrgImageViews[pressedOrgId] = imageView2
                    acountOrgImageViews[pressedOrgId] = imageView3
                    //団体一覧における画像を表示させる
                    basicOrgImageViews[pressedOrgId]!.frame = CGRect(x: 12, y: 9, width: 36, height: 36)
                    basicOrgImageViews[pressedOrgId]!.layer.cornerRadius = 36 * 0.5
                    basicOrgImageViews[pressedOrgId]!.clipsToBounds = true
                    moveToOrgModalButtons[i].addSubview(basicOrgImageViews[pressedOrgId]!)
                }
                //団体名
                let orgTitle:UILabel = {
                    let label = UILabel()
                    label.frame = CGRect(x: 60, y: 13, width: screenWidth-60, height: 12)
                    let labelTextAttr: [NSAttributedStringKey : Any] = [
                        .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
                        .foregroundColor:black,
                        ]
                    let labelText = NSAttributedString(string:"\(belongingOrgs[i]["name"] as! String)", attributes:labelTextAttr)
                    label.attributedText = labelText
                    return label
                }()
                orgTitles.append(orgTitle)
                moveToOrgModalButtons[i].addSubview(orgTitles[i])
                //団体のメンバー数
                let numOfOrgMember:UILabel = {
                    let label = UILabel()
                    label.frame = CGRect(x: 60, y: 31, width: screenWidth-60, height: 10)
                    let labelTextAttr: [NSAttributedStringKey : Any] = [
                        .font:UIFont(name:"HiraKakuProN-W3", size: 10) ?? UIFont.systemFont(ofSize: 10),
                        .foregroundColor:gray,
                        ]
                    let labelText = NSAttributedString(string:"\((belongingOrgs[i]["member"] as! Dictionary<String, String>).count)", attributes:labelTextAttr)
                    label.attributedText = labelText
                    return label
                }()
                numOfOrgMembers.append(numOfOrgMember)
                moveToOrgModalButtons[i].addSubview(numOfOrgMembers[i])
            }
        }
    }
    //各団体のボタンで実行するメソッド
    @objc func moveToOrgModal(_ sender:UIButton) {
        pressedOrgNum = sender.tag
        let provNextVC = OrgModalUIViewController()
        let trueNextVC: UINavigationController? = UINavigationController(rootViewController: provNextVC)
        trueNextVC?.modalPresentationStyle = .overCurrentContext
        trueNextVC?.modalTransitionStyle = .crossDissolve
        trueNextVC?.view.backgroundColor = modalColor
        present(trueNextVC!, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
