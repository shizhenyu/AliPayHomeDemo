//
//  HomeCommonFeatureView.h
//  AliPayHomeDemo
//
//  Created by youyun on 2018/5/13.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HomeCommonClickType) {
    HomeCommonClickTypeScan,
    HomeCommonClickTypePay,
    HomeCommonClickTypeCard,
    HomeCommonClickTypeLife,
};

@protocol HomeCommonFeatureViewDelegate <NSObject>

- (void)didClickHomeCommonFeatureViewWithType:(HomeCommonClickType)type;

@end

@interface HomeCommonFeatureView : UIView

@property (nonatomic, weak) id <HomeCommonFeatureViewDelegate> delegate;

@property (nonatomic, strong) UIView *contentView;

@end
