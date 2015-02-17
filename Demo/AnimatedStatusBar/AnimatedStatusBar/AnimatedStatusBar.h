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
// Boolean variables for checking the state of the status bar
@property (nonatomic, getter = isStatusBarHidden) BOOL statusBarHidden;
@property (nonatomic, getter = isMessageDisplayed) BOOL messageDisplayed;
@property (nonatomic, getter = isStatusBarFrozen) BOOL frozenStatusBar;
@property (nonatomic, getter = isCustomViewDisplayed) BOOL customViewDisplayed;
// Message Label references
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSString *message;
// Animation settings
@property (nonatomic) float duration;
@property (nonatomic) float springDamping;

// Get the UIView AnimatedStatusBar to access the above public variables
+ (AnimatedStatusBar*)sharedView;

// Status Bar methods
+ (void)show;
+ (void)hide;
+ (void)toggle;

// Message methods
+ (void)showMessage;
+ (void)showMessage:(NSString*)message;
+ (void)showMessage:(NSString*)message forDuration:(float)duration;
+ (void)hideMessage;
+ (void)toggleMessage;

// Custom view methods
+ (void)showCustomView:(UIView*)view;
+ (void)showCustomView:(UIView*)view forDuration:(float)duration;
+ (void)hideCustomView;

// Freeze methods
+ (void)freeze;
+ (void)unfreeze;

// Animation settings
+ (void)setAnimationDuration:(float)duration andSpringDamping:(float)damping;

@end
