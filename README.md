# AnimatedStatusBar
Beautiful and simple implementation of animating and manipulating the iOS status bar.
- Hide/show the status bar with a customisable animation
- Present messages or custom views in place of the status bar
- Freeze the status bar to move it and manipulate it

Why is this implementation any better or different?
- It uses a Singleton so that it can be used or referenced from any part of your code
- It support all devices orientations (Landscape/Portrait)
- Provides full customisability 

## Setup
**Step 1.** Import the `AnimatedStatusBar.m` and `AnimatedStatusBar.h` files into your project. Then reference the `AnimatedStatusBar.h` file wherever you need it.

**Step 2.** add the line `[AnimatedStatusBar initialize];` in either your AppDelegate or ‘viewDidLoad’ method of your ViewController.

**Step 3.** in your `Info.plist` file, add a new row with the key “View controller-based status bar appearance”, and makes sure it is set to “NO”.  

![Plist addition](Images/plist.png)

Then you are good to go! Most uses only take a single line of code... SO GOOD!

**Note: (iPhone Only apps)** if your app is iPhone only, add the following line of code. `[AnimatedStatusBar sharedView].iPhoneOnly = YES;`. If you do not do this, then the animations will appear really weird if the app is ever run on an iPad.  

## Show/Hide Status Bar
To hide, show or toggle the status bar, use any of these single line pieces of code...
``` objc
[AnimatedStatusBar show]; // Will show the status bar
[AnimatedStatusBar hide]; // Will hide the status bar
[AnimatedStatusBar toggle]; // Will toggle the status bar
```

## Showing a Message
![Status Bar message demo](Images/statusBarMessage.gif)
To show a message, use this one liner…
``` objc
[AnimatedStatusBar showMessage:@"Data is in sync!" forDuration:2.0];
```

### Editing the message
The message itself can be set multiple ways.
``` objc
[AnimatedStatusBar sharedView].message = @"Important Message";
[AnimatedStatusBar sharedView].messageLabel.text = @"Important Message";
```

### Animating the message
``` objc
[AnimatedStatusBar showMessage:@"Last updated 2 hours ago"]; // Will set the message text and then show it
[AnimatedStatusBar showMessage]; // Will show the message, using whatever text has previously been set to
[AnimatedStatusBar hideMessage]; // Hide the message (if it is currently shown)
[AnimatedStatusBar toggleMessage]; // Toggle the message
[AnimatedStatusBar showMessage:@"Data is in sync!" forDuration:2.0]; // Will set the message text, display it and then hide it after a set duration
```

### Customising the message label
The message label can be completely customised, like so…
``` objc
UILabel *messageLabel = [AnimatedStatusBar sharedView].messageLabel;
messageLabel.backgroundColor = [UIColor greenColor];
messageLabel.textColor = [UIColor whiteColor];
messageLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:12.0];
```

## Custom view
Show a custom `UIView` in place of the status bar, with an animation. All the following methods are supported.
``` objc
[AnimatedStatusBar showCustomView:customView];
[AnimatedStatusBar showCustomView:customView forDuration:3.0];
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

[UIView animateWithDuration:0.3 
                      delay:0 
     usingSpringWithDamping:0.65 
      initialSpringVelocity:0 
                    options:UIViewAnimationOptionCurveEaseIn 
                 animations:^{
    statusBar.center = CGPointMake(self.view.frame.size.width/2.0, statusBar.center.y);
}completion:nil];
```

## Customising the animation timing
The duration and spring damping can be adjusted with the method
``` objc
[AnimatedStatusBar setAnimationDuration:1.0 andSpringDamping:0.8];
```
The default duration is 0.5, and default spring damping is 0.6.

## License
`AnimatedStatusBar` is released under the [MIT license](https://github.com/DWilliames/AnimatedStatusBar/blob/master/LICENSE).