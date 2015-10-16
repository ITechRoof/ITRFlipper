//
//  ITRFlipper.h
//  ITRFlipView
//
//  Created by kiruthika selvavinayagam on 10/15/15.
//  Copyright © 2015 kiruthika selvavinayagam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITRFlipper;

//Data source to set flip board screen
@protocol ITRFlipperDataSource

- (NSInteger) numberOfPagesinFlipper:(ITRFlipper *)flipper;
- (UIView *) viewForPage:(NSInteger)page inFlipper:(ITRFlipper *) flipper;

@end

//enum forflip direction
typedef enum {
    ITRFlipDirectionTop,
    ITRFlipDirectionBottom,
} ITRFlipDirection;


@interface ITRFlipper : UIView

@property (nonatomic,retain) NSObject <ITRFlipperDataSource> *dataSource;

@end
