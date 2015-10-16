//
//  ViewController.m
//  ITRFlipView
//
//  Created by kiruthika selvavinayagam on 10/15/15.
//  Copyright © 2015 kiruthika selvavinayagam. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "ITRFlipper.h"


@interface ViewController ()<ITRFlipperDataSource>
{
    ITRFlipper *itrFlipper;
    FirstViewController *_firstViewController;
    SecondViewController *_secondViewController;
    ThirdViewController *_thirdViewController;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _firstViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(FirstViewController.class)];
    _secondViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(SecondViewController.class)];
    _thirdViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(ThirdViewController.class)];
    
    //flipper view
    itrFlipper = [[ITRFlipper alloc] initWithFrame:self.view.bounds];
    [itrFlipper setBackgroundColor:[UIColor clearColor]];
    itrFlipper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    itrFlipper.dataSource = self;
    
    [self.view addSubview:itrFlipper];
}

#pragma ITRFlipper datasource
- (NSInteger) numberOfPagesinFlipper:(ITRFlipper *)pageFlipper {
    return 10;
}

- (UIView *) viewForPage:(NSInteger) page inFlipper:(ITRFlipper *) flipper {
    
    if(page % 3 == 0){
        return _firstViewController.view;
    }else if(page % 3 == 1){
        return _secondViewController.view;
    }else{
        return _thirdViewController.view;
    }
}


@end
