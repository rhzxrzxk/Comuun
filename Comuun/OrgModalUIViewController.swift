//
//  OrgModalUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/09/01.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//プロフィール画像配置用の長方形を用意
let rectOfExpandedOrgImage = makeWhiteRect(width: 270, height: 390)



class OrgModalUIViewController: UIViewController {
    //周辺にあるモーダルを消すボタンを作成するメソッド
    func makeReturnToOrgButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        button.addTarget(self, action: #selector(OrgModalUIViewController.returnToOrg(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //周辺にあるモーダルを消すボタンで実行するメソッド
    @objc func returnToOrg(_ sender:UIButton) {
        dismiss(animated: true, completion: {})
    }
    //UIViewを設定する
    let orgModalUIView:UIView = {
        let uiView = UIView()
        uiView.frame = CGRect(x: screenWidth/2-135, y: screenHeight/2-195, width: 270, height: 390)
        return uiView
    }()
    //イメージビュー（団体画像を表示するための領域）
    let expandedOrgImageRect:UIImageView = {
        let imageView = UIImageView(image:rectOfExpandedOrgImage)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    //団体名を設定
    let orgNameLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 135-60, y: 280, width: 120, height: 10)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .center
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 10) ?? UIFont.boldSystemFont(ofSize: 10),
            .foregroundColor:black,
            .paragraphStyle:labelTextPar
        ]
        //ローカルに保存された所属団体を取得
        var belongingOrgs = UserDefaults.standard.array(forKey: "belongingOrgs") as! [[String : Any?]]
        
        //OrgUIViewにおけるボタンのtagから押されたボタンを特定
        let labelText = NSAttributedString(string:"\(belongingOrgs[pressedOrgNum]["name"] as! String)", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //メンバーボタンを作成するメソッド
    func makeMoveToOrgMgmtButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 310, width: 135, height: 80)
        button.addTarget(self, action: #selector(OrgModalUIViewController.moveToOrgMgmt(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //メンバーボタンで実行するメソッド
    @objc func moveToOrgMgmt(_ sender:UIButton) {
        print("メンバーの画面に遷移")
    }
    //メンバーの画像を生成
    let myPostGrayIcon:UIImageView = {
        //画像を変更
        let image = UIImage(named: "myPostGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 40.5, y: 20, width: 54, height: 40)
        return imageView
    }()
    //グループ管理ボタンを作成するメソッド
    func makeMoveToMemberButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 135, y: 310, width: 135, height: 80)
        button.addTarget(self, action: #selector(OrgModalUIViewController.moveToMember(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //グループ管理ボタンで実行するメソッド
    @objc func moveToMember(_ sender:UIButton) {
        //遷移先を変更する
        print("グループ管理画面に遷移")
    }
    //グループ管理の画像を生成
    let acountMgmtGrayIcon:UIImageView = {
        let image = UIImage(named: "acountMgmtGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 29.5, y: 21.24, width: 76, height: 37.53)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーを消す(画面遷移に左右へのスライドを使うためにnavigationControllerを利用したが、バーやボタンは自分で作成している)
        self.navigationController?.isNavigationBarHidden = true
        let returnToOrgButton = makeReturnToOrgButton()
        self.view.addSubview(returnToOrgButton)
        //UIViewを配置
        self.view.addSubview(orgModalUIView)
        //画像用の長方形を配置
        orgModalUIView.addSubview(expandedOrgImageRect)
        //ここから画像関係の記述。tag(pressedOrgNumに代入済み)からIDを特定し、各団体に対応する画像を表示させる。
        if UserDefaults.standard.array(forKey: "belongingOrgs") != nil {
            let belongingOrgs = UserDefaults.standard.array(forKey: "belongingOrgs") as! [[String : Any?]]
            let pressedOrgId = belongingOrgs[pressedOrgNum]["id"] as! String
            expandedOrgImageViews[pressedOrgId]!.frame = CGRect(x: 0, y: 0, width: 270, height: 270)
            expandedOrgImageRect.addSubview(expandedOrgImageViews[pressedOrgId]!)
        }
        //その他を配置していく
        expandedOrgImageRect.addSubview(orgNameLabel)
        let moveToMyPostButton = makeMoveToOrgMgmtButton()
        orgModalUIView.addSubview(moveToMyPostButton)
        moveToMyPostButton.addSubview(myPostGrayIcon)
        let moveToAccountMgmtButton = makeMoveToMemberButton()
        orgModalUIView.addSubview(moveToAccountMgmtButton)
        moveToAccountMgmtButton.addSubview(acountMgmtGrayIcon)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
