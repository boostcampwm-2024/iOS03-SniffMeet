//
//  ProfileInputView.swift
//  SniffMeet
//
//  Created by 배현진 on 11/10/24.
//

import Combine
import UIKit

protocol ProfileInputViewable: AnyObject {
    var presenter: ProfileInputPresentable? { get set }
}

final class ProfileInputViewController: BaseViewController, ProfileInputViewable {
    typealias KeywordButtonsTuple = (selected: [KeywordButton], unselected: [KeywordButton])
    var presenter: ProfileInputPresentable?
    private var cancellables = Set<AnyCancellable>()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Context.titleLabel
        label.textColor = SNMColor.mainNavy
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: .init(24), weight: .heavy)
        return label
    }()
    private var nameTextField: InputTextField = InputTextField(placeholder: Context.namePlaceholder)
    private var ageTextField: InputTextField = InputTextField(placeholder: Context.agePlaceholder)
    
    private var sexSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.sexLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    
    private var sexSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Context.sexArr)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var sexUponIntakeSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.sexUponIntakeLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var sexUponIntakeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Context.sexUponIntakeArr)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var sizeSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.sizeLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var sizeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Context.sizeArr)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }

    private var keywordSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.keywordLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var keywordStackView = UIStackView()
    
    private var activeKeywordButton = KeywordButton(title: Context.activeKeywordLabel)
    private var smartKeywordButton = KeywordButton(title: Context.smartKeywordLabel)
    private var friendlyKeywordButton = KeywordButton(title: Context.friendlyKeywordLabel)
    private var shyKeywordButton = KeywordButton(title: Context.shyKeywordLabel)
    private var independentKeywordButton = KeywordButton(title: Context.independentKeywordLabel)
    
    private var nextButton = PrimaryButton(title: Context.nextBtnTitle)
    
    private var keywordButtons: [KeywordButton] {
        [activeKeywordButton,
         smartKeywordButton,
         friendlyKeywordButton,
         shyKeywordButton,
         independentKeywordButton]
    }
    private var keywordButtonsSplitBySelected: KeywordButtonsTuple {
        var selectedKeywordButtons: [KeywordButton] = []
        var unselectedKeywordButtons: [KeywordButton] = []
        
        keywordButtons.forEach {
            if $0.isSelected { selectedKeywordButtons.append($0) }
            else { unselectedKeywordButtons.append($0) }
        }
        return (selected: selectedKeywordButtons, unselected: unselectedKeywordButtons)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNextButtonState()
        hideKeyboardWhenTappedAround()
        setButtonAction()
        setTextFields()
    }
    
    override func configureAttributes() {
        
    }
    override func configureHierachy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [scrollView, contentView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [activeKeywordButton,
         smartKeywordButton,
         friendlyKeywordButton,
         shyKeywordButton,
         independentKeywordButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            keywordStackView.addArrangedSubview($0)
        }
        
        [titleLabel,
         nameTextField,
         ageTextField,
         sexSelectionLabel,
         sexSegmentedControl,
         sexUponIntakeSelectionLabel,
         sexUponIntakeSegmentedControl,
         sizeSelectionLabel,
         sizeSegmentedControl,
         keywordSelectionLabel,
         keywordStackView,
         nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        var height = view.safeAreaLayoutGuide.owningView?.bounds.height ?? view.bounds.height
        height -= topbarHeight
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(
                equalToConstant: max(Context.contentViewHeight, height - 100)),
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                            constant: Context.basicVerticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: Context.horizontalPadding)
        ])
        
        configureTextFieldConstraints()
        configureSelectionViewConstraints()
        configureButtonConstraints()
    }
}

private extension ProfileInputViewController {
    func configureTextFieldConstraints() {
        NSLayoutConstraint.activate([
        nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: LayoutConstant.xlargeVerticalPadding),
        nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Context.horizontalPadding),
        nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -Context.horizontalPadding),
        ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,
                                          constant: Context.largeVerticalPadding),
        ageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: Context.horizontalPadding),
        ageTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -Context.horizontalPadding)
        ])
    }
    func configureSelectionViewConstraints() {
        NSLayoutConstraint.activate([
            sexSelectionLabel.topAnchor.constraint(equalTo: ageTextField.bottomAnchor,
                                                    constant: Context.largeVerticalPadding),
            sexSelectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                        constant: Context.horizontalPadding),

            sexSegmentedControl.topAnchor.constraint(equalTo: sexSelectionLabel.bottomAnchor,
                                                  constant: Context.basicVerticalPadding),
            sexSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: Context.horizontalPadding),
            sexSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -Context.horizontalPadding),

            sexUponIntakeSelectionLabel.topAnchor.constraint(
                equalTo: sexSegmentedControl.bottomAnchor,
                constant: Context.largeVerticalPadding),
            sexUponIntakeSelectionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Context.horizontalPadding),

            sexUponIntakeSegmentedControl.topAnchor.constraint(
                equalTo: sexUponIntakeSelectionLabel.bottomAnchor,
                constant: Context.basicVerticalPadding),
            sexUponIntakeSegmentedControl.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Context.horizontalPadding),
            sexUponIntakeSegmentedControl.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Context.horizontalPadding),

            sizeSelectionLabel.topAnchor.constraint(
                equalTo: sexUponIntakeSegmentedControl.bottomAnchor,
                constant: Context.largeVerticalPadding),
            sizeSelectionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Context.horizontalPadding),

            sizeSegmentedControl.topAnchor.constraint(
                equalTo: sizeSelectionLabel.bottomAnchor,
                constant: Context.basicVerticalPadding),
            sizeSegmentedControl.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Context.horizontalPadding),
            sizeSegmentedControl.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Context.horizontalPadding)
        ])
    }
    func configureButtonConstraints() {
        keywordStackView.spacing = Context.smallVerticalPadding
        keywordStackView.axis = .horizontal
        keywordStackView.distribution = .fillProportionally
        
        NSLayoutConstraint.activate([
            keywordSelectionLabel.topAnchor.constraint(
                equalTo: sizeSegmentedControl.bottomAnchor,
                constant: Context.largeVerticalPadding),
            keywordSelectionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Context.horizontalPadding),
            
            keywordStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Context.horizontalPadding),
            keywordStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Context.horizontalPadding),
            keywordStackView.topAnchor.constraint(
                equalTo: keywordSelectionLabel.bottomAnchor,
                constant: Context.basicVerticalPadding),
            keywordStackView.heightAnchor.constraint(equalToConstant: 30)
            
        ])
       NSLayoutConstraint.activate([
           nextButton.bottomAnchor.constraint(
               equalTo: contentView.bottomAnchor,
               constant: -32),
           nextButton.leadingAnchor.constraint(
               equalTo: contentView.leadingAnchor,
               constant: Context.horizontalPadding),
           nextButton.trailingAnchor.constraint(
               equalTo: contentView.trailingAnchor,
               constant: -Context.horizontalPadding),
           nextButton.heightAnchor.constraint(equalToConstant: 52)
       ])
   }
    func setButtonAction() {
        // MARK: - submit(다음으로) 버튼에 대한 액션
        nextButton.addAction(UIAction { [weak self] _ in
            guard let selectedSexIdx = self?.sexSegmentedControl.selectedSegmentIndex,
                  var selectedSexUponIntakeIdx = self?.sexSegmentedControl.selectedSegmentIndex,
                  let selectedSizeIdx = self?.sizeSegmentedControl.selectedSegmentIndex
            else {
                SNMLogger.error("ProfileInputViewController: SelectedIdx Error")
                return
            }

            let sexUponIntake: Bool = selectedSexUponIntakeIdx > 0 ? false : true
            guard let name = self?.nameTextField.text,
                  let ageText = self?.ageTextField.text,
                  let age = UInt8(ageText),
                  let sex = Sex(rawValue: Context.sexArr[selectedSexIdx]),
                  let size = Size(rawValue: Context.sizeArr[selectedSizeIdx])
            else { return }
            
            guard let keywordButtons = self?.keywordButtons else { return }
            let keywords: [Keyword] = keywordButtons.filter{ $0.isSelected }.compactMap{
                guard let text = $0.titleLabel?.text else { return nil }
                return Keyword(rawValue: text)
            }
            
            let dogInfo = DogInfo(name: name,
                                        age: age,
                                        sex: sex,
                                        sexUponIntake: sexUponIntake,
                                        size: size,
                                        keywords: keywords)
            self?.presenter?.moveToProfileCreateView(with: dogInfo)
        }, for: .touchUpInside)
        
        // MARK: - keyword 버튼에 대한 액션
        keywordStackView.subviews.forEach{
            guard let button = $0 as? KeywordButton else {
                return
            }
            button.publisher(event: .touchUpInside).sink{ [weak self] in
                guard let selectedKeywordButtons = self?.keywordButtonsSplitBySelected.selected,
                      let unselectedKeywordButtons = self?.keywordButtonsSplitBySelected.unselected
                else { return }
                
                let selectedKeywordButtonsCount = selectedKeywordButtons.count
                if selectedKeywordButtonsCount == 2 {
                    unselectedKeywordButtons.forEach{ $0.isEnabled = false }
                } else if selectedKeywordButtonsCount < 2 {
                    unselectedKeywordButtons.filter{ $0.isEnabled == false }.forEach{
                        $0.isEnabled = true
                    }
                }
                self?.updateNextButtonState(keywordBtnSelected: !selectedKeywordButtons.isEmpty)
            }.store(in: &cancellables)
        }
    }
    func updateNextButtonState(keywordBtnSelected: Bool) {
        let isNameFilled = !(nameTextField.text ?? "").isEmpty
        let isAgeFilled = !(ageTextField.text ?? "").isEmpty
        nextButton.isEnabled =  isNameFilled && isAgeFilled && keywordBtnSelected
    }
    
    func updateNextButtonState() {
        let isNameFilled = !(nameTextField.text ?? "").isEmpty
        let isAgeFilled = !(ageTextField.text ?? "").isEmpty
        let isKeywordSelected = !(keywordButtonsSplitBySelected.selected.isEmpty)
        nextButton.isEnabled = isNameFilled && isAgeFilled && isKeywordSelected
    }
    func setTextFields() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                for: .editingChanged)
        ageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                               for: .editingChanged)
        ageTextField.delegate = self
        ageTextField.keyboardType = .numberPad
    }
}


// MARK: - Context
extension ProfileInputViewController {
    enum Context {
        static let nextBtnTitle: String = "다음으로"
        static let titleLabel: String = "반가워요!\n당신의 반려견을 소개해주세요."
        static let namePlaceholder: String = "반려견 이름을 입력해주세요."
        static let agePlaceholder: String = "반려견 나이를 입력해주세요."
        static let sexLabel: String = "반려견의 성별을 선택해주세요."
        static let sexUponIntakeLabel: String = "반려견 중성화 여부를 입력해주세요."
        static let sizeLabel: String = "반려견의 크기를 선택해주세요."
        static let sexUponIntakeArr: [String] = ["완료", "미완료"]
        static let sexArr: [String] = [Sex.male.rawValue, Sex.female.rawValue]
        static let sizeArr: [String] = [Size.small.rawValue, Size.medium.rawValue, Size.big.rawValue]
        static let keywordLabel: String = "반려견에 해당되는 키워드를 선택해주세요.(최대 2개)"
        static let activeKeywordLabel: String = Keyword.energetic.rawValue
        static let smartKeywordLabel: String = Keyword.smart.rawValue
        static let friendlyKeywordLabel: String = Keyword.friendly.rawValue
        static let shyKeywordLabel: String = Keyword.shy.rawValue
        static let independentKeywordLabel: String = Keyword.independent.rawValue
        static let horizontalPadding: CGFloat = 24
        static let smallVerticalPadding: CGFloat = 8
        static let basicVerticalPadding: CGFloat = 16
        static let largeVerticalPadding: CGFloat = 30
        static let contentViewHeight: CGFloat = 750
    }
}

extension ProfileInputViewController: UITextFieldDelegate {
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateNextButtonState()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 2
        
    }
}
