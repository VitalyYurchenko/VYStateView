//
//  VYStateViewController.m
//  State
//
//  Created by Vitaly Yurchenko on 13.04.12.
//  Copyright (c) 2012 Vitaly Yurchenko. All rights reserved.
//

#import "VYStateViewController.h"

#import "VYStateView.h"

// ********************************************************************************************************************************************************** //

@implementation VYStateViewController

@synthesize stateView = _stateView;

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self toggleStateViewModeAction:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.stateView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
            self.stateView.textColor = [UIColor redColor];
            self.stateView.title = @"Loading...";
            
            break;
        }
        case VYStateViewModeActivity:
        {
            self.stateView.mode = VYStateViewModeStatic;
            self.stateView.title = @"Title";
            self.stateView.message = @"Message.";
            
            break;
        }
        default:
            break;
    }
}

@end
