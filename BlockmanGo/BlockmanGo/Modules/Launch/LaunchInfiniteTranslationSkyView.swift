//
//  LaunchInfiniteTranslationSkyView.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/18.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

final class LaunchInfiniteTranslationSkyView: UIView {

    private weak var collectionView: UICollectionView?
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).addTo(superView: self).configure { (collectionView) in
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(cellForClass: InfiniteTranslationSkyColletionViewCell.self)
            collectionView.backgroundColor = UIColor.clear
            collectionView.isUserInteractionEnabled = false
            collectionView.bounces = false
        }.layout { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startTranslating() {
        guard timer == nil else { return }
        
//        let displayLink = CADisplayLink(target: self, selector: #selector(scrollSkyView))
//        displayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(scrollSkyView), userInfo: nil, repeats: true)
    }
    
    func stopTranslating() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func scrollSkyView() {
        guard let offset = collectionView?.contentOffset else {
            return
        }
        guard offset.x + width < collectionView!.contentSize.width else {
            stopTranslating()
            return
        }
        collectionView?.setContentOffset(CGPoint(x: offset.x + 2, y: offset.y), animated: false)
    }
}

extension LaunchInfiniteTranslationSkyView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(forIndexPath: indexPath) as InfiniteTranslationSkyColletionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

private class InfiniteTranslationSkyColletionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        UIImageView(image: R.image.launch_sky()).addTo(superView: contentView).layout { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
