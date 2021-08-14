//
//  PreviousSearchesCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/12/21.
//

import UIKit

class PreviousSearchesCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    var searches: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var onSelectSearch: (String) -> Void = { _ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.register(UINib(nibName: "SearchCollectionCell", bundle: .main), forCellWithReuseIdentifier: "SearchCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension PreviousSearchesCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionCell", for: indexPath) as! SearchCollectionCell
        cell.titleLabel.text = searches[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = searches[indexPath.row]
        let size = NSString(string: title).size(withAttributes: [.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        let width = size.width + 16
        return CGSize(width: width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectSearch(searches[indexPath.row])
    }
}
