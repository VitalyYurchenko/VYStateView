//
//  VYStateView.h
//  VYStateView
//
//  Created by Vitaly Yurchenko on 13.04.12.
//  Copyright (c) 2012 Vitaly Yurchenko. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import <UIKit/UIKit.h>

// ********************************************************************************************************************************************************** //

typedef NS_ENUM(NSUInteger, VYStateViewMode)
{
    VYStateViewModeStatic = 0,
    VYStateViewModeActivity
};

// ********************************************************************************************************************************************************** //

@interface VYStateView : UIView

@property (nonatomic) VYStateViewMode mode; // Default is VYStateViewModeStatic.

@property (nonatomic, strong) UIImage *image; // Currently disabled in VYStateViewModeActivity mode.
@property (nonatomic, copy) NSString *title; // Currently disabled in VYStateViewModeActivity mode.
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UIColor *textColor; // Default is whiteColor.
@property (nonatomic, strong) UIColor *textShadowColor; // Default is blackColor.

@end
