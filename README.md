## 1、GlowView

![](http://chuantu.biz/t2/24/1454186379x-1376440148.gif)

学习来自：[YouXianMing老师Github上的GlowView](https://github.com/YouXianMing/GlowView)

YouXianMing老师用的是类别，但是本人将其改写为继承自CALayer的普通类，然后仅仅用了很简单的类别将对外接口进行了简单的封装。所以外部调用起来也是同样的方便，可读性也是比较好的。当然，本人这么做主要原因并不是喜欢重复造轮子，而是通过自我编码的训练，对辉光UIView的实现底层所使用到的上下文绘制、核心动画、GCD中的定时器以及Runtime动态添加属性等知识进一步的熟练运用和提高：

![](http://chuantu.biz/t2/24/1454188449x-954497756.png)
### 然后简单的使用示例：
![](http://chuantu.biz/t2/24/1454188366x-1376440148.png)