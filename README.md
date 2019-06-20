# PPFMultiImageViewControllerDemo

## 效果
![multiimageViewController](https://upload-images.jianshu.io/upload_images/2261768-4c1945d5d53d25a0.gif?imageMogr2/auto-orient/strip)

## 引入

```
pod 'PPFMultiImageViewController', '~> 0.0.3'
```

## 怎么使用

```
let list = [url0,url1,url2]
let m:PPFMultiImageModel = PPFMultiImageModel(urls: list, images: [])!
let vc = PPFMultiImageViewController(model: m)
vc.delegate = self
self.present(vc, animated: true, completion: nil)
```

```
// MARK: - PPFMultiImageViewController_delegate
extension ViewController:PPFMultiImageViewController_delegate {
    func ppfMultiImageViewController(_ vc: PPFMultiImageViewController, backAndSelected index: Int) {
        vc.dismiss(animated: true, completion: nil)
    }
}
```
