//
//  SLCheckVersion.m
//  SLCheckVersion
//
//  Created by shuanglong on 16/12/8.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import "SLCheckVersion.h"

@interface SLCheckVersion ()

@property(nonatomic,copy)void(^resultBlock)(BOOL hasNewVersion , NSString * version,NSDictionary*appInfo);

@end

@implementation SLCheckVersion


#pragma -mark ---------initialization----------------

+(SLCheckVersion *)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}

-(instancetype)init{
    if (self = [super init]) {
        self.countryCode = @"cn";
    }
    return self;
}





-(NSString *)currentVersion{
    NSString * currentVersion = nil;
    currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return currentVersion;
}


-(void)checkVersion:(void(^)(BOOL hasNewVersion,NSString*version,NSDictionary*appInfo))resultBlock{
    
    self.resultBlock = [resultBlock copy];
    [self performVersionCheck];
    
}


-(void)performVersionCheck{
    
    NSURL *  itunesUrl = [self url];
    NSURLRequest * request = [NSURLRequest requestWithURL:itunesUrl];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data) {
            if (self.resultBlock) {
                self.resultBlock(NO,nil,nil);
            }
        }
        else {
            NSDictionary * appInfo =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSString * version = [appInfo[@"results"]lastObject][@"version"];
            
            
            NSString * appID = appInfo[@"results"][0][@"trackId"];
            self.appStoreUrl = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",appID];
            
            
            BOOL appStoreVersionNewer = [self isAppStoreVersionNewer:version];
            if (appStoreVersionNewer) {
                if (self.resultBlock) {
                    self.resultBlock(YES,version,appInfo);
                }
            }
            else{
                if (self.resultBlock) {
                    self.resultBlock(NO,nil,appInfo);
                }

            }
            
        }
    }];
    
    [task resume];
}


-(NSURL*)url{
    NSURLComponents * components = [NSURLComponents new];
    components.scheme = @"https";
    components.host = @"itunes.apple.com";
    components.path = @"/lookup";
    
    NSMutableArray<NSURLQueryItem*>*items = [NSMutableArray array];
    NSURLQueryItem * bundleIDItem = [NSURLQueryItem queryItemWithName:@"bundleId" value:[self bundleID]];
    [items addObject:bundleIDItem];
    
    if ([self countryCode]) {
        NSURLQueryItem *countryQueryItem = [NSURLQueryItem queryItemWithName:@"country" value:_countryCode];
        [items addObject:countryQueryItem];
    }
    
    components.queryItems = items;
    return components.URL;
    
}


#pragma -mark -----------helper--------
- (NSString *)bundleID {
    NSString * bundleID = [NSBundle mainBundle].bundleIdentifier;
    return bundleID;
}



-(BOOL)isAppStoreVersionNewer:(NSString*)appStoreVersion{

    if ([[self currentVersion] compare:appStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
        return true;
    } else {
        return false;
    }
}


@end
