//
//  BannersCarouselCell.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/16/21.
//

import UIKit

class BannersCarouselCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var banners: [Banner] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.register(UINib(nibName: "BannerCollectionCell", bundle: .main), forCellWithReuseIdentifier: "BannerCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        let frame = UIScreen.main.bounds.width - 32
        collectionViewHeightConstraint.constant = frame / 2.138
    }
}

extension BannersCarouselCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionCell", for: indexPath) as! BannerCollectionCell
        if let image = UIImage(named: banners[indexPath.row].image) {
            cell.imageView.image = image
        } else {
            cell.imageView.sd_setImage(with: URL(string: banners[indexPath.row].image), completed: nil)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: banners[indexPath.row].url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
