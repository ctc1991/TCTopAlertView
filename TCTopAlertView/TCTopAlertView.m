//
//  TCTopAlertView.m
//  TCTopAlertView
//
//  Created by 程天聪 on 15/5/6.
//  Copyright (c) 2015年 Tc. All rights reserved.
//

#import "TCTopAlertView.h"
#import <AVFoundation/AVFoundation.h>

#define TCT_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define TCT_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define TCT_WINDOW [UIApplication sharedApplication].keyWindow
#define TCT_SETTING [TCTopAlertViewSetting shareInstance]

@interface TCTopAlertViewSetting : NSObject
/** Default is 64.0 */
@property (nonatomic) CGFloat height;
/** Default is 1.0 */
@property (nonatomic) CGFloat alpha;
/** Default is 1.5 */
@property (nonatomic) NSTimeInterval duration;
/** Default is 0.0 */
@property (nonatomic) NSTimeInterval delay;
/** Default is 15.0 */
@property (nonatomic) CGFloat fontSize;
/** Default is black */
@property (strong, nonatomic) UIColor *backgroundColor;
/** Default is white */
@property (strong, nonatomic) UIColor *textColor;
+ (TCTopAlertViewSetting *)shareInstance;
@end

@implementation TCTopAlertViewSetting
+ (TCTopAlertViewSetting *)shareInstance {
    static TCTopAlertViewSetting *singleton = nil;
    static dispatch_once_t onceBlock;
    dispatch_once(&onceBlock, ^{
        singleton = [[TCTopAlertViewSetting alloc] init];
        singleton.height = 64;
        singleton.backgroundColor = [UIColor blackColor];
        singleton.textColor = [UIColor whiteColor];
        singleton.alpha = 1.0;
        singleton.duration = 1.5;
        singleton.delay = 0.0;
        singleton.fontSize = 15;
    });
    return singleton;
}
@end

/**
 *  自定义一个用来让topAlertView消失的按钮
 */
@interface DismissBtn : UIButton
@property (strong, nonatomic) TCTopAlertView *topAlertView;
@end
@implementation DismissBtn
@end

@interface TCTopAlertView ()
@property (strong, nonatomic) UILabel *textLable;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) SystemSoundID successSoundEffectId;
@property (assign, nonatomic) BOOL openSound;
@end

@implementation TCTopAlertView


+ (void)setHeight:(CGFloat)height {
    TCT_SETTING.height = height;
}
+ (void)setFontSize:(CGFloat)fontSize {
    TCT_SETTING.fontSize = fontSize;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, -TCT_SETTING.height, TCT_SCREEN_WIDTH, TCT_SETTING.height);
        if (TCT_SETTING.height > 20) {
            ;
        }
        self.backgroundColor = TCT_SETTING.backgroundColor;
        self.alpha = TCT_SETTING.alpha;
        
        _textLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, TCT_SCREEN_WIDTH, TCT_SETTING.height - 20)];
        _textLable.adjustsFontSizeToFitWidth = YES;
        _textLable.textColor = TCT_SETTING.textColor;
        _textLable.font = [UIFont systemFontOfSize:TCT_SETTING.fontSize];
        _textLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLable];
    }
    return self;
}

+ (void)showMessage:(NSString *)message inView:(UIView *)view completion:(void (^)(void))completion {
    /**
     *  消除父视图中的AlertView
     */
    for (TCTopAlertView *topAlertView in view.subviews) {
        if ([topAlertView isMemberOfClass:[TCTopAlertView class]]) {
            [topAlertView removeFromSuperview];
        }
    }
    TCTopAlertView *topAlertView = [TCTopAlertView new];
    topAlertView.textLable.text = message;
    [view addSubview:topAlertView];
    // 点击消失按钮
    DismissBtn *dismissBtn = [[DismissBtn alloc] initWithFrame:CGRectMake(0, 0, topAlertView.bounds.size.width, topAlertView.bounds.size.height)];
    [topAlertView addSubview:dismissBtn];
    dismissBtn.topAlertView = topAlertView;
    [dismissBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchDown];
    [topAlertView playAnimationWithCompletion:completion];
}
+ (void)showMessage:(NSString *)message inView:(UIView *)view {
    [self showMessage:message inView:view completion:nil];
}
+ (void)showMessage:(NSString *)message completion:(void (^)(void))completion {
    [self showMessage:message inView:TCT_WINDOW completion:completion];
}
+ (void)showMessage:(NSString *)message {
    [self showMessage:message completion:nil];
}



/**ShowAnimation*/
- (void)playAnimationWithCompletion:(void (^)(void))completion {
    [UIView animateKeyframesWithDuration:TCT_SETTING.duration*0.5
                                   delay:TCT_SETTING.delay
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear|UIViewKeyframeAnimationOptionAllowUserInteraction
                              animations:^ {
                                  CGRect frame = self.frame;
                                  frame.origin.y = 0;
                                  self.frame = frame;
                              } completion:^(BOOL finished) {
                                  [UIView animateKeyframesWithDuration:TCT_SETTING.duration*0.3
                                                                 delay:TCT_SETTING.duration*0.5
                                                               options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                                            animations:^ {
                                                                CGRect frame = self.frame;
                                                                frame.origin.y = -(TCT_SETTING.height + 20 );
                                                                self.frame = frame;
                                                            } completion:^(BOOL finished) {
                                                                if (completion) {
                                                                    completion();
                                                                }
                                                                for (UIView *view in self.superview.subviews) {
                                                                    if ([view isKindOfClass:[DismissBtn class]]) {
                                                                        [view removeFromSuperview];
                                                                    }
                                                                }
                                                                [self removeFromSuperview];
                                                            }];
                              }];
}

+ (void)dismiss:(DismissBtn *)btn {
    NSLog(@"TAP:dismiss");
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = btn.topAlertView.frame;
        frame.origin.y -= frame.size.height;
        btn.topAlertView.frame = frame;
    } completion:^(BOOL finished) {
        [btn.topAlertView removeFromSuperview];
        [btn removeFromSuperview];
    }];
}




@end

