//
//  BaseNavigationController.m
//  BigTitle
//
//  Created by 丁巍巍 on 2019/1/30.
//  Copyright © 2019年 丁巍巍. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    
}


//- (void)pushViewController:(BaseViewController *)viewController animated:(BOOL)animated hideTabbar:(BOOL)hide {
////    viewController.hideTabbar = hide;
////    viewController.hidesBottomBarWhenPushed = hide;
////    viewController.backButtonEnable = YES;
//    [self pushViewController:viewController animated:animated];
//}
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    [super pushViewController:viewController animated:animated];
//}
//
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    return [super popViewControllerAnimated:animated];
//}

#pragma mark - 屏幕旋转

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    if (self.supportPortraitOnly) {
//        return UIInterfaceOrientationMaskPortrait;
//    } else {
//        return [self.topViewController supportedInterfaceOrientations];
//    }
//}
//
//- (BOOL)shouldAutorotate {
//    if (self.supportPortraitOnly) {
//        return NO;
//    } else {
//        return [self.topViewController shouldAutorotate];
//    }
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    if (self.supportPortraitOnly) {
//        return UIInterfaceOrientationPortrait == toInterfaceOrientation;
//    } else {
//        return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
//    }
//}
//
//- (UIViewController *)childViewControllerForStatusBarStyle {
//    return self.topViewController;
//}
//
//- (UIViewController *)childViewControllerForStatusBarHidden {
//    return self.topViewController;
//}

#pragma mark - Initize Method

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
                              NavBackColor:(UIColor *)navBackColor
                             NavTitleColor:(UIColor *)navTitleColor
                              NavTitleFont:(UIFont *)navTitleFont {
    
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        
        self.navigationBar.barTintColor = navBackColor;
        self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:navTitleColor, NSForegroundColorAttributeName, navTitleFont, NSFontAttributeName, nil];
        self.navigationBar.translucent = NO;
        self.interactivePopGestureRecognizer.delegate = (id)self;
    }
    return self;
}



@end
