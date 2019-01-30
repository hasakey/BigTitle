//
//  BaseNavigationController.h
//  BigTitle
//
//  Created by 丁巍巍 on 2019/1/30.
//  Copyright © 2019年 丁巍巍. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseViewController;

NS_ASSUME_NONNULL_BEGIN

//typedef void(^NavBackAction)(void);

@interface BaseNavigationController : UINavigationController

//@property (nonatomic, copy) NavBackAction backAction;


//- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
//                              NavBackColor:(UIColor *)backColor
//                             NavTitleColor:(UIColor *)titleColor
//                              NavTitleFont:(UIFont *)titleFont;

//- (void)pushViewController:(BaseViewController *)viewController animated:(BOOL)animated hideTabbar:(BOOL)hide;

#pragma mark - 屏幕旋转

@property (nonatomic) BOOL supportPortraitOnly;

@end

NS_ASSUME_NONNULL_END
