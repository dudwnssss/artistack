//
//  CustomTextView.swift
//  ARTISTACK
//
//  Created by 임영준 on 2023/08/31.
//

import UIKit
import SnapKit

class CustomTextView: UIView {
    
    var placeholder: String? {
        didSet {
            setPlaceholder()
        }
    }
    
    var limitCount: Int = 0 {
        didSet {
            updateCountLabel()
        }
    }
    
    let textView = UITextView()
    let textCountLabel = UILabel()
    
    
    init(placeholder: String, limitCount: Int, fontSize: CGFloat, isBold: Bool) {
        self.placeholder = placeholder
        self.limitCount = limitCount
        super.init(frame: .zero)
        textCountLabel.text = "\(limitCount)"
        textView.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
        setProperties()
        setLayouts()
    }
    
    func setProperties() {
        textView.do {
            $0.delegate = self
            $0.isScrollEnabled = false
            $0.textContainerInset = .zero
            $0.textContainer.lineFragmentPadding = 0
            $0.backgroundColor = .clear
        }
        textCountLabel.do {
            $0.textColor = .artistackSystem4
            $0.font = .systemFont(ofSize: 14)
        }


        setPlaceholder()
    }
    
    private func setPlaceholder() {
        if let placeholderText = placeholder {
            textView.text = placeholderText
            textView.textColor = .artistackSystem3
        }
    }
    
    func setLayouts() {
        addSubviews(textCountLabel, textView)
        textCountLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.bottom.trailing.equalToSuperview()
        }
        textView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(textCountLabel.snp.top)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = .white
        }
        
        if let text = textView.text, text.count > limitCount {
            let index = text.index(text.startIndex, offsetBy: limitCount)
            textView.text = String(text.prefix(upTo: index))
        }
        updateCountLabel()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = .white
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            setPlaceholder()
        }
        return true
    }
    
    
    func updateCountLabel() {
        let remainingCount = limitCount - (textView.text?.count ?? 0)
        textCountLabel.text = "\(remainingCount)"
    }
}
