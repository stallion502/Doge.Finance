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

enum CalendatAlingment {
    case left
    case right
    case center
    case centerAlone
}

class CalendarDateCollectionViewCell: UICollectionViewCell {
    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .mainGreen
        return view
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        return label
    }()

    private lazy var accessibilityDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return dateFormatter
    }()

    var alingment: CalendatAlingment = .center
    var day: Day?

    func setupWith(day: Day?, alingment: CalendatAlingment) {
        self.day = day
        self.alingment = alingment
        numberLabel.text = day?.number
        updateSelectionStatus()

        let corner = 45 / 2
        selectionBackgroundView.layer.mask = nil
        switch alingment {
        case .center:
            selectionBackgroundView.layer.cornerRadius = 0
        case .left:
            selectionBackgroundView.roundCorners(.left, radius: CGFloat(corner))
        case .right:
            selectionBackgroundView.roundCorners(.right, radius: CGFloat(corner))
        case .centerAlone:
            selectionBackgroundView.layer.cornerRadius = CGFloat(corner)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(selectionBackgroundView)
        addSubview(numberLabel)

        selectionBackgroundView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.center.equalToSuperview()
            $0.height.equalTo(45)
        }

        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
}

// MARK: - Appearance
private extension CalendarDateCollectionViewCell {
    // 1
    func updateSelectionStatus() {
        guard let day = day else { return }

        if day.isSelected {
            applySelectedStyle()
        } else {
            applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
        }
    }
    // 3
    func applySelectedStyle() {

        numberLabel.textColor = .white
        selectionBackgroundView.isHidden = false
    }

    // 4
    func applyDefaultStyle(isWithinDisplayedMonth: Bool) {

        numberLabel.textColor = isWithinDisplayedMonth ? .white : .lightGray
        selectionBackgroundView.isHidden = true
    }
}
