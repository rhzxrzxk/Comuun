//
//  PostOrg.swift
//  Comuun
//
//  Created by 田中尊 on 2018/06/09.
//  Copyright © 2018年 田中尊. All rights reserved.
//

import UIKit



//PostOrgUIViewController内で使うもののうちclass内に定義できないもの
//チェックマークを入れていく辞書
var postOrgCheckmarks = [String:UIImageView]()
//所属している団体を入れていく辞書
var postBelongingOrgs = [[String : Any?]]()
//添付物を列挙
enum Attached {
    case image
    case tripleChoice
    case questionnaire2
    case questionnaire3
    case questionnaire4
    case questionnaire5
    case questionnaire6
    case questionnaire7
    case questionnaire8
    case questionnaire9
}
//リマインドを列挙
enum Remind {
    case tenMin
    case tweMin
    case oneHour
    case twoHour
    case oneDay
    case twoDay
    case oneWeek
}
//ID系
var postId: String! = String()
var postIdForServer: String! = String()
//投稿団体名系
var postOrgName: String! = String()
var postOrgNameForServer: String! = String()
//画像/三択/複数選択系（添付物）
var postAttached: Attached? = nil
var postAttachedForServer: Attached? = nil
//投稿の題名系
var postTitle: String! = String()
var postTitleNameForServer: String! = String()
//投稿用イメージビュー系
//名前はimage/imageView/imageURLどれにしよう。ローカルにも保存するなら画像はURLを保存する形の方がいいかも？
var attachedImage:UIImageView? = nil
var attachedImageForServer:UIImageView? = nil
//投稿の本文系
var postText: String! = String()
var postTextNameForServer: String! = String()
//回答期限系
var postDeadline: String! = String()
var postDeadlineForServer: String! = String()
//リマインド時間系
var postRemind: Remind? = nil
var postRemindForServer: Remind? = nil
//選択肢を保存していく配列
var postChoices: [String]! = [String]()
var postChoicesForServer: [String]! = [String]()
//選択肢1
var postChoice1: String! = String()
var postChoice1ForServer: String! = String()
//選択肢2
var postChoice2: String! = String()
var postChoice2ForServer: String! = String()
//選択肢3
var postChoice3: String! = String()
var postChoice3ForServer: String! = String()
//選択肢4
var postChoice4: String! = String()
var postChoice4ForServer: String! = String()
//選択肢5
var postChoice5: String! = String()
var postChoice5ForServer: String! = String()
//選択肢6
var postChoice6: String! = String()
var postChoice6ForServer: String! = String()
//選択肢7
var postChoice7: String! = String()
var postChoice7ForServer: String! = String()
//選択肢8
var postChoice8: String! = String()
var postChoice8ForServer: String! = String()
//選択肢9
var postChoice9: String! = String()
var postChoice9ForServer: String! = String()
//選択肢の数を保存する変数
var numOfChoices = 2
var numOfChoicesForServer = 2
//複数選択ができるかどうか系
var postMultiChoice: Bool! = Bool()
var postMultiChoiceForServer: Bool! = Bool()







//回答数系
var postNumOfResponse: Int! = Int()
var postNumOfResponseForServer: Int! = Int()
////image系
//var basicPostImageView: UIImageView! = UIImageView()
//var expandedPostImageView: UIImageView! = UIImageView()
//var acountPostImageView: UIImageView! = UIImageView()
//var postImageViewForServer: UIImageView! = UIImageView()
////ディレクトリのURL
//var documentDirectoryFileURL7 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//var documentDirectoryFileURL8 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//var documentDirectoryFileURL9 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
////member系
//var member: [String:String] = [:]
////新しい団体を作成していく場合に構成要素を保存していく変数
//var creatingPost:[String:Any?] = [
//    "id":nil,
//    "name":nil,
//    "image":nil,
//    "memberID":nil
//]



class PostOrgUIViewController: UIViewController {
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
    //サブヘッダーのラベルを生成
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
        let labelText = NSAttributedString(string:"グループを選択", attributes:labelTextAttr)
        label.attributedText = labelText
        return label
    }()
    //サブヘッダーの画像を生成
    let eracePinkIcon:UIImageView = {
        let image = UIImage(named: "eracePink")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenWidth-30, y: 35, width: 15, height: 15)
        return imageView
    }()
    //サブヘッダーのボタンで実行するメソッド
    @objc func erasePostOrgScreen(_ sender:UIButton) {
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.navigationController!.view.window?.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    //サブヘッダーの透明なボタンを作成するメソッド
    func makeErasePostOrgScreenButton() -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: screenWidth-65, y: 32.5, width: 50, height: 25)
        button.addTarget(self, action: #selector(PostOrgUIViewController.erasePostOrgScreen(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    //イメージビュー（投稿団体の上線）を設定（所属団体があってもなくても、上線は必要）
    let postOrgOverline:UIImageView = {
        let drawImage = drawLine(x0:0, y0:80, x1:screenWidth, y1:80)
        let imageView = UIImageView(image: drawImage)
        return imageView
    }()
    //投稿団体の領域、下線などはviewDidLoad内にfor文で記入している
    //団体を選択した時に実行するメソッド。押されていないボタンのチェックマークを外して、押されたボタンのチェックマークを表示する
    @objc func decidePostOrg(_ sender:UIButton) {
//        posting1["orgName"] = "\(orgs[sender.tag-1]["name"] as! String)"
        
        
        
        
        
        
        postOrgName = postBelongingOrgs[sender.tag-1]["name"] as! String
        postOrgNameForServer = postBelongingOrgs[sender.tag-1]["name"] as! String
        
        
        
        
        
        
        
        for i in 1...postBelongingOrgs.count {
            postOrgCheckmarks["\(i-1)"]!.removeFromSuperview()
        }
        self.view.addSubview(postOrgCheckmarks["\(sender.tag-1)"]!)
        let nextVC = PostTypeUIViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景色を指定
        self.view.backgroundColor = basicBgColor
        // ヘッダーの領域を表示
        self.view.addSubview(subHeaderRect)
        //ヘッダーの下線を表示
        subHeaderRect.addSubview(subHeaderUnderline)
        //サブヘッダーのラベルを表示
        subHeaderRect.addSubview(centerSubHeaderLabel)
        //ヘッダーのサイドアイコンを表示
        subHeaderRect.addSubview(eracePinkIcon)
        //ヘッダーにボタンを設置(反応する面積を大きくするために画像の上に透明なボタンを配置している)
        let erasePostOrgScreenButton = makeErasePostOrgScreenButton()
        self.view.addSubview(erasePostOrgScreenButton)
        self.view.addSubview(postOrgOverline)
        //所属団体が存在する場合に団体数に応じて領域を表示する。所属団体が存在しない場合は「グループが存在しません」と表示する。
        if UserDefaults.standard.array(forKey: "belongingOrgs") != nil {
            postBelongingOrgs = UserDefaults.standard.array(forKey: "belongingOrgs") as! [[String : Any?]]
        }
        if postBelongingOrgs.count >= 1 {
            for i in 1...postBelongingOrgs.count {
                //イメージビュー（投稿団体を表示するための領域）を設定して表示
                let postOrgRect:UIImageView = {
                    let image = makeWhiteRect(width: screenWidth, height: 54)
                    let imageView = UIImageView(image:image)
                    imageView.frame.origin = CGPoint(x: 0, y: 26+54*i)
                    return imageView
                }()
                self.view.addSubview(postOrgRect)
                //イメージビュー（投稿団体の下線）を設定して表示
                let orgUnderline:UIImageView = {
                    let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
                    let imageView = UIImageView(image: drawImage)
                    return imageView
                }()
                postOrgRect.addSubview(orgUnderline)
                //投稿団体名を設定して表示
                let postOrgLabel:UILabel = {
                    let label = UILabel()
                    label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
                    let labelTextAttr: [NSAttributedStringKey : Any] = [
                        .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
                        .foregroundColor:black,
                        ]
                    let labelText = NSAttributedString(string:"\(postBelongingOrgs[i-1]["name"] as! String)", attributes:labelTextAttr)
                    label.attributedText = labelText
                    return label
                }()
                postOrgRect.addSubview(postOrgLabel)
                //投稿団体の透明なボタンを作成するメソッド
                func makeDecidePostOrgButton() -> UIButton {
                    let button = UIButton()
                    button.frame = CGRect(x: 0, y: 26+54*i, width: Int(screenWidth), height: 54)
                    button.addTarget(self, action: #selector(PostOrgUIViewController.decidePostOrg(_:)), for: UIControlEvents.touchUpInside)
                    button.tag = i
                    return button
                }
                let decidePostOrgButton = makeDecidePostOrgButton()
                self.view.addSubview(decidePostOrgButton)
                //チェックマークは、表示はせずに設定だけしておく
                let postOrgCheckmark:UIImageView = {
                    let image = UIImage(named: "checkRed")
                    let imageView = UIImageView(image: image)
                    imageView.frame.origin = CGPoint(x: 18, y: 47+54*i)
                    imageView.frame.size = CGSize(width: 13.51, height: 12)
                    return imageView
                }()
                postOrgCheckmarks["\(i-1)"] = postOrgCheckmark
            }
        } else {
            //所属団体がない場合は、「所属団体がありません」と表示する。この時、ボタンは設置しないでおく
            
            
            
            
            
            
            
            
            //この辺変えるところから
            
            
            
            //イメージビュー（投稿団体を表示するための領域）を設定して表示
            let postOrgRect:UIImageView = {
                let image = makeWhiteRect(width: screenWidth, height: 54)
                let imageView = UIImageView(image:image)
                imageView.frame.origin = CGPoint(x: 0, y: 80)
                return imageView
            }()
            self.view.addSubview(postOrgRect)
            //イメージビュー（投稿団体の下線）を設定して表示
            let orgUnderline:UIImageView = {
                let drawImage = drawLine(x0:0, y0:54, x1:screenWidth, y1:54)
                let imageView = UIImageView(image: drawImage)
                return imageView
            }()
            postOrgRect.addSubview(orgUnderline)
            //投稿団体名を設定して表示
            let postOrgLabel:UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: 50, y: 21, width: screenWidth-60, height: 12)
                let labelTextAttr: [NSAttributedStringKey : Any] = [
                    .font:UIFont(name:"HiraKakuProN-W6", size: 12) ?? UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor:gray
                    ]
                let labelText = NSAttributedString(string:"所属団体がありません", attributes:labelTextAttr)
                label.attributedText = labelText
                return label
            }()
            postOrgRect.addSubview(postOrgLabel)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
