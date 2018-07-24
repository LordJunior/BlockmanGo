//
//  GameCollectionViewCell.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

protocol GameCollectionViewCellDelegate: class {
    func gameCollectionCellPlayButtonDidClicked(_ cell: GameCollectionViewCell)
}

class GameCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: GameCollectionViewCellDelegate?
    
    var gameName: String? = nil {
        didSet {
            nameLabel?.text = gameName
        }
    }
    
    var gameMode: String? = nil {
        didSet {
            modeLabel?.text = gameMode
        }
    }
    
    var thumbnailURLString: String? = nil {
        didSet {
            thumbnailView?.imageWithUrlString(thumbnailURLString)
        }
    }
    
    var playingNumber: Int? = nil {
        didSet {
            playingLabel?.text = "\(playingNumber ?? 0) Playing"
        }
    }

    var likesNumber: Int? = nil {
        didSet {
            likesView?.setTitle("\(playingNumber ?? 0)", for: .normal)
        }
    }
    
    private weak var thumbnailView: NetImageView?
    private weak var nameLabel: UILabel?
    private weak var modeLabel: UILabel?
    private weak var playingLabel: ExtraSizeLabel?
    private weak var likesView: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let backgroundImageView = UIImageView(image: R.image.game_item_background()).addTo(superView: contentView).layout { (make) in
            make.edges.equalToSuperview()
        }
        
        thumbnailView = NetImageView(image: R.image.common_default_userimage()).addTo(superView: backgroundImageView).layout(snapKitMaker: { (make) in
            make.left.top.equalToSuperview().offset(2)
            make.size.equalTo(CGSize(width: 90, height: 91))
        }).configure({ (imageView) in
            let layer = CAShapeLayer()
            layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 90, height: 91), byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft], cornerRadii: CGSize(width: 6, height: 6)).cgPath
            imageView.layer.mask = layer
        })
        
        playingLabel = ExtraSizeLabel().addTo(superView: thumbnailView!).configure({ (label) in
            label.textColor = UIColor.white
            label.font = UIFont.size10
            label.text = "1245在玩"
            label.extraWidth = 10
            label.extraHeight = 5
            label.layer.cornerRadius = 6
            label.clipsToBounds = true
            label.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        }).layout(snapKitMaker: { (make) in
            make.left.top.equalToSuperview().offset(2)
        })
        
        nameLabel = UILabel().addTo(superView: backgroundImageView).configure({ (label) in
            label.textColor = R.clr.appColor._653e00()
            label.font = UIFont.boldSize13
            label.text = "垃圾游戏"
        }).layout(snapKitMaker: { (make) in
            make.left.equalTo(thumbnailView!.snp.right).offset(12)
            make.top.equalToSuperview().offset(18)
        })
        
        modeLabel = UILabel().addTo(superView: backgroundImageView).configure({ (label) in
            label.textColor = R.clr.appColor._c38039()
            label.font = UIFont.size9
            label.text = "PVP | PVP | PVP"
        }).layout(snapKitMaker: { (make) in
            make.left.equalTo(thumbnailView!.snp.right).offset(12)
            make.top.equalTo(nameLabel!.snp.bottom).offset(6)
        })
        
        likesView = UIButton().addTo(superView: backgroundImageView).configure({ (button) in
            button.isUserInteractionEnabled = false
            button.setImage(R.image.game_like_number(), for: .normal)
            button.setTitle("00", for: .normal)
            button.setTitleColor(R.clr.appColor._c38039(), for: .normal)
            button.titleLabel?.font = UIFont.size9
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        }).layout(snapKitMaker: { (make) in
            make.left.equalTo(thumbnailView!.snp.right).offset(12)
            make.top.equalTo(modeLabel!.snp.bottom).offset(6)
        })
        
        UIButton().addTo(superView: backgroundImageView).configure({ (button) in
            button.setBackgroundImage(R.image.game_play(), for: .normal)
            button.addTarget(self, action: #selector(playButtonDidClicked), for: .touchUpInside)
        }).layout(snapKitMaker: { (make) in
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(12)
            make.size.equalTo(CGSize(width: 30, height: 33))
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func playButtonDidClicked() {
        delegate?.gameCollectionCellPlayButtonDidClicked(self)
    }
}
