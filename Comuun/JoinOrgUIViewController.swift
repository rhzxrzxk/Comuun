//
//  JoinOrgUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/07/16.
//  Copyright © 2018年 田中尊. All rights reserved.
//



import UIKit



class JoinOrgUIViewController: UIViewController, UIImagePickerControllerDelegate {
    //イメージビュー（サブヘッダーを表示するための領域）を設定
    let subHeaderRect:UIImageView = {
        let imageView = UIImageView(image:rectOfSubHeader)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        return imageView
    }()
    //イメージビュー（サブヘッダーの下線）を設定
    let subHeaderUnderline:UIImageView = {
        let imageView = UIImageView(image:underlineOfSubHeader)
        return imageView
    }()
    //サブヘッダーのラベルを生成(センター)
    let centerSubHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: screenWidth-100, height: 15)
        label.center = CGPoint(x: screenWidth/2, y: 42.5)
        let labelTextPar = NSMutableParagraphStyle()
        labelTextPar.alignment = .center
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:black,
            .paragraphStyle:labelTextPar
        ]
        let labelText = NSAttributedString(string:"グループに参加する", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーのラベルを生成(サイド)
    var leftSubHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 35, width: 80, height: 15)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:mainColor
        ]
        let labelText = NSAttributedString(string:"キャンセル", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーのラベルを生成(サイド)
    let rightSubHeaderLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-50, y: 35, width: 35, height: 15)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 15) ?? UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor:mainColor
        ]
        let labelText = NSAttributedString(string:"参加", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeReturnCreateOrgSearchOrgButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 80, height: 25)
        button.addTarget(self, action: #selector(JoinOrgUIViewController.returnCreateOrSearchOrg(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーの「キャンセル」ボタンで実行するメソッド
    @objc func returnCreateOrSearchOrg(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //サブヘッダーの透明なボタンのうち、「参加ボタン」を作成するメソッド
    func makeJoinOrgButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(JoinOrgUIViewController.joinOrg(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーの「参加」ボタンで実行するメソッド
    @objc func joinOrg(_ sender:UIButton) {
        //ここでサーバーに団体登録をする
        var member = serverOrgs[orgIdForServer]!["member"] as! [String:Any]
        member[profileId] = profileName
        //後はサーバーの変化を全端末のローカルに反映
        
        
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.popToViewController(navigationController!.viewControllers[1], animated: false)
    }
    //イメージビュー（団体名の背景となる領域）を設定
    let orgIdRect:UIImageView = {
        let image = makeWhiteRect(width: screenWidth, height: 80)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPoint(x: 0, y: 80)
        return imageView
    }()
    //イメージビュー（団体名の上線）を設定
    let orgIdOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:0, x1:screenWidth, y1:0)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //イメージビュー（団体名の下線）を設定
    let orgIdUnderline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:80, x1:screenWidth, y1:80)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //団体名を設定
    let orgNameLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 90, y: 34 ,width: screenWidth-90, height: 12)
        let labelTextAttr: [NSAttributedStringKey : Any] = [
            .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor:black
        ]
        let labelText = NSAttributedString(string:serverOrgs[enteredId]!["name"] as! String, attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //団体画像を設定
    let orgImageView:UIImageView = serverOrgs[enteredId]!["imageView"] as! UIImageView
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景色を指定
        self.view.backgroundColor = basicBgColor
        //サブヘッダーの領域を表示
        self.view.addSubview(subHeaderRect)
        //サブヘッダーの下線を表示
        subHeaderRect.addSubview(subHeaderUnderline)
        //サブヘッダーのラベルを表示
        subHeaderRect.addSubview(centerSubHeaderLabel)
        //サブヘッダーのサイドアイコンを表示
        subHeaderRect.addSubview(leftSubHeaderLabel)
        subHeaderRect.addSubview(rightSubHeaderLabel)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let returnCreateOrSearchOrgButton = makeReturnCreateOrgSearchOrgButton()
        self.view.addSubview(returnCreateOrSearchOrgButton)
        let joinOrgButton = makeJoinOrgButton()
        self.view.addSubview(joinOrgButton)
        //テキストビューの周辺を配置して行く
        self.view.addSubview(orgIdRect)
        orgIdRect.addSubview(orgIdOverline)
        orgIdRect.addSubview(orgIdUnderline)
        orgIdRect.addSubview(orgNameLabel)
        orgIdRect.addSubview(orgImageView)
        //団体画像を配置する
        orgImageView.frame = CGRect(x: 15, y: 10, width: 60, height: 60)
        orgImageView.layer.cornerRadius = 60 * 0.5
        orgImageView.clipsToBounds = true
        orgIdRect.addSubview(orgImageView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
