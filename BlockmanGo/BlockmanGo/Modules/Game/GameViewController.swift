//
//  GameViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
import BlockModsGameKit
import StoreKit

class GameViewController: UIViewController {

    private weak var collectionView: UICollectionView?
    private var gameModelManager = GameModelManager()
    private var isPresentedInQueue = false
    private var games: [GameModel] = []
    private var enteringGameID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIImageView(image: R.image.game_backgorund()).addTo(superView: view).layout { (make) in
            make.edges.equalToSuperview()
        }
        
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
            collectionView.dataSource = self
            collectionView.delegate = self
            self.view.insertSubview(collectionView, belowSubview: gameModesView)
        }.layout { (make) in
            make.left.equalTo(gameModesView.snp.right)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        UIImageView(image: R.image.game_mask()).configure { (imageView) in
            self.view.insertSubview(imageView, belowSubview: gameModesView)
        }.layout { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(75)
        }
        
        /// 返回按钮
        UIButton().addTo(superView: view).configure { (button) in
            button.setBackgroundImage(R.image.general_back(), for: .normal)
            button.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        }.layout { (make) in
            make.size.equalTo(CGSize(width: 45, height: 47))
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(30)
        }
        
        self.fetchGamesWithMode(0) /// 默认全部
    }
    
    @objc private func backButtonClicked() {
        DecorationControllerManager.shared.removeFromParent()
        TransitionManager.popViewController(animated: false)
    }
    
    @objc private func updateCollectionViewConstaint() {
        UIView.animate(withDuration: 0.35, animations: {
            self.collectionView?.alpha = 1.0
            self.collectionView?.transform = CGAffineTransform.identity
        })
    }
    
    private func fetchGamesWithMode(_ mode: Int) {
        BlockHUD.showLoading(inView: collectionView!)
        gameModelManager.fetchGamesWithMode(mode) { [weak self] (result) in
            if self != nil {
                self?.collectionView?.alpha = 0
                self?.collectionView?.transform = CGAffineTransform.init(translationX: 0, y: self!.view.height)
                BlockHUD.hide(forView: self!.collectionView!)
            }
            switch result {
            case .success(let games):
                self?.games = games
                self?.collectionView?.reloadData()
                delay(0.35, exeute: {
                    self?.updateCollectionViewConstaint()
                })
            case .failure(_):
                break
            }
        }
    }
    
    private func enterGame(gameID: String) {
        DecorationControllerManager.shared.destory()
        
        BlockHUD.showLoading(inView: view)
        enteringGameID = gameID /// 保存一份当前正在进入游戏的游戏id
        gameModelManager.enterGame(gameID) { (result) in
            BlockHUD.hide(forView: self.view)
            switch result {
            case .success(let dispatch):
                if self.isPresentedInQueue {
                    TransitionManager.dismiss(animated: false)
                }
                /// 进入游戏
                let gameController = BMGameViewController.init()
                gameController.bmDelegate = self
                gameController.userID = NSNumber.init(value: UInt64(UserManager.shared.userID) ?? 0)
                gameController.nickName = UserManager.shared.nickname
                gameController.userToken = dispatch.signature
                gameController.gameAddr = dispatch.gameAddr
                gameController.mapName = dispatch.mapID
                gameController.mapUrl = dispatch.mapURL
                gameController.gameTimestamp = NSNumber.init(value: dispatch.timestamp)
                gameController.language = Locale.current.identifier
                gameController.gameType = gameID
                self.present(gameController, animated:true, completion: nil)
            case .failure(.enterGameInQueue): /// 进入排队
                if !self.isPresentedInQueue {
                    self.isPresentedInQueue = true
                    TransitionManager.present(GameInQueueViewController.self, animated: false, parameter: self, completion: nil)
                }
            case .failure(.gameversionTooLow):
                AlertController.alert(title: R.string.localizable.game_version_too_low(), message: nil, from: TransitionManager.rootViewController, showCancelButton: true)?.done(completion: { _ in
                    let appstore = SKStoreProductViewController()
                    appstore.delegate = self
                    appstore.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : NSNumber(value: 1388175232)])
                    self.present(appstore, animated: true, completion: nil)
                }).cancel(completion: { (_) in
                    self.preloadDecorationView()
                })
            default:
                AlertController.alert(title: R.string.localizable.enter_game_fail_retry(), message: nil, from: TransitionManager.rootViewController)?.done(completion: { (_) in
                    self.preloadDecorationView()
                })
            }
        }
    }
    
    private func preloadDecorationView() {
        // 先提前创建好装饰view
        DecorationControllerManager.shared.add(toParent: self, layout: { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }) {
            DecorationControllerManager.shared.suspendRendering()
        }
    }
}

// MARK: UICollectionView代理及数据源
extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(forIndexPath: indexPath) as GameCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let gameCell = cell as! GameCollectionViewCell
        gameCell.delegate = self
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

// MARK: GameCollectionViewCell代理
extension GameViewController: GameCollectionViewCellDelegate {
    func gameCollectionCellPlayButtonDidClicked(_ cell: GameCollectionViewCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else {return}
        enterGame(gameID: games[indexPath.item].gameId)
    }
}

// MARK: SKStoreProductViewController代理
extension GameViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: 游戏模式view代理
extension GameViewController: GameModesViewDelegate {
    func gameModesView(_ modesView: GameModesView, didSelectModeAt index: Int) {
        fetchGamesWithMode(index)
    }
}

// MARK: 游戏详情控制器代理
extension GameViewController: GameDetailViewControllerDelegate {
    func gameDetailViewControllerPlayGameButtonDidClicked(_ viewController: GameDetailViewController, gameID: String) {
        TransitionManager.dismiss(animated: false, completion: nil)
        enterGame(gameID: gameID)
    }
}

// MARK: 游戏排队控制器代理
extension GameViewController: GameInQueueViewControllerDelegate {
    func gameInQueueViewControllerIntervalDidArrived(_ controller: GameInQueueViewController) {
        enterGame(gameID: enteringGameID) /// 排队计时触发
    }
    
    func gameInQueueViewControllerCancelButtonDidClicked(_ controller: GameInQueueViewController) {
        preloadDecorationView() /// 预先加载好装饰view
        isPresentedInQueue = false
        TransitionManager.dismiss(animated: false)
    }
}

// MARK: 游戏引擎控制器代理
extension GameViewController: BMGameViewControllerDelegate {
    func gameViewControllerdidDismissed(_ controller: BMGameViewController!, autoStartNextGame isAutoStart: Bool) {
        preloadDecorationView() /// 预先加载好装饰view
    }
}
