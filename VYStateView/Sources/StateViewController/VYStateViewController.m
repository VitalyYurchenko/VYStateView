//
//  VYStateViewController.m
//  VYStateView
//
//  Created by Vitaly Yurchenko on 13.04.12.
//  Copyright (c) 2012 Vitaly Yurchenko. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "VYStateViewController.h"

#import "VYStateView.h"

// ********************************************************************************************************************************************************** //

@implementation VYStateViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self toggleStateViewModeAction:self];
}

#pragma mark -
#pragma mark Actions

- (IBAction)toggleStateViewModeAction:(id)sender
{
    if (self.stateView == nil)
    {
        return;
    }
    
    switch (self.stateView.mode)
    {
        case VYStateViewModeStatic:
        {
            self.stateView.mode = VYStateViewModeActivity;
            self.stateView.messageFont = nil;
            self.stateView.image = nil;
            self.stateView.attributedTitle = nil;
            self.stateView.attributedMessage = [[NSAttributedString alloc] initWithString:@"Loading…"];
            self.stateView.textColor = [UIColor vy_darkGrayColor];
            
            break;
        }
        case VYStateViewModeActivity:
        {
            self.stateView.mode = VYStateViewModeStatic;
            self.stateView.messageFont = nil;
            self.stateView.image = [UIImage imageNamed:@"STAR"];
            self.stateView.attributedTitle = [[NSAttributedString alloc] initWithString:@"No Stars"];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 2.0;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary *attributes = @{NSFontAttributeName: self.stateView.messageFont, NSParagraphStyleAttributeName: paragraphStyle};
            
            self.stateView.attributedMessage = [[NSAttributedString alloc] initWithString:@"Stars let you build as many your own galaxies as possible."
                attributes:attributes];
            self.stateView.textColor = [UIColor vy_lightGrayColor];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark <UIBarPositioningDelegate>

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
