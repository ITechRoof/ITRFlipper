# ITRFlipper
Flipboard animation

## Requirements
* Xcode 6 or higher
* Apple LLVM compiler
* iOS 7.0 or higher
* ARC

## Demo

Build and run the `Example` project in Xcode to see `ITRFlipper` in action.

## Installation

### CocoaPods

The recommended approach for installating `ITRFlipper` is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.
For best results, it is recommended that you install via CocoaPods >= **0.28.0** using Git >= **1.8.0** installed via Homebrew.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
```

Edit your Podfile and add ITRFlipper:

``` bash
platform :ios, '6.0'
pod 'ITRFlipper', '~> 1.0.0'
```

Install into your Xcode project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= **1.8.0** by executing `git --version`. You can get a full picture of the installation details by executing `pod install --verbose`.

### Manual Install

All you need to do is drop `ITRFlipper` files into your project, and add `#import "ITRFlipper.h"` to the top of classes that will use it.

## Example Usage

Create and add flipper view as subview to your container. Set datasource to the flipper.

``` objective-c
//flipper view
    itrFlipper = [[ITRFlipper alloc] initWithFrame:self.view.bounds];
    [itrFlipper setBackgroundColor:[UIColor clearColor]];
    itrFlipper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    itrFlipper.dataSource = self;
    
    [self.view addSubview:itrFlipper];
```
numberOfPagesinFlipper: - returns the number of pages in the flip view.

``` objective-c
- (NSInteger) numberOfPagesinFlipper:(ITRFlipper *)pageFlipper {
    return 10;
}

```
viewForPage: inFlipper: - returns the view corresponding to the page.

``` objective-c
- (UIView *) viewForPage:(NSInteger) page inFlipper:(ITRFlipper *) flipper {
    
    if(page % 3 == 0){
        return _firstViewController.view;
    }else if(page % 3 == 1){
        return _secondViewController.view;
    }else{
        return _thirdViewController.view;
    }
}

```

## Contact

Kiruthika

- https://github.com/ITechRoof
- kirthi.shalom@gmail.com

## License

ITRFlipper is available under the MIT license.

Copyright (c) 2015 ITechRoof.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


