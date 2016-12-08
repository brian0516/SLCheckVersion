//
//  SLCheckVersionView.h
//  SLCheckVersion
//
//  Created by shuanglong on 16/12/8.
//  Copyright © 2016年 shuanglong. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "SLCheckVersion.h"


@interface SLCheckVersionManager : NSObject

/**
 国别
 */
@property(nonatomic,strong)NSString * countryCode;

/**
 两次检测的时间间隔,默认为1,每天检查一次
 */
@property(nonatomic)NSInteger intervalDays;

+(SLCheckVersionManager*)defaultManager;


-(void)checkVersion;

@end
