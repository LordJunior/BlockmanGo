//
//  GameDetailViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/18.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

protocol GameDetailViewControllerDelegate: class {
    func gameDetailViewControllerDidClose(_ viewController: GameDetailViewController)
    func gameDetailViewControllerPlayGameButtonDidClicked(_ viewController: GameDetailViewController, gameID: String)
}

extension GameDetailViewControllerDelegate {
    func gameDetailViewControllerDidClose(_ viewController: GameDetailViewController) {
        TransitionManager.dismiss(animated: true)
    }
}

class GameDetailViewController: TemplateViewController {

    weak var delegate: GameDetailViewControllerDelegate?
    
    private weak var thumbnailImageView: NetImageView?
    private weak var nameLabel: UILabel?
    private weak var modeLabel: UILabel?
    private weak var likesButton: UIButton?
    private weak var playButton: UIButton?
    private weak var detailsTextView: UITextView?
    
    private let detailModelManager = GameDetailModelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let containView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(440)
            make.height.equalToSuperview().multipliedBy(0.9)
        }.configure { (containView) in
            containView.isUserInteractionEnabled = true
        }
        
        addCloseButton(layout: { (make) in
            make.size.equalTo(closeButtonSize)
            make.left.equalTo(containView.snp.right).offset(5)
            make.top.equalTo(containView)
        }) {[unowned self] (_)  in
            self.delegate?.gameDetailViewControllerDidClose(self)
        }
        
        thumbnailImageView = NetImageView().addTo(superView: containView).configure({ (imageView) in
            imageView.layer.cornerRadius = 18
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }).layout(snapKitMaker: { (make) in
            make.left.top.equalToSuperview().offset(22)
            make.size.equalTo(CGSize(width: 214, height: 120))
        })
        
        nameLabel = UILabel().addTo(superView: containView).configure({ (label) in
            label.font = UIFont.boldSize15
            label.textColor = R.clr.appColor._653e00()
            label.text = "Blockman Go"
        }).layout(snapKitMaker: { (make) in
            make.left.equalTo(thumbnailImageView!.snp.right).offset(14)
            make.top.equalTo(thumbnailImageView!).offset(19)
        })
        
        modeLabel = UILabel().addTo(superView: containView).configure({ (label) in
            label.font = UIFont.size10
            label.textColor = R.clr.appColor._c38039()
            label.text = "PVP | PVP | PVP"
        }).layout(snapKitMaker: { (make) in
            make.left.equalTo(thumbnailImageView!.snp.right).offset(14)
            make.top.equalTo(nameLabel!.snp.bottom).offset(10)
        })
        
        likesButton = UIButton().addTo(superView: containView).configure({ (button) in
            button.setBackgroundImage(R.image.game_like(), for: .normal)
            button.titleLabel?.font = UIFont.size10
            button.setTitle("0", for: .normal)
            button.setTitleColor(R.clr.appColor._653e00(), for: .normal)
            button.addTarget(self, action: #selector(likesButtonClicked), for: .touchUpInside)
            button.titleEdgeInsets = UIEdgeInsetsMake(14, 0, 0, 0)
            button.isEnabled = false
        }).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 42, height: 43))
            make.left.equalTo(thumbnailImageView!.snp.right).offset(10)
            make.top.equalTo(modeLabel!.snp.bottom).offset(10)
        })
        
        playButton = UIButton().addTo(superView: containView).configure({ (button) in
            button.setBackgroundImage(R.image.general_button_background_selected(), for: .normal)
            button.titleLabel?.font = UIFont.boldSize15
            button.setTitle(R.string.localizable.enter_game(), for: .normal)
            button.setTitleColor(R.clr.appColor._844501(), for: .normal)
            button.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0)
            button.addTarget(self, action: #selector(playButtonClicked), for: .touchUpInside)
            button.isEnabled = false
        }).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 126, height: 42))
            make.right.equalToSuperview().inset(22)
            make.top.equalTo(modeLabel!.snp.bottom).offset(10)
        })
        
        detailsTextView = UITextView().addTo(superView: containView).configure({ (textView) in
            textView.isEditable = false
            textView.textAlignment = .center
            textView.layer.cornerRadius = 18
            textView.clipsToBounds = true
            textView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5)
            textView.backgroundColor = R.clr.appColor._ead5b6()
            textView.showsVerticalScrollIndicator = false
        }).layout(snapKitMaker: { (make) in
            make.top.equalTo(thumbnailImageView!.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(22)
        })
        
        guard let (gameID, detailControllerDelegate) = self.parameter as? (String, GameDetailViewControllerDelegate) else {return}
        delegate = detailControllerDelegate
        detailModelManager.fetchGameDetails(gameID: gameID) { [weak self] (result) in
            switch result {
            case .success(let detailModel):
                self?.refreshViewsWithModel(detailModel)
            default:
                self?.playButton?.isEnabled = false
                self?.likesButton?.isEnabled = false
            }
        }
    }
    
    private func refreshViewsWithModel(_ detailModel: GameDetailModel) {
        playButton?.isEnabled = true
//        likesButton?.isEnabled = true
        thumbnailImageView?.imageWithUrlString(detailModel.gameCoverPic)
        nameLabel?.text = detailModel.gameTitle
        modeLabel?.text = detailModel.gameTypes.joined(separator: " | ")
        likesButton?.setTitle(String(detailModel.praiseNumber), for: .normal)
//        likesButton?.isEnabled = !detailModel.appreciate
        detailsTextView?.attributedText = detailModel.gameDetail
    }
    
    @objc private func likesButtonClicked() {
        AnalysisService.trackEvent(.click_like)
        detailModelManager.likesGame(gameID: (parameter as! (String, GameDetailViewControllerDelegate)).0) { (result) in
            switch result {
            case .success(let likesNumber):
                self.likesButton?.setTitle(String(likesNumber), for: .normal)
            case .failure(.alreadyAppreciated):
                self.likesButton?.isEnabled = false
                AlertController.alert(title: R.string.localizable.you_have_been_appreciate(), message: nil, from: self)
            default:
                AlertController.alert(title: R.string.localizable.common_request_fail_retry(), message: nil, from: self)
            }
        }
    }
    
    @objc private func playButtonClicked() {
        delegate?.gameDetailViewControllerPlayGameButtonDidClicked(self, gameID: (parameter as! (String, GameDetailViewControllerDelegate)).0)
    }
}
