//
//  VYStateViewTests.m
//  VYStateViewTests
//
//  Created by Vitaly Yurchenko on 13.04.12.
//  Copyright (c) 2012 Vitaly Yurchenko. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import <XCTest/XCTest.h>

#import "VYStateView.h"

// ********************************************************************************************************************************************************** //

@interface VYStateViewTests : XCTestCase

@property (nonatomic, strong) VYStateView *stateView;

@end

// ********************************************************************************************************************************************************** //

@implementation VYStateViewTests

- (void)setUp
{
    [super setUp];
    
    self.stateView = [[VYStateView alloc] initWithFrame:CGRectZero];
    XCTAssertNotNil(self.stateView, @"Cannot create VYStateView instance");
}

- (void)tearDown
{
    [super tearDown];
    
    self.stateView = nil;
}

#pragma mark -
#pragma mark Tests

- (void)testDefaultValues
{
    XCTAssertEqual(self.stateView.mode, VYStateViewModeStatic, @"");
    XCTAssertEqualObjects(self.stateView.textColor, [UIColor blackColor], @"");
    XCTAssertNil(self.stateView.textShadowColor, @"");
}

- (void)testTexts
{
    NSString *title = @"title";
    NSString *message = @"message";
    
    self.stateView.title = title;
    self.stateView.message = message;
    
    XCTAssertEqualObjects(self.stateView.title, self.stateView.attributedTitle.string, @"");
    XCTAssertEqualObjects(self.stateView.message, self.stateView.attributedMessage.string, @"");
    
    self.stateView.title = nil;
    self.stateView.message = nil;
    self.stateView.attributedTitle = [[NSAttributedString alloc] initWithString:title];
    self.stateView.attributedMessage = [[NSAttributedString alloc] initWithString:message];
    
    XCTAssertEqualObjects(self.stateView.title, self.stateView.attributedTitle.string, @"");
    XCTAssertEqualObjects(self.stateView.message, self.stateView.attributedMessage.string, @"");
}

- (void)testFonts
{
    // Test fonts after reset.
    XCTAssertNotNil(self.stateView.titleFont, @"");
    XCTAssertNotNil(self.stateView.messageFont, @"");
    
    self.stateView.titleFont = nil;
    self.stateView.messageFont = nil;
    
    XCTAssertNotNil(self.stateView.titleFont, @"");
    XCTAssertNotNil(self.stateView.messageFont, @"");
    
    // Test fonts after mode change.
    UIFont *titleFont = self.stateView.titleFont;
    UIFont *messageFont = self.stateView.messageFont;
    
    switch (self.stateView.mode)
    {
        case VYStateViewModeStatic:
        {
            self.stateView.mode = VYStateViewModeActivity;
            break;
        }
        case VYStateViewModeActivity:
        {
            self.stateView.mode = VYStateViewModeStatic;
            break;
        }
        default:
            break;
    }
    
    XCTAssertEqualObjects(self.stateView.titleFont, titleFont, @"");
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        XCTAssertEqualObjects(self.stateView.messageFont, messageFont, @"");
    }
    else
    {
        XCTAssertNotEqualObjects(self.stateView.messageFont, messageFont, @"");
    }
}

- (void)testColors
{
    XCTAssertNotNil(self.stateView.textColor, @"");
    XCTAssertNil(self.stateView.textShadowColor, @"");
}

@end
