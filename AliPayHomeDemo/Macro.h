//
//  Macro.h
//  AliPayHomeDemo
//
//  Created by youyun on 2018/5/13.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

/** 屏幕宽高 **/
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kWidth(width) width * kScreenWidth / 375.0
#define kHeight(height) height * kScreenHeight / 667.0

// 状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

// 是否为iPhone X
#define IsIPhone_X  kStatusBarHeight == 44.f ? YES : NO

// 导航栏高度
#define kNavigationBarHeight (IsIPhone_X ? 88.f : 64.f)

// tabBar 高度
#define kTabBarHeight    (IsIPhone_X ? 83.f : 49.f)

/** 字体设置 **/
#define kFont(size) [UIFont systemFontOfSize:size]
#define kBFont(size) [UIFont boldSystemFontOfSize:size]

/** 图片名字 */
#define kImage(imageName) [UIImage imageNamed:imageName]

/** 弱引用 */
#define kWeakSelf __weak typeof(self)weakSelf = self;

/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}

/** 消除警告 */
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* Macro_h */
