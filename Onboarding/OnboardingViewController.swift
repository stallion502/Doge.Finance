//
//  OnboardingViewController.swift
//  LoriCoin
//
//  Created by Pozdnyshev Maksim on 7/23/21.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dogeImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.setValue(true, forKey: "onboarding")
        let banners = [Banner(image: "https://i.ibb.co/3cMBVSL/banner-Binance.png", url: "https://google.com")]
        FirDatabaseService.shared.setBanners(banners)
        
        dogeImageView.transform = CGAffineTransform(translationX: 0, y: 150)
        UIView.animate(withDuration: 1.0, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: { [weak self] in
                self?.dogeImageView.transform = .identity
            }, completion: nil)

        collectionView.register(UINib(nibName: "OnboardingCell", bundle: .main), forCellWithReuseIdentifier: "OnboardingCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        cell.setup(with: indexPath.row)
        cell.onContinuePressed = { [indexPath] in
            if indexPath.row == 3 {
                UIViewController.setRootController(TabbarController())
            } else {
                collectionView.scrollToItem(at: IndexPath(row: indexPath.row + 1, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let xPosition = scrollView.contentOffset.x
        guard width != 0 else {
            pageControl.currentPage = 0
            return
        }
        pageControl.currentPage = Int(xPosition / width)
    }
}
