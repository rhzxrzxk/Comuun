//
//  DeleteAcountUIViewController.swift
//  Comuun
//
//  Created by 田中尊 on 2018/07/22.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//MyPostUIViewController内で使うもののうちclass内に定義できないもの



class DeleteAcountUIViewController: UIViewController {
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
        let labelText = NSAttributedString(string:"アカウントを削除", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーの画像を生成
    let previousGrayIcon:UIImageView = {
        let image = UIImage(named: "previousGray")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 15, y: 35, width: 7.85, height: 15)
        return imageView
    }()
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeReturnAcountMgmtButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(PostRemindUIViewController.returnPostDeadline(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //サブヘッダーのボタンで実行するメソッド
    @objc func returnPostDeadline(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
        //左矢印のアイコンを設定
        subHeaderRect.addSubview(previousGrayIcon)
        //サブヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let returnAcountMgmtButton = makeReturnAcountMgmtButton()
        self.view.addSubview(returnAcountMgmtButton)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
