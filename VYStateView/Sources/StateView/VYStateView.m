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

@interface NSString (VYStateViewAdditions)

- (CGSize)vy_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)vy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end

// ********************************************************************************************************************************************************** //

static const CGFloat kVYStateViewMargin = 20.0;
static const CGFloat kVYStateViewPadding = 10.0;

static const CGFloat kVYStateViewTitleLabelFontSize = 20.0;
static const CGFloat kVYStateViewMessageLabelFontSize = 14.0;

// ********************************************************************************************************************************************************** //

@implementation VYStateView
{
    UIImageView *_imageView;
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel *_titleLabel;
    UILabel *_messageLabel;
    
    UIFont *_titleLabelFont;
    UIFont *_messageLabelFont;
}

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
    CGRect constraintRect = CGRectMake(
        CGRectGetMinX(self.bounds) + kVYStateViewMargin,
        CGRectGetMinY(self.bounds) + kVYStateViewMargin,
        CGRectGetWidth(self.bounds) - 2.0 * kVYStateViewMargin,
        CGRectGetHeight(self.bounds) - 2.0 * kVYStateViewMargin);
    CGFloat constraintWidth = CGRectGetWidth(constraintRect);
    CGFloat constraintHeight = CGRectGetHeight(constraintRect);
    
    switch (self.mode)
    {
        case VYStateViewModeStatic:
        {
            NSMutableArray *subviews = [NSMutableArray array];
            
            // Set image view bounds.
            if (_imageView.superview != nil)
            {
                CGFloat imageMaxWidth = constraintWidth;
                CGFloat imageWidth = self.image.size.width;
                
                CGFloat imageMaxHeight = constraintHeight / 2.0;
                CGFloat imageHeight = self.image.size.height;
                
                CGFloat imageViewWidth = imageWidth > imageMaxWidth ? imageMaxWidth : imageWidth;
                CGFloat imageViewHeight = imageHeight > imageMaxHeight ? imageMaxHeight : imageHeight;
                
                _imageView.frame = CGRectMake(0.0, 0.0, imageViewWidth, imageViewHeight);
                
                [subviews addObject:_imageView];
            }
            
            // Set title label bounds.
            if (_titleLabel.superview != nil)
            {
                CGSize titleLabelSize = [_titleLabel.text vy_sizeWithFont:_titleLabel.font constrainedToSize:constraintRect.size];
                
                _titleLabel.frame = CGRectMake(0.0, 0.0, titleLabelSize.width, titleLabelSize.height);
                
                [subviews addObject:_titleLabel];
            }
            
            // Set message label bounds.
            if (_messageLabel.superview != nil)
            {
                CGSize messageLabelSize = [_messageLabel.text vy_sizeWithFont:_messageLabel.font constrainedToSize:constraintRect.size];
                
                _messageLabel.frame = CGRectMake(0.0, 0.0, messageLabelSize.width, messageLabelSize.height);
                
                [subviews addObject:_messageLabel];
            }
            
            // Align subviews.
            [self vy_alignSubviewsVerticaly:subviews usingPadding:kVYStateViewPadding];
            
            break;
        }
        case VYStateViewModeActivity:
        {
            NSMutableArray *subviews = [NSMutableArray array];
            
            if (_activityIndicatorView.subviews != nil)
            {
                [subviews addObject:_activityIndicatorView];
            }
            
            // Set message label bounds.
            if (_messageLabel.superview != nil)
            {
                CGFloat width = constraintWidth - CGRectGetWidth(_activityIndicatorView.bounds) - kVYStateViewPadding;
                CGSize messageLabelSize = [_messageLabel.text vy_sizeWithFont:_messageLabel.font forWidth:width lineBreakMode:_messageLabel.lineBreakMode];
                
                _messageLabel.frame = CGRectMake(0.0, 0.0, messageLabelSize.width, messageLabelSize.height);
                
                [subviews addObject:_messageLabel];
            }
            
            // Align subviews.
            [self vy_alignSubviewsHorizontaly:subviews usingPadding:kVYStateViewPadding / 2.0];
            
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
            if (_activityIndicatorView.superview != nil)
            {
                [_activityIndicatorView removeFromSuperview];
                _activityIndicatorView = nil;
            }
            
            _imageView.hidden = NO;
            _titleLabel.hidden = NO;
            _messageLabel.hidden = NO;
            
            break;
        }
        case VYStateViewModeActivity:
        {
            if (_activityIndicatorView == nil)
            {
                _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                _activityIndicatorView.color = _textColor;
                
                [self addSubview:_activityIndicatorView];
                [_activityIndicatorView startAnimating];
            }
            
            _imageView.hidden = YES;
            _titleLabel.hidden = YES;
            _messageLabel.hidden = NO;
            
            break;
        }
        default:
            break;
    }
    
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        _image = image;
        
        if (_image != nil)
        {
            if (_imageView == nil)
            {
                _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                _imageView.opaque = NO;
                _imageView.backgroundColor = [UIColor clearColor];
                _imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                [self addSubview:_imageView];
            }
            
            _imageView.image = self.image;
        }
        else if (_imageView.superview != nil)
        {
            [_imageView removeFromSuperview];
            _imageView = nil;
        }
        
        [self setNeedsLayout];
    }
}

- (void)setTitle:(NSString *)title
{
    if (_title != title)
    {
        _title = [title copy];
        
        if (_title != nil)
        {
            if (_titleLabel == nil)
            {
                _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                _titleLabel.opaque = NO;
                _titleLabel.backgroundColor = [UIColor clearColor];
                _titleLabel.adjustsFontSizeToFitWidth = NO;
                _titleLabel.numberOfLines = 0;
                _titleLabel.shadowColor = self.textShadowColor;
                _titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                _titleLabel.textColor = self.textColor;
                _titleLabel.font = _titleLabelFont;
                
                [self addSubview:_titleLabel];
            }
            
            _titleLabel.text = self.title;
        }
        else if (_titleLabel.superview != nil)
        {
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
        
        [self setNeedsLayout];
    }
}

- (void)setMessage:(NSString *)message
{
    if (_message != message)
    {
        _message = [message copy];
        
        if (_message != nil)
        {
            if (_messageLabel == nil)
            {
                _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                _messageLabel.opaque = NO;
                _messageLabel.backgroundColor = [UIColor clearColor];
                _messageLabel.adjustsFontSizeToFitWidth = NO;
                _messageLabel.numberOfLines = 0;
                _messageLabel.shadowColor = self.textShadowColor;
                _messageLabel.shadowOffset = CGSizeMake(0.0, -1.0);
                _messageLabel.textAlignment = NSTextAlignmentCenter;
                _messageLabel.textColor = self.textColor;
                _messageLabel.font = _messageLabelFont;
                
                [self addSubview:_messageLabel];
            }
            
            _messageLabel.text = self.message;
        }
        else if (_messageLabel.superview != nil)
        {
            [_messageLabel removeFromSuperview];
            _messageLabel = nil;
        }
        
        [self setNeedsLayout];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (_textColor != textColor)
    {
        _textColor = textColor;
        
        _activityIndicatorView.color = _textColor;
        _titleLabel.textColor = _textColor;
        _messageLabel.textColor = _textColor;
    }
}

- (void)setTextShadowColor:(UIColor *)textShadowColor
{
    if (_textShadowColor != textShadowColor)
    {
        _textShadowColor = textShadowColor;
        
        _titleLabel.shadowColor = _textShadowColor;
        _messageLabel.shadowColor = _textShadowColor;
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)vy_initialSetup
{
    // Set up view.
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    // Set default values.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        _titleLabelFont = [UIFont boldSystemFontOfSize:kVYStateViewTitleLabelFontSize];
        _messageLabelFont = [UIFont boldSystemFontOfSize:kVYStateViewMessageLabelFontSize];
    }
    else
    {
        _titleLabelFont = [UIFont systemFontOfSize:kVYStateViewTitleLabelFontSize];
        _messageLabelFont = [UIFont systemFontOfSize:kVYStateViewMessageLabelFontSize];
    }
    
    _textColor = [UIColor whiteColor];
    _textShadowColor = [UIColor blackColor];
}

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
    // Calculate content height.
    CGFloat contentHeight = -padding;
    
    for (UIView *subview in subviews)
    {
        contentHeight += CGRectGetHeight(subview.bounds) + padding;
    }
    
    // Align content.
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

@implementation NSString (VYStateViewAdditions)

- (CGSize)vy_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    return [self sizeWithAttributes:@{NSFontAttributeName: font}];
#else
    return [self sizeWithFont:font forWidth:width lineBreakMode:lineBreakMode];
#endif
}

- (CGSize)vy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
#else
    return [self sizeWithFont:font constrainedToSize:size];
#endif
}

@end
