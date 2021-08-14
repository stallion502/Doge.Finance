//
//  MainSelectorCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/16/21.
//

import UIKit

class MainSelectorCell: UITableViewCell {

    var elements: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!

    private var selectedIndexPath = IndexPath(row: 0, section: 0)

    var onSelectedIndexPath: ((IndexPath) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.register(UINib(nibName: "MainSelectorCollectionCell", bundle: .main), forCellWithReuseIdentifier: "MainSelectorCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension MainSelectorCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainSelectorCollectionCell", for: indexPath) as! MainSelectorCollectionCell
        cell.mainTitleLabel.text = elements[indexPath.row]
        cell.isSelected = indexPath == selectedIndexPath
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = elements[indexPath.row]
        let size = NSString(string: title).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)])
        let width = size.width + 16
        return CGSize(width: width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.reloadData()
        onSelectedIndexPath?(indexPath)
    }
}
