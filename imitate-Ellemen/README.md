

#### imitate the magazine ellemen 

---

模仿杂志ellemen，之前写了一点，现在再添加一点，就将它上传吧，唯一的缺憾是，首页的左滑显示左界面，右滑显示右界面没有实现，（不知道怎么实现：将一个UIView（topView）放在Window上，但始终无法实现左右滑响应topView，上下滑响应collectionView）

1，使用charles获取数据：

    1> 在mac上安装charles的证书：[Help] -> [SSL Proxying] -> [Install Charles Root Certificate]
    2> 将手机设置为手动代理，
    3> 使用safari打开 chls.pro/ssl 下载和安装证书certificate
    4> 在charles的[proxy] -> [SSL Proxying Settings]中添加不信任的网址；
    
    ![image]()

Note: 注意，你需要自己手动添加AFN， FDFullscreenPopGesture, Masonry, MJRefresh, SDWebImage, YYKit; (后面再把它弄成pods)

实现的功能有：
  
  1，首页的折叠layout；
  
  2，首页rightView的简单动画
  
  3，其他两个VC里wkwebview的实现；
  
  
  
