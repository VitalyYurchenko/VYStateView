//
//  VYStateViewController.h
//  State
//
//  Created by Vitaly Yurchenko on 13.04.12.
//  Copyright (c) 2012 Vitaly Yurchenko. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import <UIKit/UIKit.h>

// ********************************************************************************************************************************************************** //

@class VYStateView;

// ********************************************************************************************************************************************************** //

@interface VYStateViewController : UIViewController

@property (nonatomic, strong) IBOutlet VYStateView *stateView;

- (IBAction)toggleStateViewModeAction:(id)sender;

@end
