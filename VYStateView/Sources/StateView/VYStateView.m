//
//  VYStateView.m
//  VYStateView
//
//  Created by Vitaly Yurchenko on 13.04.12.
//  Copyright (c) 2012 Vitaly Yurchenko. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "VYStateView.h"

// ********************************************************************************************************************************************************** //

@interface VYStateView ()
{
    CGFloat _vy_margins;
    CGFloat _vy_horizontalPadding;
    CGFloat _vy_verticalPadding;
}

@property (nonatomic, strong) UIActivityIndicatorView *vy_activityIndicatorView;
@property (nonatomic, strong) UIImageView *vy_imageView;
@property (nonatomic, strong) UILabel *vy_titleLabel;
@property (nonatomic, strong) UILabel *vy_messageLabel;

- (void)vy_initialSetup;

- (UIFont *)vy_defaultTitleLabelFont;
- (UIFont *)vy_defaultMessageLabelFont;
- (UIColor *)vy_defaultTextColor;
- (UIColor *)vy_defaultTextShadowColor;
- (CGFloat)vy_defaultMargins;
- (CGFloat)vy_defaultHorizontalPadding;
- (CGFloat)vy_defaultVerticalPadding;

- (UIActivityIndicatorView *)vy_newActivityIndicatorView;
- (UIImageView *)vy_newImageView;
- (UILabel *)vy_newTitleLabel;
- (UILabel *)vy_newMessageLabel;

- (void)vy_alignSubviewsHorizontaly:(NSArray *)subviews usingPadding:(CGFloat)padding;
- (void)vy_alignSubviewsVerticaly:(NSArray *)subviews usingPadding:(CGFloat)padding;

@end

// ********************************************************************************************************************************************************** //

@implementation VYStateView

#pragma mark -
#pragma mark Object Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil)
    {
        [self vy_initialSetup];
    }
    
    return self;
}

#pragma mark -
#pragma mark <NSCoding>

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self != nil)
    {
        [self vy_initialSetup];
    }
    
    return self;
}

#pragma mark -
#pragma mark Overridden Methods

- (void)layoutSubviews
{
    const CGRect constraintRect = CGRectInset(self.bounds, self.margins, self.margins);
    const CGFloat constraintWidth = CGRectGetWidth(constraintRect);
    const CGFloat constraintHeight = CGRectGetHeight(constraintRect);
    
    switch (self.mode)
    {
        case VYStateViewModeStatic:
        {
            NSMutableArray *subviews = [NSMutableArray array];
            
            if (self.vy_imageView.superview != nil)
            {
                // Set image view bounds.
                CGFloat imageMaxWidth = constraintWidth;
                CGFloat imageWidth = self.image.size.width;
                
                CGFloat imageMaxHeight = constraintHeight / 2.0;
                CGFloat imageHeight = self.image.size.height;
                
                CGFloat imageViewWidth = imageWidth > imageMaxWidth ? imageMaxWidth : imageWidth;
                CGFloat imageViewHeight = imageHeight > imageMaxHeight ? imageMaxHeight : imageHeight;
                
                self.vy_imageView.frame = CGRectMake(0.0, 0.0, imageViewWidth, imageViewHeight);
                [subviews addObject:self.vy_imageView];
            }
            
            if (self.vy_titleLabel.superview != nil)
            {
                // Set title label bounds.
                CGSize titleLabelSize = [self.vy_titleLabel sizeThatFits:constraintRect.size];
                
                self.vy_titleLabel.frame = CGRectMake(0.0, 0.0, titleLabelSize.width, titleLabelSize.height);
                [subviews addObject:self.vy_titleLabel];
            }
            
            if (self.vy_messageLabel.superview != nil)
            {
                CGSize messageLabelSize = [self.vy_messageLabel sizeThatFits:constraintRect.size];
                
                self.vy_messageLabel.frame = CGRectMake(0.0, 0.0, messageLabelSize.width, messageLabelSize.height);
                [subviews addObject:self.vy_messageLabel];
            }
            
            // Align subviews.
            [self vy_alignSubviewsVerticaly:subviews usingPadding:self.verticalPadding];
            
            break;
        }
        case VYStateViewModeActivity:
        {
            NSMutableArray *subviews = [NSMutableArray array];
            
            if (self.vy_activityIndicatorView.subviews != nil)
            {
                [subviews addObject:self.vy_activityIndicatorView];
            }
            
            if (self.vy_titleLabel.superview != nil)
            {
                // Set title label bounds.
                CGFloat newConstraintWidth = constraintWidth - CGRectGetWidth(self.vy_activityIndicatorView.bounds) - self.horizontalPadding;
                CGSize titleLabelSize = [self.vy_titleLabel sizeThatFits:CGSizeMake(newConstraintWidth, constraintHeight)];
                
                self.vy_titleLabel.frame = CGRectMake(0.0, 0.0, titleLabelSize.width, titleLabelSize.height);
                [subviews addObject:self.vy_titleLabel];
            }
            else if (self.vy_messageLabel.superview != nil)
            {
                // Set message label bounds.
                CGFloat newConstraintWidth = constraintWidth - CGRectGetWidth(self.vy_activityIndicatorView.bounds) - self.horizontalPadding;
                CGSize messageLabelSize = [self.vy_messageLabel sizeThatFits:CGSizeMake(newConstraintWidth, constraintHeight)];
                
                self.vy_messageLabel.frame = CGRectMake(0.0, 0.0, messageLabelSize.width, messageLabelSize.height);
                [subviews addObject:self.vy_messageLabel];
            }
            
            // Align subviews.
            [self vy_alignSubviewsHorizontaly:subviews usingPadding:self.horizontalPadding];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark Accessors

- (void)setMode:(VYStateViewMode)mode
{
    _mode = mode;
    
    switch (_mode)
    {
        case VYStateViewModeStatic:
        {
            if (self.vy_activityIndicatorView.superview != nil)
            {
                [self.vy_activityIndicatorView removeFromSuperview];
                self.vy_activityIndicatorView = nil;
            }
            
            self.vy_imageView.hidden = NO;
            self.vy_titleLabel.hidden = NO;
            self.vy_messageLabel.hidden = NO;
            
            break;
        }
        case VYStateViewModeActivity:
        {
            if (self.vy_activityIndicatorView == nil)
            {
                self.vy_activityIndicatorView = [self vy_newActivityIndicatorView];
                [self addSubview:self.vy_activityIndicatorView];
            }
            
            [self.vy_activityIndicatorView startAnimating];
            
            self.vy_imageView.hidden = YES;
            self.vy_titleLabel.hidden = NO;
            self.vy_messageLabel.hidden = NO;
            
            break;
        }
        default:
            break;
    }
    
    [self setNeedsLayout];
}

- (UIImage *)image
{
    return self.vy_imageView.image;
}

- (void)setImage:(UIImage *)image
{
    if (image != nil)
    {
        if (self.vy_imageView == nil)
        {
            self.vy_imageView = [self vy_newImageView];
            [self addSubview:self.vy_imageView];
        }
        
        self.vy_imageView.image = image;
    }
    else if (self.vy_imageView.superview != nil)
    {
        [self.vy_imageView removeFromSuperview];
        self.vy_imageView = nil;
    }
    
    [self setNeedsLayout];
}

- (NSString *)title
{
    return self.vy_titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
    if (title != nil)
    {
        if (self.vy_titleLabel == nil)
        {
            self.vy_titleLabel = [self vy_newTitleLabel];
            [self addSubview:self.vy_titleLabel];
        }
        
        self.vy_titleLabel.text = title;
    }
    else if (self.vy_titleLabel.superview != nil)
    {
        [self.vy_titleLabel removeFromSuperview];
        self.vy_titleLabel = nil;
    }
    
    [self setNeedsLayout];
}

- (NSString *)message
{
    return self.vy_messageLabel.text;
}

- (void)setMessage:(NSString *)message
{
    if (message != nil)
    {
        if (self.vy_messageLabel == nil)
        {
            self.vy_messageLabel = [self vy_newMessageLabel];
            [self addSubview:self.vy_messageLabel];
        }
        
        self.vy_messageLabel.text = message;
    }
    else if (self.vy_messageLabel.superview != nil)
    {
        [self.vy_messageLabel removeFromSuperview];
        self.vy_messageLabel = nil;
    }
    
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedTitle
{
    return self.vy_titleLabel.attributedText;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    if (attributedTitle != nil)
    {
        if (self.vy_titleLabel == nil)
        {
            self.vy_titleLabel = [self vy_newTitleLabel];
            [self addSubview:self.vy_titleLabel];
        }
        
        self.vy_titleLabel.attributedText = attributedTitle;
    }
    else if (self.vy_titleLabel.superview != nil)
    {
        [self.vy_titleLabel removeFromSuperview];
        self.vy_titleLabel = nil;
    }
    
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedMessage
{
    return self.vy_messageLabel.attributedText;
}

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage
{
    if (attributedMessage != nil)
    {
        if (self.vy_messageLabel == nil)
        {
            self.vy_messageLabel = [self vy_newMessageLabel];
            [self addSubview:self.vy_messageLabel];
        }
        
        self.vy_messageLabel.attributedText = attributedMessage;
    }
    else if (self.vy_messageLabel.superview != nil)
    {
        [self.vy_messageLabel removeFromSuperview];
        self.vy_messageLabel = nil;
    }
    
    [self setNeedsLayout];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont != titleFont)
    {
        _titleFont = titleFont != nil ? titleFont : [self vy_defaultTitleLabelFont];
        
        self.vy_titleLabel.font = _titleFont;
        
        [self setNeedsLayout];
    }
}

- (void)setMessageFont:(UIFont *)messageFont
{
    if (_messageFont != messageFont)
    {
        _messageFont = messageFont != nil ? messageFont : [self vy_defaultMessageLabelFont];
        
        self.vy_messageLabel.font = _messageFont;
        
        [self setNeedsLayout];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (_textColor != textColor)
    {
        _textColor = textColor;
        
        self.vy_activityIndicatorView.color = _textColor;
        self.vy_titleLabel.textColor = _textColor;
        self.vy_messageLabel.textColor = _textColor;
    }
}

- (void)setTextShadowColor:(UIColor *)textShadowColor
{
    if (_textShadowColor != textShadowColor)
    {
        _textShadowColor = textShadowColor;
        
        self.vy_titleLabel.shadowColor = _textShadowColor;
        self.vy_messageLabel.shadowColor = _textShadowColor;
    }
}

#pragma mark -
#pragma mark Setup

- (void)vy_initialSetup
{
    // Set up view.
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    // Set default values.
    _titleFont = [self vy_defaultTitleLabelFont];
    _messageFont = [self vy_defaultMessageLabelFont];
    _textColor = [self vy_defaultTextColor];
    _textShadowColor = [self vy_defaultTextShadowColor];
    
    _vy_margins = [self vy_defaultMargins];
    _vy_horizontalPadding = [self vy_defaultHorizontalPadding];
    _vy_verticalPadding = [self vy_defaultVerticalPadding];
}

#pragma mark -
#pragma mark Default Values

- (UIFont *)vy_defaultTitleLabelFont
{
    UIFont *font = floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1
        ? [UIFont boldSystemFontOfSize:20.0]
        : [UIFont systemFontOfSize:27];
    
    return font;
}

- (UIFont *)vy_defaultMessageLabelFont
{
    UIFont *font = nil;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        font = [UIFont boldSystemFontOfSize:14.0];
    }
    else
    {
        switch (self.mode)
        {
            case VYStateViewModeStatic:
            {
                font = [UIFont systemFontOfSize:17];
                break;
            }
            case VYStateViewModeActivity:
            {
                font = [UIFont systemFontOfSize:14];
                break;
            }
            default:
                break;
        }
    }
    
    return font;
}

- (UIColor *)vy_defaultTextColor
{
    return [UIColor blackColor];
}

- (UIColor *)vy_defaultTextShadowColor
{
    return nil;
}

- (CGFloat)vy_defaultMargins
{
    return 20.0;
}

- (CGFloat)vy_defaultHorizontalPadding
{
    return floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1 ? 5.0 : 4.0;
}

- (CGFloat)vy_defaultVerticalPadding
{
    return floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1 ? 10.0 : 11.0;
}

#pragma mark -
#pragma mark Creating New Views

- (UIActivityIndicatorView *)vy_newActivityIndicatorView
{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.hidesWhenStopped = NO;
    activityIndicatorView.color = self.textColor;
    
    return activityIndicatorView;
}

- (UIImageView *)vy_newImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.opaque = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return imageView;
}

- (UILabel *)vy_newTitleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.font = self.titleFont != nil ? self.titleFont : [self vy_defaultTitleLabelFont];
    label.textColor = self.textColor;
    label.shadowColor = self.textShadowColor;
    label.shadowOffset = CGSizeMake(0.0, -1.0);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = NO;
    
    return label;
}

- (UILabel *)vy_newMessageLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.font = self.messageFont != nil ? self.messageFont : [self vy_defaultMessageLabelFont];
    label.textColor = self.textColor;
    label.shadowColor = self.textShadowColor;
    label.shadowOffset = CGSizeMake(0.0, -1.0);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = NO;
    
    return label;
}

#pragma mark -
#pragma mark Aligning Subviews

- (void)vy_alignSubviewsHorizontaly:(NSArray *)subviews usingPadding:(CGFloat)padding
{
    // Calculate subviews width.
    CGFloat contentWidth = -padding;
    
    for (UIView *subview in subviews)
    {
        contentWidth += CGRectGetWidth(subview.bounds) + padding;
    }
    
    // Align subviews.
    CGFloat horizontalShift = -contentWidth / 2.0;
    
    for (UIView *subview in subviews)
    {
        subview.center = CGPointMake(CGRectGetMidX(self.bounds) + CGRectGetMidX(subview.bounds) + horizontalShift, CGRectGetMidY(self.bounds));
        
        horizontalShift += CGRectGetWidth(subview.bounds) + padding;
    }
}

- (void)vy_alignSubviewsVerticaly:(NSArray *)subviews usingPadding:(CGFloat)padding
{
    // Calculate subviews height.
    CGFloat contentHeight = -padding;
    
    for (UIView *subview in subviews)
    {
        contentHeight += CGRectGetHeight(subview.bounds) + padding;
    }
    
    // Align subviews.
    CGFloat verticalShift = -contentHeight / 2.0;
    
    for (UIView *subview in subviews)
    {
        subview.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) + CGRectGetMidY(subview.bounds) + verticalShift);
        
        verticalShift += CGRectGetHeight(subview.bounds) + padding;
    }
}

@end

// ********************************************************************************************************************************************************** //

#pragma mark -
#pragma mark Extensions

@implementation VYStateView (VYStateViewAdvancedConfiguration)

- (CGFloat)margins
{
    return _vy_margins;
}

- (void)setMargins:(CGFloat)margins
{
    if (_vy_margins != margins)
    {
        _vy_margins = margins;
        
        [self setNeedsLayout];
    }
}

- (CGFloat)horizontalPadding
{
    return _vy_horizontalPadding;
}

- (void)setHorizontalPadding:(CGFloat)horizontalPadding
{
    if (_vy_horizontalPadding != horizontalPadding)
    {
        _vy_horizontalPadding = horizontalPadding;
        
        [self setNeedsLayout];
    }
}

- (CGFloat)verticalPadding
{
    return _vy_verticalPadding;
}

- (void)setVerticalPadding:(CGFloat)verticalPadding
{
    if (_vy_verticalPadding != verticalPadding)
    {
        _vy_verticalPadding = verticalPadding;
        
        [self setNeedsLayout];
    }
}

@end

// ********************************************************************************************************************************************************** //

#pragma mark -
#pragma mark UIColor Extensions

@implementation UIColor (VYStateViewAdditions)

+ (UIColor *)vy_darkGrayColor
{
    return [self colorWithWhite:0.4 alpha:1.0];
}

+ (UIColor *)vy_lightGrayColor
{
    return [self colorWithWhite:0.6 alpha:1.0];
}

@end
