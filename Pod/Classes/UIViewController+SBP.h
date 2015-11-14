//
//  UIViewController+SBP.h
//  EZSB
//
//  Created by Arjay Waran on 11/12/15.
//  Copyright © 2015 ZettaStomp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SBP)


- (void)switchViewConst:(UIView*)firstView secondView:(UIView*)secondView durationInSeconds:(double)durationInSeconds;

- (void)segueScreenSizeSplit:(NSString*)baseSegueName;


@end
