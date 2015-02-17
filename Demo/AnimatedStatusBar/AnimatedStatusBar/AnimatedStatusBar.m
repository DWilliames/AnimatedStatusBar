//
//  AnimatedStatusBar.m
//  AnimatedStatusBar
//
//  Created by David Williames on 13/02/2015.
//  Copyright (c) 2015 davidwilliames. All rights reserved.
//

#import "AnimatedStatusBar.h"

#define STATUS_BAR_HEIGHT statusBarHeight
#define SPRING_DAMPING self.springDamping
#define DURATION self.duration

@interface AnimatedStatusBar ()
@property (nonatomic, strong) UIView *statusBarSnapshot;
@property (nonatomic, strong) UIView *statusBarSnapshotContainer;
@property (nonatomic, strong) UIView *lastPortraitStatusBarSnapshot;
@property (nonatomic, strong) UIView *lastLandscapeStatusBarSnapshot;
@property (nonatomic, strong) UIView *customView;
@end

@implementation AnimatedStatusBar

#define SingletonImplementation(METHOD)  \
+ (void)METHOD {    \
[[AnimatedStatusBar sharedView] METHOD];   \
}

@synthesize
message = _message,
frozenStatusBar = _frozenStatusBar,
customViewDisplayed = _customViewDisplayed,
iPhoneOnly = _iPhoneOnly;

CGFloat viewWidth;

int hiding = 0;
int showing = 0;
CGFloat statusBarHeight;

// SINGLETON METHODS

+ (void)initialize {
    [AnimatedStatusBar sharedView];
}

+ (AnimatedStatusBar*)sharedView {
    
    static dispatch_once_t once;
    static AnimatedStatusBar *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[AnimatedStatusBar alloc] init];
    });
    return sharedView;
}

SingletonImplementation(toggle)
SingletonImplementation(toggleMessage)
SingletonImplementation(hide)
SingletonImplementation(show)
SingletonImplementation(hideMessage)
SingletonImplementation(showMessage)
SingletonImplementation(freeze)
SingletonImplementation(unfreeze)
SingletonImplementation(hideCustomView)

+ (void)showCustomView:(UIView*)view {
    [[AnimatedStatusBar sharedView] showCustomView:view];
}

+ (void)showCustomView:(UIView *)view forDuration:(float)duration {
    [[AnimatedStatusBar sharedView] showCustomView:view forDuration:duration];
}

+ (void)showMessage:(NSString *)message {
    [[AnimatedStatusBar sharedView] showMessage:message];
}

+ (void)showMessage:(NSString *)message forDuration:(float)duration {
    [[AnimatedStatusBar sharedView] showMessage:message forDuration:duration];
}

+ (void)setAnimationDuration:(float)duration andSpringDamping:(float)damping {
    [AnimatedStatusBar sharedView].duration = duration;
    [AnimatedStatusBar sharedView].springDamping = damping;
}

// PRIVATE METHODS

- (instancetype)init{
    viewWidth = [[UIScreen mainScreen] bounds].size.width;
    statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if(self = [super init]) {
        self.frame = CGRectMake(0, 0, viewWidth, STATUS_BAR_HEIGHT);
        self.clipsToBounds = YES;
        
        self.duration = 0.5;
        self.springDamping = 0.6;
        
        UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [vc.view addSubview:self];
        
        self.statusBarSnapshotContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, STATUS_BAR_HEIGHT)];
        [self addSubview:self.statusBarSnapshotContainer];
        
        self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, viewWidth, STATUS_BAR_HEIGHT)];
        self.messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.messageLabel];
        
        self.messageLabel.textColor = [[UIApplication sharedApplication]statusBarStyle] == UIStatusBarStyleDefault ? [UIColor blackColor] : [UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(deviceOrientationDidChangeNotification:)
         name:UIDeviceOrientationDidChangeNotification
         object:nil];
        
    }
    return self;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.messageLabel.text = message;
}

- (NSString*)message {
    return self.messageLabel.text;
}

- (void)toggleMessage {
    if(self.isMessageDisplayed)
        [self hideMessage];
    else [self showMessage];
}

- (void)toggle {
    if(self.isStatusBarHidden)
        [self show];
    else [self hide];
}

- (void)show {
    NSLog(@"Show Status Bar");
    showing++;
    
    [UIView animateWithDuration:DURATION delay:0 usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.statusBarSnapshotContainer.frame = CGRectMake(0, 0, viewWidth, STATUS_BAR_HEIGHT);
    }completion:^(BOOL finished){
        if(hiding == 0 && !self.isStatusBarFrozen){
            [self shouldHideStatusBar:NO];
        }
        showing--;
    }];
}

- (void)hide {
    NSLog(@"Hide Status Bar");
    hiding++;
    
    if(!self.isStatusBarFrozen){
        [self snapshotStatusBar];
        [self shouldHideStatusBar:YES];
    }
    
    [UIView animateWithDuration:DURATION delay:0 usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.statusBarSnapshotContainer.frame = CGRectMake(0, -STATUS_BAR_HEIGHT, viewWidth, STATUS_BAR_HEIGHT);
    }completion:^(BOOL finished){
        hiding--;
    }];
}

- (void)showCustomView:(UIView*)view {
    if(self.isCustomViewDisplayed || self.isMessageDisplayed)
        return;
    
    self.customView = view;
    
    [self addSubview:view];
    view.center = CGPointMake(self.frame.size.width/2.0, STATUS_BAR_HEIGHT/2.0 + view.frame.size.height);
    
    NSLog(@"Show Custom View");
    if(!self.isStatusBarHidden || showing)
        [self hide];
    
    _customViewDisplayed = YES;
    [UIView animateWithDuration:DURATION delay:0 usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.center = CGPointMake(self.frame.size.width/2.0, STATUS_BAR_HEIGHT/2.0);
    }completion:nil];
    
}

- (void)hideCustomView {
    if(!self.customView || !self.isCustomViewDisplayed)
        return;
    
    NSLog(@"Hide Custom View");
    if(self.isStatusBarHidden || hiding)
        [self show];
    
     self.customViewDisplayed = NO;
    [UIView animateWithDuration:DURATION delay:0 usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.customView.center = CGPointMake(self.frame.size.width/2.0, STATUS_BAR_HEIGHT/2.0 + self.customView.frame.size.height);
    }completion:nil];
}

- (void)showCustomView:(UIView*)view forDuration:(float)duration {
    if(self.isCustomViewDisplayed)
        return;
    [self showCustomView:view];
    [self performSelector:@selector(hideCustomView) withObject:nil afterDelay:duration];
}

- (void)setCustomViewDisplayed:(BOOL)customViewDisplayed {
    if(customViewDisplayed && !_customViewDisplayed){
        [self hideCustomView];
    } else if(!customViewDisplayed && _customViewDisplayed && self.customView){
        [self showCustomView:self.customView];
    }
    _customViewDisplayed = customViewDisplayed;
}

- (void)showMessage:(NSString*)message forDuration:(float)duration {
    if(self.isMessageDisplayed)
        return;
    [self showMessage:message];
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:duration];
}

- (void)showMessage:(NSString*)message {
    self.message = message;
    [self showMessage];
}

- (void)showMessage {
    if(self.isMessageDisplayed || self.isCustomViewDisplayed)
        return;
    
    NSLog(@"Show Message");
    if(!self.isStatusBarHidden || showing)
        [self hide];
    
    self.messageDisplayed = YES;
    [UIView animateWithDuration:DURATION delay:0 usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.messageLabel.frame = CGRectMake(0, 0, viewWidth, STATUS_BAR_HEIGHT);
    }completion:nil];
}

- (void)hideMessage {
    if(!self.isMessageDisplayed)
        return;
    
    NSLog(@"Hide Message");
    if(self.isStatusBarHidden || hiding)
        [self show];
    
    self.messageDisplayed = NO;
    [UIView animateWithDuration:DURATION delay:0 usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.messageLabel.frame = CGRectMake(0, STATUS_BAR_HEIGHT, viewWidth, STATUS_BAR_HEIGHT);
    }completion:nil];
}

- (void)snapshotStatusBar {
    NSLog(@"Snapshot!");
    if(self.statusBarSnapshot)
        [self.statusBarSnapshot removeFromSuperview];
    UIView *snapshot = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    [self setSnapshot:snapshot];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            self.lastPortraitStatusBarSnapshot = snapshot;
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            self.lastLandscapeStatusBarSnapshot = snapshot;
            break;
        default:
            break;
    }
}

- (void)setSnapshot:(UIView*)snapshot {
    if(self.statusBarSnapshot)
        [self.statusBarSnapshot removeFromSuperview];
    self.statusBarSnapshot = snapshot;
    [self.statusBarSnapshotContainer addSubview:self.statusBarSnapshot];
    [self.superview bringSubviewToFront:self];
}

- (void)freeze {
    if(!self.isStatusBarFrozen)
        self.frozenStatusBar = YES;
}

- (void)unfreeze {
    if(self.isStatusBarFrozen)
        self.frozenStatusBar = NO;
}

- (void)setFrozenStatusBar:(BOOL)frozenStatusBar {
    _frozenStatusBar = frozenStatusBar;
    if(_frozenStatusBar && !self.isStatusBarHidden){
        [self snapshotStatusBar];
        [self shouldHideStatusBar:YES];
    } else if(!_frozenStatusBar && self.isStatusBarHidden && !self.isMessageDisplayed && !self.isCustomViewDisplayed){
        [self.statusBarSnapshot removeFromSuperview];
        [self shouldHideStatusBar:NO];
    }
}

- (void)setIPhoneOnly:(BOOL)iPhoneOnly {
    _iPhoneOnly = iPhoneOnly;
    if([[UIDevice currentDevice].model hasPrefix:@"iPad"] && iPhoneOnly){
        self.statusBarSnapshotContainer.hidden = YES;
        [self shouldHideStatusBar:YES];
    }
}

- (void)shouldHideStatusBar:(BOOL)hidden {
    self.statusBarHidden = hidden;
    if(!hidden)
        [self.statusBarSnapshot removeFromSuperview];
    if(self.isiPhoneOnly)
        hidden = YES;
    NSLog(@"Should Hide Status bar: %@", hidden ? @"YES" : @"NO");
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationNone];
}

- (void)updateToFitWidth {
    NSLog(@"Update to fit width");
    viewWidth = [[UIScreen mainScreen] bounds].size.width;
    
    self.frame = CGRectMake(0, 0, viewWidth, STATUS_BAR_HEIGHT);
    self.statusBarSnapshotContainer.frame = CGRectMake(0, self.statusBarSnapshotContainer.frame.origin.y, viewWidth, STATUS_BAR_HEIGHT);
    self.messageLabel.frame = CGRectMake(0, self.messageLabel.frame.origin.y, viewWidth, STATUS_BAR_HEIGHT);
    
    if(self.customView)
        self.customView.center = CGPointMake(viewWidth/2.0, self.customView.center.y);
}

- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    if(!self.isStatusBarHidden && !self.isiPhoneOnly)
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        {
            if(!self.isStatusBarHidden)
                self.lastPortraitStatusBarSnapshot = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
            else if(self.lastPortraitStatusBarSnapshot)
                [self setSnapshot:self.lastPortraitStatusBarSnapshot];
            else [self setSnapshot:nil];
            
            NSLog(@"PORTRAIT! - %f wide", self.superview.frame.size.width);
            [self updateToFitWidth];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            if(!self.isStatusBarHidden)
                self.lastLandscapeStatusBarSnapshot = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
            else if(self.lastLandscapeStatusBarSnapshot)
                [self setSnapshot:self.lastLandscapeStatusBarSnapshot];
            else [self setSnapshot:nil];
            
            NSLog(@"LANDSCAPE - %f wide", self.superview.frame.size.width);
            [self updateToFitWidth];
        }
            break;
        default:
            break;
    }
}

@end
