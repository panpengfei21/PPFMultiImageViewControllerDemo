//
//  ViewController.swift
//  PPFMultiImageViewControllerDemo
//
//  Created by 潘鹏飞 on 2019/6/19.
//  Copyright © 2019 潘鹏飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapForAction(_ sender: Any) {
        let url0 = URL(string: "http://e.hiphotos.baidu.com/image/pic/item/4034970a304e251fb1a2546da986c9177e3e53c9.jpg?123")!
        let url1 = URL(string: "http://e.hiphotos.baidu.com/image/pic/item/4034970a304e251fb1a2546da986c9177e3e53c9.jpg?4")!
        let url2 = URL(string: "http://e.hiphotos.baidu.com/image/pic/item/4034970a304e251fb1a2546da986c9177e3e53c9.jpg?8")!
        let list = [url0,url1,url2]
        let m = PPFMultiImageModel(urls: list, images: [])!
        let vc = PPFMultiImageViewController(model: m)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - PPFMultiImageViewController_delegate
extension ViewController:PPFMultiImageViewController_delegate {
    func ppfMultiImageViewController(_ vc: PPFMultiImageViewController, backAndSelected index: Int) {
        vc.dismiss(animated: true, completion: nil)
    }
}

