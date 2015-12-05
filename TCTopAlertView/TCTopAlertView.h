//
//  TCTopAlertView.h
//  TCTopAlertView
//
//  Created by 程天聪 on 15/5/6.
//  Copyright (c) 2015年 Tc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TCTopAlertView : UIView

+ (void)setHeight:(CGFloat)height;
+ (void)setFontSize:(CGFloat)fontSize;
+ (void)showMessage:(NSString *)message inView:(UIView *)view;
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message inView:(UIView *)view completion:(void (^)(void))completion;
+ (void)showMessage:(NSString *)message completion:(void (^)(void))completion;

@end
