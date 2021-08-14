//
//  PagesViewController.swift
//  KazanExpress
//
//  Created by Pozdnyshev Maksim on 23/09/2019.
//  Copyright © 2019 Позднышев Максим. All rights reserved.
//

import Foundation
import UIKit

protocol PageViewControllerDelegate: class {
    func indexDidChanged(index: Int)
}

class PageViewController: UIPageViewController
{
    private lazy var _pages: [UIViewController] = []

    private weak var _delegate: PageViewControllerDelegate?

    var currentIndex: Int = 0

    var isScrollEnabled: Bool = true {
        didSet {
            let scrollView = view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
            scrollView.isScrollEnabled = isScrollEnabled
        }
    }

    @discardableResult

    class func insert(
        rootController: UIViewController,
        pages: [UIViewController],
        delegate: PageViewControllerDelegate? = nil,
        containerView: UIView? = nil
    ) -> PageViewController {

        let pages = PageViewController(
            pages: pages,
            delegate: delegate
        )
        rootController.addChild(pages)

        var calculatedFrame: CGRect

        if let containerView = containerView {
            containerView.addSubview(pages.view)
            calculatedFrame = containerView.bounds
        }
        else {
            rootController.view.addSubview(pages.view)
            calculatedFrame = pages.view.bounds
        }
        pages.view.frame = calculatedFrame
        pages.didMove(toParent: rootController)

        return pages
    }

    private init(
        pages: [UIViewController],
        delegate: PageViewControllerDelegate? = nil
    ) {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        _pages = pages
        _delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad()
    {

        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self

        if let firstVC = _pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    func setCurrentIndex(_ index: Int) {
        let indexOld = _pages.index(of: viewControllers!.first!) ?? 0
        setViewControllers(
            [_pages[index]],
            direction: indexOld < index ? .forward : .reverse,
                animated: true,
                completion: nil
        )
    }
}

extension PageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = _pages.index(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0          else { return nil }

        guard _pages.count > previousIndex else { return nil }

        return _pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = _pages.index(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < _pages.count else { return nil }

        guard _pages.count > nextIndex else { return nil }

        return _pages[nextIndex]
    }
}


extension PageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllerIndex = _pages.index(of: pageViewController.viewControllers!.first!), completed else {
                return
            }

        _delegate?.indexDidChanged(index: viewControllerIndex)
        currentIndex = viewControllerIndex
    }
}
