//
//  RequestWalkViewController.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//
import UIKit

protocol RequestWalkViewable: AnyObject {
    var presenter: RequestWalkPresentable? { get set }
}

final class RequestWalkViewController: BaseViewController, RequestWalkViewable {
    var presenter: RequestWalkPresentable?
    private var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = SNMColor.mainNavy
        return button
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Context.mainTitle
        label.font = SNMFont.title3
        label.textColor = SNMColor.mainNavy
        return label
    }()
    
    private var profileView: ProfileView = {
        let view = ProfileView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private var locationView = LocationSelectionView()
    private var messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = Context.messagePlaceholder
        textView.font = SNMFont.subheadline
        textView.backgroundColor = SNMColor.subGray1
        textView.layer.cornerRadius = 10
        let padding = LayoutConstant.edgePadding
        textView.textContainerInset = UIEdgeInsets(top: padding,
                                                   left: padding,
                                                   bottom: padding,
                                                   right: padding)
        textView.textColor = .lightGray
        return textView
    }()
    private var submitButton = PrimaryButton(title: Context.mainTitle)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.delegate = self
        view.backgroundColor = .systemBackground
        presenter?.viewDidLoad()
    }
    override func configureAttributes() {
        setButtonActions()
        profileView.configure(dog: Dog(name: "진돌이", age: 12, size: .big, keywords: [.energetic, .friendly], nickname: "지성", profileImage: UIImage.imagePlaceholder.pngData()))
    }
    override func configureHierachy() {
        
        [titleLabel,
         dismissButton,
         profileView,
         locationView,
         messageTextView,
         submitButton].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: LayoutConstant.xlargeVerticalPadding),
            
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor,
                                               constant: LayoutConstant.regularVerticalPadding),
            dismissButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -LayoutConstant.smallHorizontalPadding),
            dismissButton.heightAnchor.constraint(equalToConstant: LayoutConstant.iconSize),
            dismissButton.widthAnchor.constraint(equalToConstant: LayoutConstant.iconSize),
            
            profileView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            profileView.widthAnchor.constraint(equalTo: profileView.heightAnchor),
            
            locationView.topAnchor.constraint(
                equalTo: profileView.bottomAnchor,
                constant: LayoutConstant.mediumVerticalPadding),
            locationView.bottomAnchor.constraint(
                equalTo: messageTextView.topAnchor,
                constant: -LayoutConstant.regularVerticalPadding),
            locationView.heightAnchor.constraint(equalToConstant: 25),
            
            messageTextView.bottomAnchor.constraint(
                equalTo: submitButton.topAnchor,
                constant: -LayoutConstant.xlargeVerticalPadding),
            
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                 constant: -LayoutConstant.xlargeVerticalPadding)
        ])
       
        [locationView, messageTextView, submitButton].forEach {
            $0.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: LayoutConstant.smallHorizontalPadding).isActive = true
            $0.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -LayoutConstant.smallHorizontalPadding).isActive = true
        }
    }
    override func bind() {
    }
}

private extension RequestWalkViewController {
    enum Context {
        static let mainTitle: String = "산책 요청 보내기"
        static let locationGuideTitle: String = "장소 선택"
        static let messagePlaceholder: String = "간단한 요청 메세지를 작성해주세요."
        static let characterCountLimit: Int = 100
    }
    
    func setButtonActions() {
        dismissButton.addAction(UIAction(handler: {[weak self] _ in
            self?.presenter?.closeTheView()
        }), for: .touchUpInside)
        
       // locationTapGesture.addTarget(self, action: #selector(locationDidTap))
    }
    
    @objc func locationDidTap() {
#if DEBUG
        print("location 뷰 탭!")
#endif
        
    }
}

extension RequestWalkViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Context.messagePlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Context.messagePlaceholder
            textView.textColor = .lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        guard characterCount <= Context.characterCountLimit else { return false }
        return true
    }
}