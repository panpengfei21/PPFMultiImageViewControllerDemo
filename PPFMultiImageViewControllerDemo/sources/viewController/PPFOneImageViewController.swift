//
//  JDP_PageDataViewController.swift
//  JDPHouseDemolitionManagement
//
//  Created by 潘鹏飞 on 2018/8/27.
//  Copyright © 2018年 健德普. All rights reserved.
//  每页的

import UIKit
import SDWebImage
import MBProgressHUD

class PPFOneImageViewController: UIViewController {

    var data:Any!
    
    weak var imageView: UIImageView!
    weak var scrollView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeConstraints()
        
        let hub = MBProgressHUD(view: view)
        view.addSubview(hub)
        hub.removeFromSuperViewOnHide = true
        hub.graceTime = 0.5
        hub.show(animated: true)

        if let url = data as? URL{
            imageView.sd_setImage(with: url, placeholderImage: nil, options: .highPriority) {[unowned self](image, error, type, url) in
                hub.hide(animated: true)
                if let image = image,self.scrollView.bounds.size != CGSize.zero {
                    self.setScrollViewScale(use: image.size, containerSize: self.scrollView.bounds.size)
                    self.setImageViewCenterIn(scrollView: self.scrollView)
                }
            }
        }else if let image = data as? UIImage{
            hub.hide(animated: true)
            imageView.image = image
        }else{
            fatalError("the type of data is not URL or Image.")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let image = imageView.image {
            self.setScrollViewScale(use: image.size, containerSize: self.scrollView.bounds.size)
            setImageViewCenterIn(scrollView: self.scrollView)
        }
    }
    
    func initializeUI() {
        view.backgroundColor = UIColor.black
        scrollView = {
            let sc = UIScrollView(frame: CGRect.zero)
            sc.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(sc)
            sc.backgroundColor = UIColor.black
            sc.delegate = self
            return sc
        }()
        
        imageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            scrollView.addSubview(iv)
            return iv
        }()
    }
    
    private func initializeConstraints() {
        if #available(iOS 11.0, *) {
            let layout = view.safeAreaLayoutGuide
            scrollView.topAnchor.constraint(equalTo: layout.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = true
            scrollView.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
            scrollView.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        }else{
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
    }
    
    /// 把imageView的居中到scrollView中心
    private func setImageViewCenterIn(scrollView:UIScrollView) {
        let offsetX = (scrollView.bounds.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        imageView.center = CGPoint(x:scrollView.contentSize.width * 0.5 + offsetX,y:scrollView.contentSize.height * 0.5 + offsetY);
    }
    
    /// 用image size和容器size来调整scroll view的缩放比例和image view 的size
    ///
    /// - Parameters:
    ///   - imageSize: 图片大小
    ///   - cSize: 容器大小
    private func setScrollViewScale(use imageSize:CGSize,containerSize cSize:CGSize) {
        if imageView.frame.size == CGSize.zero {
            imageView.frame.size = imageSize
        }
        scrollView.contentSize = imageSize
        let cRate = cSize.width / cSize.height // 容器的宽高比
        let iRate = imageSize.width / imageSize.height // 图片的宽高比
        
        if imageSize.width <= cSize.width && imageSize.height <= cSize.height {
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 2.0
        }else {
            let minScale:CGFloat
            if iRate > cRate {
                minScale = cSize.width / imageSize.width
            }else{
                minScale = cSize.height / imageSize.height
            }
            scrollView.minimumZoomScale = minScale
            scrollView.maximumZoomScale = minScale * 2
        }
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
}


// MARK: - UIScrollViewDelegate
extension PPFOneImageViewController:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setImageViewCenterIn(scrollView: scrollView)
    }
}
