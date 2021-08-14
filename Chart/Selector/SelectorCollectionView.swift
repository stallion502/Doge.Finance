//
//  SelectorCollectionView.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/7/21.
//

import UIKit

class SelectorCollectionView: UICollectionView {

    private var titles: [String] = ["Dev wallet balance", "Dev wallet transactions", "Whale transactions"]// ["Buy", "Dev wallet balance", "Dev wallet transactions"]

    var onIndexPathSelect: (Int) -> Void = { _ in }

    override func awakeFromNib() {
        register(UINib(nibName: "SelectorCollectionCell", bundle: .main), forCellWithReuseIdentifier: "SelectorCollectionCell")
        delegate = self
        dataSource = self
    }
}

extension SelectorCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectorCollectionCell", for: indexPath) as! SelectorCollectionCell
        cell.setup(with: titles[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = titles[indexPath.row]
        let size = NSString(string: titles[indexPath.row]).size(withAttributes: [.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        let width = title == "Buy" ? size.width + 20 : size.width + 16
        return CGSize(width: width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onIndexPathSelect(indexPath.row)
    }
}
