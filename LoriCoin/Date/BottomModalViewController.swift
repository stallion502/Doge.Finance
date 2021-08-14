//
//  BottomModalViewController.swift
//  EnergyApp
//
//  Created by Pozdnyshev Maksim on 3/22/21.
//

import UIKit
import SnapKit

struct Day {
    let date: Date
    let number: String
    var isSelected: Bool
    let isWithinDisplayedMonth: Bool
}

struct MonthMetadata {
  let numberOfDays: Int
  let firstDay: Date
  let firstDayWeekday: Int
}


protocol BottomModalViewControllerDelegate: class {
    func didSelectDateRange(_ range: (Day?, Day?))
}

class BottomModalViewController: UIViewController {

    // MARK: - Instance Properties

    var containerView: UIView = .init()
    var containerHeight: CGFloat { 566 }
    var keyboardHeight: CGFloat { return 0 }
    var canBeDraggble: Bool {
        return true
    }

    weak var delegate: BottomModalViewControllerDelegate?

    var additionaAnimatedView: [UIView] {
        return []
    }

    private let closeButton = UIButton()

    private var isDidLoaded: Bool = false

    private lazy var dayRange: (Day?, Day?) = (generateDaysInMonth(for: baseDate).first(where: { $0.isSelected }), nil)

//    private let labelsColelcti TODO

    lazy var bottomContainerView: UIView = {

        let line = UIView()
        line.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        line.layer.cornerRadius = 3

        let label = UILabel()
        label.text = "Дата"
        label.font = .systemFont(ofSize: 30, weight: .semibold)

        let view = UIView()
        view.backgroundColor = UIColor.hex("212121")
        view.addSubview(containerView)
        [line, closeButton, label].forEach(view.addSubview)
        line.snp.makeConstraints {
            $0.top.equalToSuperview().offset(canBeDraggble ? 9 : 0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(6)
            $0.width.equalTo(44)
        }

        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().offset(17)
            $0.right.equalToSuperview().inset(21)
        }

        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.left.equalToSuperview().inset(21)
        }

        closeButton.setImage(UIImage(named: "closeCalendar"), for: .normal)

        return view
    }()

    private lazy var headerView = CalendarPickerFooterView(
        didTapLastMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }

            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: -1,
                to: self.baseDate
            ) ?? self.baseDate
        },
        didTapNextMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }

            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: 1,
                to: self.baseDate
            ) ?? self.baseDate
        })


    // MARK: Calendar Data Values

//    private let selectedDate: Date
    private var baseDate: Date = .init() {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            collectionView.reloadData()

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            let nameOfMonth = dateFormatter.string(from: baseDate)
            headerView.monthLabel.text = nameOfMonth
        }
    }

    private let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainGreen
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Применить", for: .normal)
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            CalendarDateCollectionViewCell.self,
            forCellWithReuseIdentifier: "CalendarDateCollectionViewCell"
        )
        return collectionView
    }()

    private lazy var days = generateDaysInMonth(for: baseDate)

    private var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }

    private let selectedDateChanged: ((Date) -> Void) = { _ in }
    private let calendar = Calendar(identifier: .gregorian)

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()

    var isPresenting = false

    private let containerTopOffset = CGFloat(24)
    var containerTotalHeight: CGFloat { containerTopOffset + containerHeight + UIView.bottomSafeAreaHeight }

    private lazy var backdropView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()

    private let interactor = Interactor()

    init() {
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        if canBeDraggble {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
            panGesture.isEnabled = canBeDraggble
            view.addGestureRecognizer(panGesture)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)

        view.backgroundColor = .clear
        [backdropView, bottomContainerView].forEach(view.addSubview)

        bottomContainerView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(containerTotalHeight)
        }

        containerView.backgroundColor = .clear
        bottomContainerView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(containerTopOffset)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(containerHeight)
        }

        containerView.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(55)
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(44)
        }

        containerView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }

        confirmButton.addTarget(self, action: #selector(confirmaDateRange), for: .touchUpInside)

        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(66)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: baseDate)
        headerView.monthLabel.text = nameOfMonth
        isDidLoaded = true
    }

    @objc private func confirmaDateRange() {
        dismiss(animated: true, completion: nil)
        delegate?.didSelectDateRange(dayRange)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 14)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3

        let translation = sender.translation(in: bottomContainerView)
        let verticalMovement = translation.y / containerTotalHeight - keyboardHeight
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)

        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)

        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)

        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()

        default:
            break
        }
    }
}

extension BottomModalViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : nil
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }

        isPresenting.toggle()

        if isPresenting == true {
            transitionContext.containerView.addSubview(toVC.view)

            additionaAnimatedView.forEach { $0.frame.origin.y += containerTotalHeight }
            bottomContainerView.frame.origin.y += containerTotalHeight
            backdropView.alpha = 0

            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                animations: {
                    self.additionaAnimatedView.forEach {
                        $0.frame.origin.y -= self.containerTotalHeight
                    }
                    self.bottomContainerView.frame.origin.y -= self.containerTotalHeight
                    self.backdropView.alpha = 1
                },
                completion: { (finished) in
                    transitionContext.completeTransition(true)
                }
            )
        } else {

            let showedY = self.bottomContainerView.frame.origin.y

            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                animations: {
                    self.additionaAnimatedView.forEach {
                        $0.frame.origin.y += self.containerTotalHeight
                    }
                    self.bottomContainerView.frame.origin.y += self.containerTotalHeight
                    self.backdropView.alpha = 0
                },
                completion: { (finished) in
                    if transitionContext.transitionWasCancelled {
                        transitionContext.completeTransition(false)
                        self.additionaAnimatedView.forEach {
                            $0.frame.origin.y = showedY
                        }
                        self.bottomContainerView.frame.origin.y = showedY
                        self.backdropView.alpha = 1
                        self.isPresenting = true

                    } else {
                        transitionContext.completeTransition(true)
                    }
                }
            )
        }
    }
}

class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}


// MARK: - Day Generation
extension BottomModalViewController {
    // 1
    func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        // 2
        guard
            let numberOfDaysInMonth = calendar.range(
                of: .day,
                in: .month,
                for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            // 3
            throw CalendarDataError.metadataGeneration
        }

        // 4
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        // 5
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }

    // 1
    func generateDaysInMonth(for baseDate: Date) -> [Day] {
        // 2
        guard let metadata = try? monthMetadata(for: baseDate) else {
            preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
        }

        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay

        // 3
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
            .map { day in
                // 4
                let isWithinDisplayedMonth = day >= offsetInInitialRow
                // 5
                let dayOffset =
                    isWithinDisplayedMonth ?
                    day - offsetInInitialRow :
                    -(offsetInInitialRow - day)

                // 6
                return generateDay(
                    offsetBy: dayOffset,
                    for: firstDayOfMonth,
                    isWithinDisplayedMonth: isWithinDisplayedMonth)
            }

        days += generateStartOfNextMonth(using: firstDayOfMonth)

        return days
    }

    // 7
    func generateDay(
        offsetBy dayOffset: Int,
        for baseDate: Date,
        isWithinDisplayedMonth: Bool
    ) -> Day {
        let date = calendar.date(
            byAdding: .day,
            value: dayOffset,
            to: baseDate)
            ?? baseDate

        return Day(
            date: date,
            number: dateFormatter.string(from: date),
            isSelected: !isDidLoaded ? false : calendar.isDate(date, inSameDayAs: .init()), // TODO
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }

    // 1
    func generateStartOfNextMonth(
        using firstDayOfDisplayedMonth: Date
    ) -> [Day] {
        // 2
        guard
            let lastDayInMonth = calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: firstDayOfDisplayedMonth)
        else {
            return []
        }

        // 3
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }

        // 4
        let days: [Day] = (1...additionalDays)
            .map {
                generateDay(
                    offsetBy: $0,
                    for: lastDayInMonth,
                    isWithinDisplayedMonth: false)
            }

        return days
    }

    enum CalendarDataError: Error {
        case metadataGeneration
    }
}

// MARK: - UICollectionViewDataSource
extension BottomModalViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        days.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        var day = days[indexPath.row]

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CalendarDateCollectionViewCell",
            for: indexPath) as! CalendarDateCollectionViewCell

        var alingment: CalendatAlingment
        if dayRange.0?.date == day.date && dayRange.1 != nil {
            alingment = .left
        } else if dayRange.1?.date == day.date {
            alingment = .right
        } else if dayRange.1 == nil {
            alingment = .centerAlone
        } else {
            alingment = .center
        }
        if let firstDate = dayRange.0, let secondDate = dayRange.1, firstDate.date <= day.date, day.date <= secondDate.date {
            day.isSelected = true
        }
        cell.setupWith(day: day, alingment: alingment)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BottomModalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if dayRange.0 != nil && dayRange.1 != nil {
            for i in 0..<days.count {
                days[i].isSelected = false
            }
            dayRange.0 = days[indexPath.row]
            days[indexPath.row].isSelected = true
            dayRange.1 = nil
        } else if let firstDate = dayRange.0 {
            if firstDate.date > days[indexPath.row].date {
                dayRange.1 = dayRange.0
                dayRange.0 = days[indexPath.row]
            } else {
                dayRange.1 = days[indexPath.row]
            }
            dayRange.0?.isSelected = true
            dayRange.1?.isSelected = true
        }
        self.collectionView.performBatchUpdates {
            self.collectionView.reloadSections(IndexSet([0]))
        } completion: { _ in
            print("")
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = CGFloat((UIScreen.main.bounds.width - 88) / 7)
        let height = CGFloat(collectionView.frame.height) / CGFloat(numberOfWeeksInBaseDate)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UIView {
    static var bottomSafeAreaHeight: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
}
