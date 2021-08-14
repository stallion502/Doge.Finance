/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CalendarPickerFooterView: UIView {

    lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .left
        button.setImage(UIImage(named: "left"), for: .normal)
        button.tintColor = .white

        button.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
        return button
    }()

    lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .right
        button.setImage(UIImage(named: "right"), for: .normal)
        button.titleLabel?.textColor = .label
        button.tintColor = .white

        button.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
        return button
    }()

    let monthLabel = UILabel()

    let didTapLastMonthCompletionHandler: (() -> Void)
    let didTapNextMonthCompletionHandler: (() -> Void)

    init(
        didTapLastMonthCompletionHandler: @escaping (() -> Void),
        didTapNextMonthCompletionHandler: @escaping (() -> Void)
    ) {
        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler

        super.init(frame: CGRect.zero)

        translatesAutoresizingMaskIntoConstraints = false

        layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        layer.cornerCurve = .continuous
        layer.cornerRadius = 15

        addSubview(previousMonthButton)
        addSubview(nextMonthButton)
        addSubview(monthLabel)
        monthLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        monthLabel.textColor = .white
        monthLabel.font = .systemFont(ofSize: 17, weight: .medium)
        monthLabel.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var previousOrientation: UIDeviceOrientation = UIDevice.current.orientation

    override func layoutSubviews() {
        super.layoutSubviews()

        let smallDevice = UIScreen.main.bounds.width <= 350

        let fontPointSize: CGFloat = smallDevice ? 14 : 17

        previousMonthButton.titleLabel?.font = .systemFont(ofSize: fontPointSize, weight: .medium)
        nextMonthButton.titleLabel?.font = .systemFont(ofSize: fontPointSize, weight: .medium)

        NSLayoutConstraint.activate([
            previousMonthButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            previousMonthButton.heightAnchor.constraint(equalTo: heightAnchor),
            previousMonthButton.widthAnchor.constraint(equalTo: previousMonthButton.heightAnchor),
            previousMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            nextMonthButton.heightAnchor.constraint(equalTo: heightAnchor),
            nextMonthButton.widthAnchor.constraint(equalTo: nextMonthButton.heightAnchor),
            nextMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

    @objc func didTapPreviousMonthButton() {
        didTapLastMonthCompletionHandler()
    }

    @objc func didTapNextMonthButton() {
        didTapNextMonthCompletionHandler()
    }
}
