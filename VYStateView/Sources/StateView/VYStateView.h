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

NS_CLASS_AVAILABLE_IOS(6_0) @interface VYStateView : UIView

/*
 mode: default is VYStateViewModeStatic.
 */
@property (nonatomic) VYStateViewMode mode;

/*
 image: currently disabled in VYStateViewModeActivity mode.
 
 title: warning: set nil if you want use message in VYStateViewModeActivity mode.
 
 message: warning: set nil if you want use title in VYStateViewModeActivity mode.
 */
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

/*
 attributedTitle: warning: set nil if you want use message in VYStateViewModeActivity mode.
 
 attributedMessage: warning: set nil if you want use title in VYStateViewModeActivity mode.
 */
@property (nonatomic, copy) NSAttributedString *attributedTitle;
@property (nonatomic, copy) NSAttributedString *attributedMessage;

/*
 titleFont: default is nil which mean:
    iOS 6 - system font 20pt bold;
    iOS 7 - system font 27pt plain.
 
 messageFont: default is nil which mean:
    iOS 6 - system font 14pt bold;
    iOS 7 - system font 17pt plain in VYStateViewModeStatic;
    iOS 7 - system font 14pt plain in VYStateViewModeActivity.
 
 textColor: default is blackColor.
 
 textShadowColor: default is nil.
 */
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textShadowColor;

@end

// ********************************************************************************************************************************************************** //

@interface VYStateView (VYStateViewAdvancedConfiguration)

@property (nonatomic) CGFloat margins;
@property (nonatomic) CGFloat horizontalPadding;
@property (nonatomic) CGFloat verticalPadding;

@end

// ********************************************************************************************************************************************************** //

@interface UIColor (VYStateViewAdditions)

+ (UIColor *)vy_darkGrayColor; // 0.4 white.
+ (UIColor *)vy_lightGrayColor; // 0.6 white.

@end
