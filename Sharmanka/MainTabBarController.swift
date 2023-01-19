//
//  MainTabBarController.swift
//  Sharmanka
//
//  Created by Vadym Potapov on 11.01.2023.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: AnyObject {
    
    func minimizedTrackDetailController()
    func maximizedTrackDetaailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    let searchVC = SearchMusicViewController()
    let libraryVC = LibraryViewController()
    let searchVCSb: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    
    
    // MARK: - Private properties
    
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottonAnchorConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupControllers()
        setupTrackDetailView()
    }
    
    // MARK: - Private
    
    private func setupViews() {
        view.backgroundColor = .white
        tabBar.tintColor = UIColor(named: "deep-purple")
    }
    
    private func setupControllers() {
        
        var library = Library()
        library.tabBarDelegate = self
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = UIImage(named: "library")
        hostVC.tabBarItem.title = "Library"

        viewControllers = [
            hostVC,
            generateViewController(rootViewController: searchVCSb, image: "search", title: "Search")
//            generateViewController(rootViewController: hostVC, image: "library", title: "Library")
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController, image: String, title: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = UIImage(named: image)
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }

    
    
    private func setupTrackDetailView() {
        
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVCSb
        searchVCSb.tabBarDelegate = self
        view.insertSubview(trackDetailView, belowSubview: tabBar) // устанавляваем view за нашим таб баром
        
        // закреплем наше view с помошью auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottonAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        maximizedTopAnchorConstraint.isActive = true
        bottonAnchorConstraint.isActive = true
        
//      trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximizedTrackDetaailController(viewModel: SearchViewModel.Cell?) {
        
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottonAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                       self.view.layoutIfNeeded() // обновления экрана каждую милисекунду чтобы видеть плавную анимацию
//                       self.tabBar.transform = CGAffineTransform(scaleX: 0, y: 100)
                       self.tabBar.alpha = 0
                       self.trackDetailView.miniTrackView.alpha = 0
                       self.trackDetailView.maximizedStackView.alpha = 1
        },
                       completion: nil)
        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
    }
    
    func minimizedTrackDetailController() {
        
        minimizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = false
        bottonAnchorConstraint.constant = view.frame.height
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                       self.view.layoutIfNeeded() // обновления экрана каждую милисекунду чтобы видеть плавную анимацию
//                       self.tabBar.transform = .identity
                       self.tabBar.alpha = 1
                       self.trackDetailView.miniTrackView.alpha = 1
                       self.trackDetailView.maximizedStackView.alpha = 0
        },
                       completion: nil)
    }
}
