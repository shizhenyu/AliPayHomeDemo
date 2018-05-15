//
//  ViewController.m
//  AliPayHomeDemo
//
//  Created by youyun on 2018/5/13.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import "ViewController.h"
#import "HomeUsualFeatureCell.h"
#import "HomeCommonFeatureView.h"
#import <SafariServices/SafariServices.h>

NSString *const tableViewObserverKeypath = @"contentOffset";

@interface ViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate ,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, HomeCommonFeatureViewDelegate> {
    
    CGFloat collectionViewHeight;
}

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, strong) HomeCommonFeatureView *headerView;

@property (nonatomic, strong) NSMutableArray *usualFeatures;

@end

@implementation ViewController

#pragma mark - 生命周期
- (void)dealloc {
    
    NSLog(@"执行dealloc方法");
    
    /**
     
     ⚠️ 这里不可以用self.调用tableView
     
     因为tableView的delegate遵循了UIScrollViewDelegate，而UITableView的父类UIScrollView重写了UIScrollViewDelegate的setter方法，如果self.调用tableView，那么就会调用tableView的delegate，就重写了UIScrollViewDelegate的setter方法
     
     释放时，会先走子类的dealloc，后走父类的dealloc，在父类dealloc的时候，因为UIScrollViewDelegate的setter方法被子类重写了，那么父类就会先去子类重走UIScrollViewDelegate的setter方法，但此时子类已经被释放掉了，那么就会出现重复释放，导致crash
     
     
     不能在init和dealloc中使用accessor的原因是由于面向对象的继承、多态特性与accessor可能造成的副作用联合导致的。继承和多态导致在父类的实现中调用accessor可能导致调用到子类重写的accessor，而此时子类部分并未完全初始化或已经销毁，导致原有的假设不成立，从而出现一系列的逻辑问题甚至崩
     */
    
    [_tableView removeObserver:self forKeyPath:tableViewObserverKeypath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat itemWidth = (kScreenWidth - 180) / 4.0;
    collectionViewHeight = (itemWidth + 20) * 3 + 160;
    
    [self setupNav];
    [self setupUI];
    
    AdjustsScrollViewInsetNever(self, self.bgScrollView);
    AdjustsScrollViewInsetNever(self, self.tableView);
    AdjustsScrollViewInsetNever(self, self.collectionView);
    
    [self.tableView addObserver:self forKeyPath:tableViewObserverKeypath options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 设置导航栏
- (void)setupNav {
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:kImage(@"home_contacts") forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 25, 30);
    [button1 addTarget:self action:@selector(lookContacts) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:kImage(@"home_bill_320") forState:UIControlStateNormal];
    button2.frame = CGRectMake(0, 0, 25, 30);
    [button2 addTarget:self action:@selector(lookOrderList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton2 = [[UIBarButtonItem alloc] initWithCustomView:button2];

    UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonSpace.width = -15;
    
    self.navigationItem.rightBarButtonItems = @[barButtonSpace, barButton1, barButton2];
    
    [self updateNavigationItemStatus:NO];
}

#pragma mark - 点击查看订单
- (void)lookOrderList {
    
    [self showTipMessage:@"查看订单"];
}

#pragma mark - 点击查看联系人
- (void)lookContacts {
    
    [self showTipMessage:@"查看联系人"];
}

#pragma mark - 打开相机扫一扫
- (void)openCameraForScan {
    
    [self showTipMessage:@"打开扫一扫"];
}

#pragma mark - 打开付款码
- (void)openPayCode {
    
    [self showTipMessage:@"打开付款码"];
}

#pragma mark - 打开相机
- (void)openCameraForPhoto {
    
    [self showTipMessage:@"打开相机"];
}

#pragma mark - 更新导航栏状态
- (void)updateNavigationItemStatus:(BOOL)flag {
    
    if (flag) {
        
        // 导航栏滑上去，显示小的导航栏
        
        UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithImage:kImage(@"scan_mini") style:UIBarButtonItemStylePlain target:self action:@selector(openCameraForScan)];
        
        UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithImage:kImage(@"pay_mini") style:UIBarButtonItemStylePlain target:self action:@selector(openPayCode)];
        
        UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithImage:kImage(@"camera_mini") style:UIBarButtonItemStylePlain target:self action:@selector(openCameraForPhoto)];
        
        self.navigationItem.leftBarButtonItems = @[button1, button2, button3];
        
        self.navigationItem.titleView = nil;
        
    }else {
        
        self.navigationItem.leftBarButtonItems = @[];
        
        self.navigationItem.titleView = self.searchTF;
    }
}

#pragma mark - 初始化视图
- (void)setupUI {
    
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.edges.mas_equalTo(0);
        
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self.tableView.mj_header endRefreshing];

        });

    }];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self.tableView.mj_footer endRefreshing];
        });

    }];
    
    // 移除父scrollView的所有手势
    for (UITapGestureRecognizer *tap in self.bgScrollView.gestureRecognizers) {
        
        [self.bgScrollView removeGestureRecognizer:tap];
    }
    
    // 将tableView的手势添加到父scrollView上
    for (UITapGestureRecognizer *tap in self.tableView.gestureRecognizers) {
        
        [self.bgScrollView addGestureRecognizer:tap];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:tableViewObserverKeypath]) {
        
        CGFloat originY = self.tableView.contentOffset.y + collectionViewHeight;
        
        if (originY > 0) {
            
            CGRect newFrame = self.collectionView.frame;

            // 中间的collectionView随着tableView滚动
            newFrame.origin.y = -originY;
            
            self.collectionView.frame = newFrame;
            
            // 导航栏渐变效果
            CGFloat height = self.headerView.bounds.size.height / 2.0;
            
            self.headerView.contentView.alpha = 1 - originY / self.headerView.bounds.size.height;
            
            if (originY < height) {
                
                CGFloat alpha = originY / height;
                self.searchTF.alpha = 1 - alpha;
                
                [self updateNavigationItemStatus:NO];
                
            }else {
                
                [self updateNavigationItemStatus:YES];
                
                CGFloat alpha = (originY - height) / height;
                
                for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems) {
                    
                    UIColor *navColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
                    
                    [item setTintColor:navColor];
                }
            }
            
        }else {
            
            CGRect newFrame = self.collectionView.frame;
            newFrame.origin.y = 0;
            self.collectionView.frame = newFrame;
            
            self.headerView.contentView.alpha = 1;
            self.searchTF.alpha = 1;
            
            for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
                
                [item setTintColor:[UIColor whiteColor]];
            }
        }
    }
}

#pragma mark - HomeCommonFeatureViewDelegate
- (void)didClickHomeCommonFeatureViewWithType:(HomeCommonClickType)type {
    
    switch (type) {
        case HomeCommonClickTypeScan:
        {
            [self showTipMessage:@"扫一扫"];
        }
            break;
            
        case HomeCommonClickTypePay:
        {
            [self showTipMessage:@"打开付款"];
        }
            break;
            
        case HomeCommonClickTypeCard:
        {
            [self showTipMessage:@"进入卡包"];
        }
            break;
            
        case HomeCommonClickTypeLife:
        {
            [self showTipMessage:@"生活服务"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 提示信息弹框
- (void)showTipMessage:(NSString *)message {
   
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    #pragma clang diagnostic pop
}

#pragma mark - UICollecionView Delegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.usualFeatures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeUsualFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeUsualFeatureCell" forIndexPath:indexPath];
    
    cell.usualFeatureInfo = [self.usualFeatures objectAtIndex:indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    [view addSubview:self.headerView];
    
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 75);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.taobao.com"]];
    [self presentViewController:safariVC animated:YES completion:nil];
}

#pragma mark - UITableView Delegate && DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"row-%ld", indexPath.row];
    
    return cell;
}

#pragma mark - 懒加载
- (UIScrollView *)bgScrollView {
    
    if (!_bgScrollView) {
        
        _bgScrollView = [[UIScrollView alloc] init];
        
        [self.view addSubview:_bgScrollView];
    }
    
    return _bgScrollView;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        CGFloat itemWidth = (kScreenWidth - 180) / 4.0;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 20;
        flowLayout.minimumInteritemSpacing = 40;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 20);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 30);
        
        CGRect frame = CGRectMake(0, 0, kScreenWidth, collectionViewHeight);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor cyanColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        // 禁止中间的collectionView滚动
        _collectionView.scrollEnabled = NO;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HomeUsualFeatureCell class] forCellWithReuseIdentifier:@"HomeUsualFeatureCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        [self.bgScrollView addSubview:self.collectionView];
    }
    
    return _collectionView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.contentInset = UIEdgeInsetsMake(collectionViewHeight, 0, 0, 0);
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(collectionViewHeight, 0, 0, 0);
        
        [self.bgScrollView addSubview:_tableView];
    }
    
    return _tableView;
}

- (HomeCommonFeatureView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[HomeCommonFeatureView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 75)];
        
        _headerView.delegate = self;
    }
    
    return _headerView;
}

- (UITextField *)searchTF {
    
    if (!_searchTF) {
        
        _searchTF = [[UITextField alloc] init];
        
        NSString *placeholder = @"   🔍 附近美食";
        
        NSMutableAttributedString *mutableHolder = [[NSMutableAttributedString alloc] initWithString:placeholder];
        
        [mutableHolder addAttributes:@{NSFontAttributeName:kFont(14), NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, mutableHolder.length)];
        
        _searchTF.attributedPlaceholder = mutableHolder;
        
        _searchTF.frame = CGRectMake(0, 0, kScreenWidth, 28);
        
        _searchTF.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    
    }
    
    return _searchTF;
}

- (NSMutableArray *)usualFeatures {
    
    if (!_usualFeatures) {
        
        NSDictionary *dic1 = @{@"icon":@"home_scan", @"title":@"扫一扫"};
        NSDictionary *dic2 = @{@"icon":@"home_scan", @"title":@"信用卡还款"};
        NSDictionary *dic3 = @{@"icon":@"home_scan", @"title":@"余额宝"};
        NSDictionary *dic4 = @{@"icon":@"home_scan", @"title":@"生活缴费"};
        NSDictionary *dic5 = @{@"icon":@"home_pay", @"title":@"我的快递"};
        NSDictionary *dic6 = @{@"icon":@"home_pay", @"title":@"天猫"};
        NSDictionary *dic7 = @{@"icon":@"home_pay", @"title":@"AA收款"};
        NSDictionary *dic8 = @{@"icon":@"home_pay", @"title":@"芝麻信用"};
        NSDictionary *dic9 = @{@"icon":@"home_card", @"title":@"游戏中心"};
        NSDictionary *dic10 = @{@"icon":@"home_card", @"title":@"蚂蚁庄园"};
        NSDictionary *dic11 = @{@"icon":@"home_card", @"title":@"花呗"};
        NSDictionary *dic12 = @{@"icon":@"home_card", @"title":@"更多"};
        
        _usualFeatures = [[NSMutableArray alloc] initWithObjects:dic1, dic2, dic3, dic4, dic5, dic6, dic7, dic8, dic9, dic10, dic11, dic12, nil];
    }
    
    return _usualFeatures;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
