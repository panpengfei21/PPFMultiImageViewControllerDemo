//
//  JDP_PagesRootViewController.swift
//  JDPHouseDemolitionManagement
//
//  Created by 潘鹏飞 on 2018/8/27.
//  Copyright © 2018年 健德普. All rights reserved.
//  page view controller的根

import UIKit

@objc public protocol PPFMultiImageViewController_delegate {
    func ppfMultiImageViewController(_ vc:PPFMultiImageViewController,backAndSelected index:Int)
}

public class PPFMultiImageViewController: UIViewController {
    var pageViewController:UIPageViewController!

    weak var pageControl:UIPageControl!
    weak var backB:UIButton!

    public weak var delegate:PPFMultiImageViewController_delegate?
    
    public var dataModel:PPFMultiImageModel
    var observers:[NSKeyValueObservation] = []

    public init(model:PPFMultiImageModel) {
        self.dataModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeConstraints()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    private func initializeUI () {
        view.backgroundColor = UIColor.black
        let startingViewController = dataModel.viewControllerAtIndex(dataModel.currentIndex)!
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: false, completion: nil)
        pageViewController.dataSource = dataModel
        pageViewController.delegate = dataModel
        
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.pageViewController.didMove(toParent: self)
        
        pageControl = {
            let p = UIPageControl()
            p.translatesAutoresizingMaskIntoConstraints = false
            p.numberOfPages = dataModel.numberOfItems
            p.pageIndicatorTintColor = dataModel.unselectedColor
            p.currentPageIndicatorTintColor = dataModel.selectedColor
            p.currentPage = dataModel.currentIndex
            self.view.addSubview(p)
            return p
        }()

        backB = {
            let b = UIButton(type: UIButton.ButtonType.custom)
            b.setImage(UIImage(named: "backImage"), for: .normal)
            b.translatesAutoresizingMaskIntoConstraints = false
            b.addTarget(self, action: #selector(PPFMultiImageViewController.tapForBackButton(_:)), for: .touchUpInside)
            view.addSubview(b)
            return b
        }()
    }
    
    private func initializeConstraints() {
        guard let pView = pageViewController?.view else{
            return
        }
        pView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            let layout = view.safeAreaLayoutGuide
            backB.topAnchor.constraint(equalTo: layout.topAnchor, constant: 20).isActive = true
            backB.leftAnchor.constraint(equalTo: layout.leftAnchor, constant: 20).isActive = true
            
            pageControl.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
            pageControl.bottomAnchor.constraint(equalTo: layout.bottomAnchor, constant: -10).isActive = true
            
            pView.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
            pView.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        }else {
            backB.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            backB.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true

            pView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            pView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
    }
    
    @objc func tapForBackButton(_ button:UIButton){
        delegate?.ppfMultiImageViewController(self, backAndSelected: dataModel.currentIndex)
    }
}

extension PPFMultiImageViewController {
    func addObservers() {
        observers = [
            dataModel.observe(\.currentIndex,options: [.new]) { (m, change) in
                self.pageControl.currentPage = change.newValue!
            }]
    }
    
    func removeObservers() {
        for ob in observers {
            ob.invalidate()
        }
        observers = []
    }
}

