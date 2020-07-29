//
//  LoadingViewController.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
    
    var presenter: LoadingPresenterProtocol?
    
    private lazy var animationView: AnimationView = {
        let animationView = AnimationView(name: "loading4")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.tintColor = .red
        animationView.loopMode = .loop
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        return animationView
    } ()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Updating Data..."
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .actionColor
        return label
    } ()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [animationView, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.start()
    }
    
    convenience init(presenter: LoadingPresenterProtocol) {
        self.init()
        self.presenter = presenter
    }
    
    private func setupUI() {
        view.backgroundColor = .primaryBackgroundColor
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: 200),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension LoadingViewController: LoadingViewProtocol {
    func start() {
        animationView.play()
    }
    
    func stop() {
        animationView.stop()
    }
    
    func showError(_ error: Error) {
        //TODO: - show error dialog
        print("Error = \(error)")
    }
}
