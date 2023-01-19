//
//  FooterView.swift
//  Sharmanka
//
//  Created by Vadym Potapov on 13.01.2023.
//

import UIKit

class FooterView: UIView {
    
    private var myLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false // если constrains будут кодом
        label.textColor = UIColor(named: "color-for-loading")
        return label
    }()
    
    private var loader: UIActivityIndicatorView = {
       
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstrains()
    }
    
 // MARK: - Private func
    
    private func setupElements() {
        
        addSubview(myLabel)
        addSubview(loader)
    }
    
    private func setupConstrains() {
        
        loader.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        myLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        myLabel.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8).isActive = true
    }
    
    // MARK: - Public func
    
    func showLoader() {
        
        loader.startAnimating()
        myLabel.text = "Loading"
    }
    
    func hideLoader() {
        
        loader.stopAnimating()
        myLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
