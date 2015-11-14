//
//  UIViewController+SBP.m
//  EZSB
//
//  Created by Arjay Waran on 11/12/15.
//  Copyright © 2015 ZettaStomp. All rights reserved.
//

#import "UIViewController+SBP.h"
#include <sys/utsname.h>

@implementation UIViewController (SBP)
#pragma UIViews
- (void)switchViewConst:(UIView*)firstView secondView:(UIView*)secondView durationInSeconds:(double)durationInSeconds {
    [self swapView:firstView withView:secondView];
    
    [UIView animateWithDuration:durationInSeconds
                          delay:0.0f
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [self.view layoutIfNeeded];
                         
                     }
                     completion:nil];
    
}




#pragma Segues
- (void)segueScreenSizeSplit:(NSString*)baseSegueName {
    @try {
        [self performSegueWithIdentifier:[self getPhoneTitle:baseSegueName] sender:self];
    } @catch (NSException *exception) {
        NSLog(@"UIViewController+SBP api error (segueScreenSizeSplit): %@", exception);
    }
    
}


#pragma Helper functions
- (void)swapView:(UIView*) source withView:(UIView*) dest {
    //Trade constraints of parent
    NSMutableArray* parentsDone = [[NSMutableArray alloc] init];
    [self swapViewAllParent:source withView:dest curParent:source.superview parentsDone:parentsDone];
    [self swapViewAllParent:source withView:dest curParent:dest.superview parentsDone:parentsDone];
    
    //trade all constraints of the views themselves
    NSMutableArray* newDestConstraints = [self getReplaceConstraints:source dest:dest];
    NSMutableArray* newSourceConstraints = [self getReplaceConstraints:dest dest:source];
    [dest addConstraints:newDestConstraints];
    [source addConstraints:newSourceConstraints];
}

- (void) swapViewAllParent:(UIView*)source withView:(UIView*)dest curParent:(UIView*)curParent parentsDone:(NSMutableArray*)parentsDone {
    if ([parentsDone containsObject:curParent.superview]) {
        return;
    }
    [parentsDone addObject:curParent];
    if (curParent.superview != Nil) { //if there is a parent view and we haven't visited it yet
        [self swapViewAllParent:source withView:dest curParent:curParent.superview parentsDone:parentsDone];
    }
    NSArray* constraints = [curParent.constraints copy];
    NSMutableArray* constToAdd = [[NSMutableArray alloc] init];
    for (NSLayoutConstraint* constraint in constraints) {
        id first = constraint.firstItem;
        id second = constraint.secondItem;
        id newFirst = first;
        id newSecond = second;
        
        BOOL match = NO;
        if (first == dest) {
            newFirst = source;
            match = YES;
        }
        if (second == dest) {
            newSecond = source;
            match = YES;
        }
        if (first == source) {
            newFirst = dest;
            match = YES;
        }
        if (second == source) {
            newSecond = dest;
            match = YES;
        }
        //if there's a match, remove the constraint and create a new one with the replaceing restraint
        if (match && newFirst) {
            NSLayoutConstraint* newConst = [self tradeConstraints:curParent constraint:constraint newFirst:newFirst newSecond:newSecond];
            [constToAdd addObject:newConst];
        }
    }
    [curParent addConstraints:constToAdd];
    
}

//gets the replacement constraints and removes the original
- (NSMutableArray*) getReplaceConstraints:(UIView*)source dest:(UIView*)dest {
    NSMutableArray* newDestConstraints = [NSMutableArray array];
    
    NSArray* constraints = [source.constraints copy];
    for (NSLayoutConstraint* constraint in constraints) {
        if ([constraint class] == [NSLayoutConstraint class]
            && constraint.firstItem == source) {
            NSLayoutConstraint* newConstraint = nil;
            newConstraint = [NSLayoutConstraint constraintWithItem:dest
                                                         attribute:constraint.firstAttribute
                                                         relatedBy:constraint.relation
                                                            toItem:constraint.secondItem
                                                         attribute:constraint.secondAttribute
                                                        multiplier:constraint.multiplier
                                                          constant:constraint.constant];
            newConstraint.shouldBeArchived = constraint.shouldBeArchived;
            [newDestConstraints addObject:newConstraint];
            [source removeConstraint:constraint];
        }
    }
    return newDestConstraints;
}

//returns constraint to add, removes old constraint
- (NSLayoutConstraint*) tradeConstraints:(UIView*)viewWithConstraint constraint:(NSLayoutConstraint*)constraint newFirst:(id)newFirst newSecond:(id)newSecond {
    
    @try {
        [viewWithConstraint removeConstraint:constraint];
        NSLayoutConstraint* newConstraint = nil;
        newConstraint = [NSLayoutConstraint constraintWithItem:newFirst
                                                     attribute:constraint.firstAttribute
                                                     relatedBy:constraint.relation
                                                        toItem:newSecond
                                                     attribute:constraint.secondAttribute
                                                    multiplier:constraint.multiplier
                                                      constant:constraint.constant];
        newConstraint.shouldBeArchived = constraint.shouldBeArchived;
        newConstraint.priority = 1000;
        return newConstraint;
    } @catch (NSException *exception) {
        NSLog(@"Constraint exception: %@\nFor constraint: %@", exception, constraint);
    }
    return Nil;
}




- (NSString*) platformCode {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* platform =  [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return platform;
}

- (NSString*) getPhoneTitle:(NSString*)title {
    NSString* platform = [self platformCode];
    
    NSString* postFix = @"_4_7";
    if ([platform hasPrefix:@"iPhone1"] || [platform hasPrefix:@"iPhone2"] || [platform hasPrefix:@"iPad"]) { //all phones 3g and below as well as iPADS
        postFix = @"_3_5";
    } else if ([platform hasPrefix:@"iPhone3"] || [platform hasPrefix:@"iPhone4"] || [platform hasPrefix:@"iPod1"]|| [platform hasPrefix:@"iPod2"]|| [platform hasPrefix:@"iPod3"]|| [platform hasPrefix:@"iPod4"]) { //iphone 4 and 4s
        postFix = @"_3_5";
    } else if ([platform hasPrefix:@"iPhone5"] || [platform hasPrefix:@"iPhone6"] || [platform hasPrefix:@"iPod"]) { //iphone 5 and 5s
        postFix = @"_4";
    } else if ([platform hasPrefix:@"iPhone7,2"] || [platform hasPrefix:@"iPhone8,1"]) { //iphone 6 and 6s
        postFix = @"_4_7";
    } else if ([platform hasPrefix:@"iPhone7,1"] || [platform hasPrefix:@"iPhone8,2"]) { //iphone 6 plus and 6s plus
        postFix = @"_5_5";
    }
    
    return [title stringByAppendingString:postFix];
}


@end
