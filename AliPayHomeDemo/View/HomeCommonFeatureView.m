//
//  HomeCommonFeatureView.m
//  AliPayHomeDemo
//
//  Created by youyun on 2018/5/13.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import "HomeCommonFeatureView.h"

@implementation HomeCommonFeatureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView = [[UIView alloc] initWithFrame:frame];
        self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0.5059 blue:0.9216 alpha:1];
        [self addSubview:self.contentView];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    NSArray *iconArr = @[@"home_scan", @"home_pay", @"home_card", @"home_xiu"];
    NSArray *titleArr = @[@"扫一扫", @"付款", @"卡包", @"生活"];
    
    CGFloat itemWidth = kScreenWidth / 4.0;
    
    for (int i = 0; i < iconArr.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 10+i;
        [button setImage:kImage([iconArr objectAtIndex:i]) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [titleArr objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kFont(14);
        label.textColor = [UIColor whiteColor];
        [self.contentView addSubview:label];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            
            make.leading.mas_equalTo(itemWidth * i);
            
            make.width.mas_equalTo(itemWidth);
            
            make.height.mas_equalTo(50);
            
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(button.mas_centerX);
            
            make.top.equalTo(button.mas_bottom);
            
            make.width.equalTo(button.mas_width);
            
            make.height.mas_equalTo(14);
            
        }];
    }
}

#pragma mark - Button Event Response
- (void)buttonClick:(UIButton *)sender {
    
    NSInteger tag = sender.tag - 10;
    
    switch (tag) {
        case 0:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHomeCommonFeatureViewWithType:)]) {
                
                [self.delegate didClickHomeCommonFeatureViewWithType:HomeCommonClickTypeScan];
            }
        }
            break;
            
        case 1:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHomeCommonFeatureViewWithType:)]) {
                
                [self.delegate didClickHomeCommonFeatureViewWithType:HomeCommonClickTypePay];
            }
        }
            break;
            
        case 2:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHomeCommonFeatureViewWithType:)]) {
                
                [self.delegate didClickHomeCommonFeatureViewWithType:HomeCommonClickTypeCard];
            }
        }
            break;
            
        case 3:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHomeCommonFeatureViewWithType:)]) {
                
                [self.delegate didClickHomeCommonFeatureViewWithType:HomeCommonClickTypeLife];
            }
        }
            break;
            
        default:
            break;
    }
    
}

@end
