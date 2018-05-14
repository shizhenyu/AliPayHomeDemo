//
//  HomeUsualFeatureCell.m
//  AliPayHomeDemo
//
//  Created by youyun on 2018/5/13.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import "HomeUsualFeatureCell.h"

@interface HomeUsualFeatureCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HomeUsualFeatureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubViewConstraints];
    }
    return self;
}

- (void)addSubViewConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(5);
        
        make.trailing.mas_equalTo(-5);
        
        make.top.mas_equalTo(5);
        
        make.height.equalTo(self.iconImageView.mas_width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.trailing.mas_equalTo(0);
        
        make.top.equalTo(self.iconImageView.mas_bottom).offset(5);
        
    }];
}

#pragma mark - Setter && Getter
- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc] init];
        
        _iconImageView.image = kImage(@"camera_mini");
        
        [self.contentView addSubview:_iconImageView];
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.text = @"转账";
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.font = kFont(10);
        
        [self.contentView addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (void)setUsualFeatureInfo:(NSDictionary *)usualFeatureInfo {
    
    self.iconImageView.image = kImage(usualFeatureInfo[@"icon"]);
    self.titleLabel.text = [usualFeatureInfo objectForKey:@"title"];
}
@end
