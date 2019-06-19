//
//  PPFMultiImageModel.swift
//
//  Created by 潘鹏飞 on 2018/8/27.
//  Copyright © 2018年 潘鹏飞. All rights reserved.
//

import UIKit

/// 多图片数据
public class PPFMultiImageModel: NSObject {
    /// 图片的地址链接
    let urls:[URL]
    /// 图片
    let images:[UIImage]
    
    /// 被选中时的颜色
    let selectedColor:UIColor
    /// 未选中时的颜色
    let unselectedColor:UIColor
    
    /// 第一个要显示的索引
    @objc dynamic var currentIndex:Int
    
    init?(urls:[URL],images:[UIImage],currentIndex:Int = 0,selectedColor:UIColor = UIColor(white: 0.4, alpha: 1.0),unselectedColor:UIColor = UIColor(white: 0.6, alpha: 1.0)) {
        guard currentIndex > -1 && currentIndex < urls.count + images.count else{
            print("PPFMultiImage`s current index is not in bounds of datas(urls and images)")
            return nil
        }
        self.urls = urls
        self.images = images
        self.currentIndex = currentIndex
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        super.init()
    }
    
    /// 全部对象的总数
    var numberOfItems:Int {
        return urls.count + images.count
    }
    /// 指定索引的对象
    func itemForIndex(_ index:Int) -> Any? {
        guard index > -1 && index < numberOfItems else{
            return nil
        }
        if index > -1 && index < urls.count {
            return urls[index]
        }else{
            return images[index - urls.count]
        }
    }
    
    /// 对象所在的索引
    ///
    /// - Parameter item: 对象
    func indexForItem(_ item:Any) -> Int {
        if let url = item as? URL {
            return urls.firstIndex(of: url) ?? NSNotFound
        }else if let image = item as? UIImage {
            if let index = images.firstIndex(of: image){
                return index + urls.count
            }else{
                return NSNotFound
            }
        }else{
            return NSNotFound
        }
    }
    
    func viewControllerAtIndex(_ index:Int) -> PPFOneImageViewController? {
        if numberOfItems == 0 || index >= numberOfItems {
            return nil
        }
        let pageVC = PPFOneImageViewController()
        pageVC.data = itemForIndex(index)
        return pageVC
    }
    
    func indexOfViewController(_ viewController:PPFOneImageViewController) -> Int {
        guard let data = viewController.data else{
            return NSNotFound
        }
        return indexForItem(data)
    }
}

// MARK: - <#UIPageViewControllerDataSource#>
extension PPFMultiImageModel:UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController as! PPFOneImageViewController)
        guard index != NSNotFound else{
            return nil
        }
        index += 1
        return viewControllerAtIndex(index)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController as! PPFOneImageViewController)
        guard index != NSNotFound && index != 0 else {
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index)
    }
}

// MARK: - UIPageViewControllerDelegate
extension PPFMultiImageModel:UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vc = pageViewController.viewControllers?.first as? PPFOneImageViewController,completed else{
            return
        }
        currentIndex = indexOfViewController(vc)
    }
}
