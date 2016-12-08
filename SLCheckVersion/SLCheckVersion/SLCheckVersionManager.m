//
//  SLCheckVersionView.m
//  SLCheckVersion
//
//  Created by shuanglong on 16/12/8.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import "SLCheckVersionManager.h"
#import "XIAlertView.h"

static NSString * const KLastVersionCheckDate = @"lastVersionCheckDate";

@interface SLCheckVersionManager ()

@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * version;
@property(nonatomic,strong)NSString * updateContent;//变更的内容;
@property (nonatomic,strong)XIAlertView * alertView;
@property (nonatomic,strong)NSDate * lastCheckDate;

@end

@implementation SLCheckVersionManager


+(SLCheckVersionManager *)defaultManager{
    static id defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[self alloc]init];
    });
    return defaultManager;
}



-(instancetype)init{
    if (self = [super init]) {
        self.lastCheckDate = [[NSUserDefaults standardUserDefaults]objectForKey:KLastVersionCheckDate];
        self.intervalDays = 1;
    }
    return self;
}

-(void)setCountryCode:(NSString *)countryCode{
    _countryCode = countryCode;
    [SLCheckVersion sharedInstance].countryCode = countryCode;
}

-(void)checkVersion{
    
    if (![self compareDate]) {
        return;
    }
    
    
    [[SLCheckVersion sharedInstance]checkVersion:^(BOOL hasNewVersion, NSString *version, NSDictionary *appInfo) {
        if (hasNewVersion) {
            self.version = version;
            self.updateContent = [appInfo[@"results"] lastObject][@"releaseNotes"];
            [self showNewVersionInfo];
        }
    }];

}


-(void)showNewVersionInfo{
    [self.alertView show];
}


-(BOOL)compareDate{
    
    if (!self.lastCheckDate) {
        return YES;
    }
    
    if ([self numberOfDaysBetweenLastVersionCheckDate]>=self.intervalDays) {
        return YES;
    }
    
    return NO;
}


-(NSUInteger)numberOfDaysBetweenLastVersionCheckDate{

    NSCalendar * currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [currentCalendar components:NSCalendarUnitDay fromDate:self.lastCheckDate toDate:[NSDate date] options:0];
    return components.day;
}

-(XIAlertView *)alertView{
    if (!_alertView) {
        
        __block SLCheckVersionManager * weakSelf = self;
        
        NSString * titleString = [NSString stringWithFormat:@"%@%@",@"新版本",weakSelf.version];
        _alertView = [[XIAlertView alloc]initWithTitle:titleString message:self.updateContent cancelButtonTitle:nil];
        [_alertView addDefaultStyleButtonWithTitle:@"下次提醒" handler:^(XIAlertView *alertView, XIAlertButtonItem *buttonItem) {
            [alertView dismiss];
            [weakSelf noticeNextTime];
        }];
        [_alertView addButtonWithTitle:@"立即升级" style:XIAlertActionStyleDestructive handler:^(XIAlertView *alertView, XIAlertButtonItem *buttonItem) {
            [alertView dismiss];
            [weakSelf updateImmediately];
        }];
    }
    return _alertView;
}


-(void)noticeNextTime{
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:KLastVersionCheckDate];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


-(void)updateImmediately{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KLastVersionCheckDate];
    [[NSUserDefaults standardUserDefaults]synchronize];

    NSString * iTunesString = [SLCheckVersion sharedInstance].appStoreUrl;
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[UIApplication sharedApplication]openURL:iTunesURL options:@{} completionHandler:nil];
        
    });
    
}
@end
