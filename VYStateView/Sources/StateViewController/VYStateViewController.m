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
            self.stateView.textShadowColor = [UIColor clearColor];
            self.stateView.message = @"Loading…";
            
            break;
        }
        case VYStateViewModeActivity:
        {
            self.stateView.mode = VYStateViewModeStatic;
            self.stateView.textShadowColor = [UIColor blackColor];
            self.stateView.image = [UIImage imageNamed:@"STAR"];
            self.stateView.title = @"Network Error";
            self.stateView.message = @"Please check your network connection and try again later.";
            
            break;
        }
        default:
            break;
    }
}

@end
