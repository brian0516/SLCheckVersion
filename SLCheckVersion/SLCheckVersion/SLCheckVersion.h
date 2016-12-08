//
//  SLCheckVersion.h
//  SLCheckVersion
//
//  Created by shuanglong on 16/12/8.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLCheckVersion : NSObject

@property(nonatomic,readonly)NSString * currentVersion;

/**
 appStoreUrl
 */
@property(nonatomic,strong)NSString * appStoreUrl;

/**
 国别,设置两位字母的国别代码,默认国别为中国cn;
 */
@property(nonatomic,strong)NSString * countryCode;

/**
 单例
 */
+(SLCheckVersion*)sharedInstance;



/**
 检查新版本
 */
-(void)checkVersion:(void(^)(BOOL hasNewVersion,NSString*version,NSDictionary*appInfo))resultBlock;


@end
