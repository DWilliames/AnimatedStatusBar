# AnimatedStatusBar
Beautiful and simple implementation of animating and manipulating the iOS status bar.
- Hide/show the status bar with an animation
- Present messages or custom views in place of the status bar
- Freeze the status bar to move it and manipulate it

Why is this implementation any better or different?
- It uses a Singleton so that it can be used or referenced from any part of your code
- It support all orientations
- Provides full customisability 

## Setup
Firstly import the `AnimatedStatusBar.m` and `AnimatedStatusBar.h` files into your project. Then reference the `AnimatedStatusBar.h` file wherever you need it.

**Important:** in your `Info.plist` file, add a new row with the key “View controller-based status bar appearance”, and makes sure it is set to “NO”. 
**Also important:** if your app is iPhone only, add the following line of code. `[AnimatedStatusBar sharedView].iPhoneOnly = YES;`. If you do not do this then the animations will appear really weird if the app is ever run on an iPad.

Then you are good to go! Most uses only take a single line of code... SO GOOD!

## Showing a Message
There are multiple methods for manipulating a message. The most common one is: 
`+ (void)showMessage:(NSString*)message forDuration:(float)duration`

Use it anywhere in your code like so...
``` objc
[AnimatedStatusBar showMessage:@"Data is in sync!" forDuration:2.0];
```

You can also manually control the message with the following methods...
``` objc
[AnimatedStatusBar showMessage:@"Last updated 2 hours ago"];
[AnimatedStatusBar sharedView].message = @"Important Message";
[AnimatedStatusBar showMessage];
[AnimatedStatusBar hideMessage];
[AnimatedStatusBar toggleMessage];
```

The message label can be completely customised
``` objc
UILabel *messageLabel = [AnimatedStatusBar sharedView].messageLabel;
messageLabel.backgroundColor = [UIColor greenColor];
messageLabel.textColor = [UIColor whiteColor];
messageLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:12.0];
```

## Show/Hide Status Bar
To hide, show or toggle the status bar, use any of the single line pieces of code...
``` objc
[AnimatedStatusBar show];
[AnimatedStatusBar hide];
[AnimatedStatusBar toggle];
```

## Custom view
Show or hide a custom view like so...
``` objc
[AnimatedStatusBar showCustomView:customView];
[AnimatedStatusBar hideCustomView];
```
The custom view will be cropped to be the width of the screen and 20pt high.

## Freezing Status Bar
You can freeze or unfreeze the status bar to be able to manipulate it. *Note:* freezing it utilises a ‘snapshot’ of the status bar, and it does not continue to render live. So do not keep it frozen for long periods of time.
``` objc
[AnimatedStatusBar freeze];
[AnimatedStatusBar unfreeze];
```

## Manipulating the Status Bar
To manipulate the status Bar, first freeze it, and reference it. (It is a subclass of `UIView`)
``` objc
UIView* statusBar = [AnimatedStatusBar sharedView];
[AnimatedStatusBar freeze];

[UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    statusBar.center = CGPointMake(self.view.frame.size.width/2.0, statusBar.center.y);
}completion:nil];
```