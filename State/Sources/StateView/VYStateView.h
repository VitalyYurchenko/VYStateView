//
//  VYStateView.h
//  State
//
//  Created by Vitaly Yurchenko on 13.04.12.
//  Copyright (c) 2012 Vitaly Yurchenko. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import <UIKit/UIKit.h>

// ********************************************************************************************************************************************************** //

enum
{
    VYStateViewModeStatic = 0,
    VYStateViewModeActivity
};
typedef NSUInteger VYStateViewMode;

// ********************************************************************************************************************************************************** //

@interface VYStateView : UIView

@property (nonatomic, assign) VYStateViewMode mode;

@property (nonatomic, strong) UIImage *image; // Currently disabled in VYStateViewModeActivity mode.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message; // Currently disabled in VYStateViewModeActivity mode.

@property (nonatomic, strong) UIColor *textColor; // Default to whiteColor.
@property (nonatomic, strong) UIColor *textShadowColor; // Default to blackColor.

@end
