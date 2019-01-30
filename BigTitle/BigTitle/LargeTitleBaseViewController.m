//
//  LargeTitleBaseViewController.m
//  BigTitle
//
//  Created by 丁巍巍 on 2019/1/30.
//  Copyright © 2019年 丁巍巍. All rights reserved.
//

#define CusBarTintColor [UIColor groupTableViewBackgroundColor]

#import "LargeTitleBaseViewController.h"
#import "TouchModel.h"
#import "Header.h"
#import "NSString+extend.h"

@interface LargeTitleBaseViewController ()<UIScrollViewDelegate>
{
    
    UILabel *headLab;              // tableview上的headerLabel
    UILabel *titleLab;             // 导航栏上的headerLabel
    
    CGFloat lastContentOffset;     // the contentOffset of scrollView
    CGFloat tableContentOffset;    // the contentOffset of tableView
    CGPoint translationPoint;      // the contentOffset of gesture bases on tableView
    CGFloat textHeight;            // the height of the label
    CGFloat spaceHeight;           // the spaceHeight with text and label
    
    NSNumber *isTouchObject;       // default is no  0. NO 1. YES
    TouchModel *touchModel;        // kvo model
}

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *customTitleView;

@end

@implementation LargeTitleBaseViewController


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // kvo监听
    touchModel = [[TouchModel alloc] init];
    [touchModel addObserver:self forKeyPath:@"isTouch" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
    
    [self.view addSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.titleView = self.customTitleView;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barTintColor = CusBarTintColor;
    
    if (self.tableView) {
        [self scrollViewDidScroll:self.tableView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}


#pragma mark - Private Methods

- (void)refreshLabStatus:(CGFloat)fontSize {
    
    CGSize size = [self.navTitle sizeWithFont:kBlodFont(fontSize) constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    textHeight = size.height;
    spaceHeight = ((isIPhoneFill?88:64) - size.height)/2.0 + (isIPhoneFill?4.0:3.0);
    headLab.frame = CGRectMake(20, spaceHeight, size.width, size.height);
}


#pragma mark - Target

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldReceiveTouch:(UITouch *)touch {

    if([touch.view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isTouch"]) {
        NSString *str = [object valueForKey:@"isTouch"];
        if ([str isEqualToString:@"0"]) {
            if ((tableContentOffset < (headLab.center.y)) && (tableContentOffset >= (headLab.center.y - spaceHeight))) {
                [UIView animateWithDuration:0.2 animations:^{
                    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, 0)];
                }];
            }
            if ((tableContentOffset >= (headLab.center.y)) && (tableContentOffset <= ((headLab.center.y) + textHeight/2.0))) {
                [UIView animateWithDuration:0.2 animations:^{
                    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, (isIPhoneFill?88:64))];
                }];
            }
        }
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    lastContentOffset = scrollView.contentOffset.y;
    [touchModel setValue:@"1" forKey:@"isTouch"];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        [touchModel setValue:@"0" forKey:@"isTouch"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"%f",scrollView.contentOffset.y);//小于0是下拉，大于0是上s拉
    
    if ([scrollView isEqual:_tableView]) {
        
        CGFloat offsetY = scrollView.contentOffset.y;
        tableContentOffset = offsetY;
        
        if ((offsetY > 0) && (offsetY < ((isIPhoneFill?88:64) - spaceHeight))) {
            
            // hidden nav
            [UIView animateWithDuration:0.5 animations:^{
                self.customTitleView.hidden = YES;
            }];
            
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            self.navigationController.navigationBar.barTintColor = CusBarTintColor;
            
        }
        
        if (offsetY >= ((isIPhoneFill?88:64) - spaceHeight)) {
            
            // show nav
            [UIView animateWithDuration:0.5 animations:^{
                self.customTitleView.hidden = NO;
            }];
            [self.navigationController.navigationBar setShadowImage:nil];
            self.navigationController.navigationBar.barTintColor = CusBarTintColor;
            
        }
        
        //tableview没有超过导航栏的下拉
        if (offsetY <= 0) {
            
            // hidden nav
            [UIView animateWithDuration:0.5 animations:^{
                self.customTitleView.hidden = YES;
            }];
            
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            self.navigationController.navigationBar.barTintColor = CusBarTintColor;
            
            // change font size
            if (offsetY > -kScreenHeight/2) {
                if (offsetY < lastContentOffset){
                    
                    // down to bigger
                    headLab.font = kBlodFont((34 + fabs(offsetY)/(kScreenHeight/2.0)*6.0));
                    [self refreshLabStatus:(34 + fabs(offsetY)/(kScreenHeight/2.0)*6.0)];
                } else if (offsetY > lastContentOffset){
                    
                    // up to smaller
                    headLab.font = kBlodFont((34 - fabs(offsetY)/(kScreenHeight/2.0)*6.0));
                    [self refreshLabStatus:(34 - fabs(offsetY)/(kScreenHeight/2.0)*6.0)];
                }
            }
        }
    }
}


#pragma mark - Lazy Methods

- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    
    UILabel *lab = self.customTitleView.subviews[0];
    lab.text = navTitle;
    headLab.text = navTitle;
    [self refreshLabStatus:[headLab.font pointSize]];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - (isIPhoneFill?88:64));
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headView;
        _tableView.backgroundColor = CusBarTintColor;
    }
    return _tableView;
}

- (UIView *)customTitleView {
    
    if (!_customTitleView) {
        _customTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        _customTitleView.hidden = YES;
        
        {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
            lab.text = @"标题";
            lab.font = kBlodFont(18);
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor blackColor];
            titleLab = lab;
            [_customTitleView addSubview:lab];
        }
    }
    return _customTitleView;
}

- (UIView *)headView {
    
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (isIPhoneFill?88:64))];
        _headView.backgroundColor = CusBarTintColor;
        
        // caculate default size
        CGSize size = [@"标题" sizeWithFont:kBlodFont(34) constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        textHeight = size.height;
        spaceHeight = ((isIPhoneFill?88:64) - size.height)/2.0;
        
        {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, spaceHeight, size.width, size.height)];
            lab.font = kBlodFont(34);
            lab.text = @"标题";
            headLab = lab;
            [_headView addSubview:lab];
        }
    }
    return _headView;
}


@end
