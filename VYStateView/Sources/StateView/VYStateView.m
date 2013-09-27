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

static const CGFloat kVYStateViewMargin = 20.0;
static const CGFloat kVYStateViewPadding = 10.0;

static const CGFloat kVYStateViewTitleLabelFontSize = 20.0;
static const CGFloat kVYStateViewMessageLabelFontSize = 14.0;

// ********************************************************************************************************************************************************** //

@interface NSString (VYStateViewAdditions)

- (CGSize)vy_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)vy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end

// ********************************************************************************************************************************************************** //

@interface VYStateView ()
{
    CGFloat _vy_margins;
    CGFloat _vy_padding;
}

@property (nonatomic, strong) UIActivityIndicatorView *vy_activityIndicatorView;
@property (nonatomic, strong) UIImageView *vy_imageView;
@property (nonatomic, strong) UILabel *vy_titleLabel;
@property (nonatomic, strong) UILabel *vy_messageLabel;

- (void)vy_initialSetup;
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
    CGRect constraintRect = CGRectInset(self.bounds, self.margins, self.margins);
    CGFloat constraintWidth = CGRectGetWidth(constraintRect);
    CGFloat constraintHeight = CGRectGetHeight(constraintRect);
    
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
                CGSize titleLabelSize = [self.vy_titleLabel.text vy_sizeWithFont:self.vy_titleLabel.font constrainedToSize:constraintRect.size];
                
                self.vy_titleLabel.frame = CGRectMake(0.0, 0.0, titleLabelSize.width, titleLabelSize.height);
                
                [subviews addObject:self.vy_titleLabel];
            }
            
            if (self.vy_messageLabel.superview != nil)
            {
                // Set message label bounds.
                CGSize messageLabelSize = [self.vy_messageLabel.text vy_sizeWithFont:self.vy_messageLabel.font constrainedToSize:constraintRect.size];
                
                self.vy_messageLabel.frame = CGRectMake(0.0, 0.0, messageLabelSize.width, messageLabelSize.height);
                
                [subviews addObject:self.vy_messageLabel];
            }
            
            // Align subviews.
            [self vy_alignSubviewsVerticaly:subviews usingPadding:self.padding];
            
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
                CGFloat width = constraintWidth - CGRectGetWidth(self.vy_activityIndicatorView.bounds) - self.padding;
                CGSize titleLabelSize = [self.vy_titleLabel.text vy_sizeWithFont:self.vy_titleLabel.font
                    forWidth:width lineBreakMode:self.vy_titleLabel.lineBreakMode];
                
                self.vy_titleLabel.frame = CGRectMake(0.0, 0.0, titleLabelSize.width, titleLabelSize.height);
                
                [subviews addObject:self.vy_titleLabel];
            }
            else if (self.vy_messageLabel.superview != nil)
            {
                // Set message label bounds.
                CGFloat width = constraintWidth - CGRectGetWidth(self.vy_activityIndicatorView.bounds) - self.padding;
                CGSize messageLabelSize = [self.vy_messageLabel.text vy_sizeWithFont:self.vy_messageLabel.font
                    forWidth:width lineBreakMode:self.vy_messageLabel.lineBreakMode];
                
                self.vy_messageLabel.frame = CGRectMake(0.0, 0.0, messageLabelSize.width, messageLabelSize.height);
                
                [subviews addObject:self.vy_messageLabel];
            }
            
            // Align subviews.
            [self vy_alignSubviewsHorizontaly:subviews usingPadding:self.padding / 2.0];
            
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
                self.vy_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                self.vy_activityIndicatorView.hidesWhenStopped = NO;
                self.vy_activityIndicatorView.color = _textColor;
                
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

- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        _image = image;
        
        if (_image != nil)
        {
            if (self.vy_imageView == nil)
            {
                self.vy_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                self.vy_imageView.backgroundColor = [UIColor clearColor];
                self.vy_imageView.opaque = NO;
                self.vy_imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                [self addSubview:self.vy_imageView];
            }
            
            self.vy_imageView.image = _image;
        }
        else if (self.vy_imageView.superview != nil)
        {
            [self.vy_imageView removeFromSuperview];
            self.vy_imageView = nil;
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
            if (self.vy_titleLabel == nil)
            {
                self.vy_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                self.vy_titleLabel.backgroundColor = [UIColor clearColor];
                self.vy_titleLabel.opaque = NO;
                self.vy_titleLabel.font = self.titleFont;
                self.vy_titleLabel.textColor = self.textColor;
                self.vy_titleLabel.shadowColor = self.textShadowColor;
                self.vy_titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
                self.vy_titleLabel.textAlignment = NSTextAlignmentCenter;
                self.vy_titleLabel.numberOfLines = 0;
                self.vy_titleLabel.adjustsFontSizeToFitWidth = NO;
                
                [self addSubview:self.vy_titleLabel];
            }
            
            self.vy_titleLabel.text = _title;
        }
        else if (self.vy_titleLabel.superview != nil)
        {
            [self.vy_titleLabel removeFromSuperview];
            self.vy_titleLabel = nil;
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
            if (self.vy_messageLabel == nil)
            {
                self.vy_messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                self.vy_messageLabel.backgroundColor = [UIColor clearColor];
                self.vy_messageLabel.opaque = NO;
                self.vy_messageLabel.font = self.messageFont;
                self.vy_messageLabel.textColor = self.textColor;
                self.vy_messageLabel.shadowColor = self.textShadowColor;
                self.vy_messageLabel.shadowOffset = CGSizeMake(0.0, -1.0);
                self.vy_messageLabel.textAlignment = NSTextAlignmentCenter;
                self.vy_messageLabel.numberOfLines = 0;
                self.vy_messageLabel.adjustsFontSizeToFitWidth = NO;
                
                [self addSubview:self.vy_messageLabel];
            }
            
            self.vy_messageLabel.text = _message;
        }
        else if (self.vy_messageLabel.superview != nil)
        {
            [self.vy_messageLabel removeFromSuperview];
            self.vy_messageLabel = nil;
        }
        
        [self setNeedsLayout];
    }
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont != titleFont)
    {
        _titleFont = titleFont != nil ? titleFont : [UIFont boldSystemFontOfSize:kVYStateViewTitleLabelFontSize];
        
        self.vy_titleLabel.font = _titleFont;
    }
}

- (void)setMessageFont:(UIFont *)messageFont
{
    if (_messageFont != messageFont)
    {
        _messageFont = messageFont != nil ? messageFont : [UIFont boldSystemFontOfSize:kVYStateViewMessageLabelFontSize];
        
        self.vy_messageLabel.font = _messageFont;
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
#pragma mark Private Methods

- (void)vy_initialSetup
{
    // Set up view.
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    // Set default values.
    _titleFont = [UIFont boldSystemFontOfSize:kVYStateViewTitleLabelFontSize];
    _messageFont = floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1
        ? [UIFont boldSystemFontOfSize:kVYStateViewMessageLabelFontSize]
        : [UIFont systemFontOfSize:kVYStateViewMessageLabelFontSize];
    
    _textColor = [UIColor whiteColor];
    _textShadowColor = [UIColor blackColor];
    
    _vy_margins = kVYStateViewMargin;
    _vy_padding = kVYStateViewPadding;
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

- (CGFloat)padding
{
    return _vy_padding;
}

- (void)setPadding:(CGFloat)padding
{
    if (_vy_padding != padding)
    {
        _vy_padding = padding;
        
        [self setNeedsLayout];
    }
}

@end

// ********************************************************************************************************************************************************** //

#pragma mark -
#pragma mark NSString Extensions

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
