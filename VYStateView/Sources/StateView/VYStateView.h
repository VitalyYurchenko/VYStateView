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
@property (nonatomic, copy) NSString *title; // Warning: set nil if you want use message in VYStateViewModeActivity mode.
@property (nonatomic, copy) NSString *message; // Warning: set nil if you want use title in VYStateViewModeActivity mode.

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIColor *textColor; // Default is whiteColor.
@property (nonatomic, strong) UIColor *textShadowColor; // Default is blackColor.

@end

// ********************************************************************************************************************************************************** //

@interface VYStateView (VYStateViewAdvancedConfiguration)

@property (nonatomic) CGFloat margins;
@property (nonatomic) CGFloat padding;

@end
