# Alert

## • Screenshots and Gifs

  <img align="left" src="http://i.imgur.com/4jqUDER.gif" alt="SS1" width="240" height="427"/>
  <img align="center" src="http://i.imgur.com/HnF5Lvp.png" alt="SS2" width="240" height="427"/>
  <img align="right" src="http://i.imgur.com/WBBZvmC.png" alt="SS3" width="240" height="427"/>
 
## • Installation

Just drag and drop the "Alert" folder into your project, and make sure you check the "Copy items into destination group's folder" box. Then import Alert.h wherever you need it. 
If you want delegate methods such as `AlertWillAppear` or `AlertDidDisappear` then import the `AlertDelegate` wherever you need it as well. 

```objective-c
#import "Alert.h"

@interface ViewController () <AlertDelegate>
```

## • Creating Alerts

Creating an Alert is easy: Add a title, and a duration (in seconds) and that's it.
If you want your alert to be endless you can simply put "0.0" in the duration and you can dismiss it manually.
```objective-c
    Alert *alert = [[Alert alloc] initWithTitle:@"I'm an alert!" duration:1.0 completion:^{
        //Custom code here after Alert disappears
    }];
    [alert setDelegate:self] //Optional - if you want delegate methods
    [alert showAlert];
```

## • Setting Alert Visual Attributes

###### - Alert colors
You can set Alert's background and title color. Use `AlertTypes` if you want to use our custom colors.
```objective-c
[alert setBackgroundColor:[UIColor whiteColor]];
[alert setTitleColor:[UIColor blackColor]];
```
## • Setting Incoming and Outgoing Transitions

###### - Incoming Transitions
Alert has 7 incoming transition types that can be used to add an animation while presenting your Alert.

```objective-c
[alert setIncomingTransition:AlertIncomingTransitionTypeFlip];
```

###### - Outgoing Transitions
Alert has 7 outgoing transition types that can be used to add an animation while dismissing your Alert.

```objective-c
[alert setOutgoingTransition:AlertOutgoingTransitionTypeSlideToTop];
```

###### - Bounces
Do you want your Alert to bounce when it is transitioning in or do you want smooth sliding? You can be the judge of that.
```objective-c
[alert setBounces:bounces];
```

###### - Status Bar
If you don't want the status bar to be shown when you show your Alert, you can easily hide it.
If you chose to do this, you must set "View controller-based status bar appearance" = NO in your Info.plist
```objective-c
[alert setShowStatusBar:YES];
```

###### - Alert Types
Alert has 3 types that can be used to color the background of your Alert. 

```objective-c
[alert setAlertType:AlertTypeError] //Red
[alert setAlertType:AlertTypeSuccess] //Blue
[alert setAlertType:AlertTypeWarning] //Yellow
```
## • Delegate Methods

###### - Appear and Disappear
Set Alerts's delegate functions to tell when your Alert is appearing or disappearing.

```objective-c
- (void)alertWillAppear:(Alert *)alert;
- (void)alertDidAppear:(Alert *)alert;
- (void)alertWillDisappear:(Alert *)alert;
- (void)alertDidDisappear:(Alert *)alert;
```
## • To-do
- Add more transitions
- Make transitions smoother
- Fix some issues with the demo

## • Say Hi

Tweet at me or something : [@markmiscavage](https://twitter.com/markmiscavage).

## • License

The MIT License (MIT)

Copyright (c) 2015 Mark Miscavage

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
