//
//  SLCheckVersionTests.m
//  SLCheckVersionTests
//
//  Created by shuanglong on 16/12/8.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLCheckVersion.h"


@interface SLCheckVersionTests : XCTestCase

@end

@implementation SLCheckVersionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    [[SLCheckVersion sharedInstance] checkVersion];
    
}




-(void)testCurrentVersion{
    NSString * currentVersion = [SLCheckVersion sharedInstance].currentVersion;
    NSLog(@"+++++currentVersion++++ = %@",currentVersion);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
