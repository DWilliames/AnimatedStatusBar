//
//  AnimatedStatusBar.h
//  AnimatedStatusBar
//
//  Created by David Williames on 13/02/2015.
//  Copyright (c) 2015 davidwilliames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedStatusBar : UIView

// To be set to YES if implmented in iPhone app only (not universal) - to prevent 'weirdness' when iPhone app is run on an iPad
@property (nonatomic, getter = isiPhoneOnly) BOOL iPhoneOnly;

@property (nonatomic, getter = isStatusBarHidden) BOOL statusBarHidden;
@property (nonatomic, getter = isMessageDisplayed) BOOL messageDisplayed;
@property (nonatomic, getter = isStatusBarFrozen) BOOL frozenStatusBar;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSString *message;

+ (AnimatedStatusBar*)sharedView;

+ (void)showStatusBar;
+ (void)hideStatusBar;
+ (void)toggleStatusBar;

+ (void)showMessage;
+ (void)showMessage:(NSString*)message;
+ (void)showMessage:(NSString*)message forDuration:(float)duration;
+ (void)hideMessage;
+ (void)toggleMessage;

+ (void)showCustomView:(UIView*)view;
+ (void)hideCustomView;

+ (void)freeze;
+ (void)unfreeze;

@end
