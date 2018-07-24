//
//  GameViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
import SnapKit

class GameViewController: UIViewController {

    private var collectionViewToSuperTopConstraint: Constraint?
    private weak var collectionView: UICollectionView?
    private var gameModelManager = GameModelManager()
    
    private var games: [GameModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.contents = R.image.game_backgorund()?.cgImage
        
        let gameModesView = GameModesView().addTo(superView: view).layout { (make) in
            make.left.bottom.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.width.equalTo(140)
        }.configure { (modesView) in
            modesView.delegate = self
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).configure { (collectionView) in
            collectionView.register(cellForClass: GameCollectionViewCell.self)
            collectionView.backgroundColor = UIColor.clear
            collectionView.showsVerticalScrollIndicator = false
            collectionView.alpha = 0
            collectionView.dataSource = self
            collectionView.delegate = self
            self.view.insertSubview(collectionView, belowSubview: gameModesView)
        }.layout { (make) in
            make.left.equalTo(gameModesView.snp.right)
            self.collectionViewToSuperTopConstraint = make.top.equalToSuperview().offset(self.view.height * 0.5).constraint
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        UIImageView(image: R.image.game_mask()).configure { (imageView) in
            self.view.insertSubview(imageView, belowSubview: gameModesView)
        }.layout { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(75)
        }
        
        // 返回按钮
        UIButton().addTo(superView: view).configure { (button) in
            button.setBackgroundImage(R.image.general_back(), for: .normal)
            button.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        }.layout { (make) in
            make.size.equalTo(CGSize(width: 45, height: 47))
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(30)
        }
        
        fetchGamesWithMode(0) // 默认全部
        perform(#selector(updateCollectionViewConstaint), with: nil, afterDelay: 0.5)
    }
    
    @objc private func backButtonClicked() {
        TransitionManager.popViewController(animated: false)
    }
    
    @objc private func updateCollectionViewConstaint() {
        self.collectionViewToSuperTopConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.25, animations: {
            self.collectionView?.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func fetchGamesWithMode(_ mode: Int) {
        gameModelManager.fetchGamesWithMode(mode) { [weak self] (result) in
            switch result {
            case .success(let games):
                self?.games = games
                self?.collectionView?.reloadData()
            case .failure(_):
                break
            }
        }
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(forIndexPath: indexPath) as GameCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let gameCell = cell as! GameCollectionViewCell
        gameCell.gameName = games[indexPath.item].gameTitle
        gameCell.gameMode = games[indexPath.item].gameTypes.joined(separator: " | ")
        gameCell.thumbnailURLString = games[indexPath.item].gameCoverPic
        gameCell.playingNumber = games[indexPath.item].onlineNumber
        gameCell.likesNumber = games[indexPath.item].praiseNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TransitionManager.present(GameDetailViewController.self, animated: false, parameter: (games[indexPath.row].gameId, self))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.width - 8 - 5 - 25) / 2, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension GameViewController: GameModesViewDelegate {
    func gameModesView(_ modesView: GameModesView, didSelectModeAt index: Int) {
        fetchGamesWithMode(index)
    }
}

extension GameViewController: GameDetailViewControllerDelegate {
    func gameDetailViewControllerPlayGameButtonDidClicked(_ viewController: GameDetailViewController, gameID: String) {
        
    }
}
