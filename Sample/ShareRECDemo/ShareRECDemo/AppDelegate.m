//
//  AppDelegate.m
//  ShareRECDemo
//
//  Created by 冯 鸿杰 on 14-12-18.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareRECSocial/ShareRECSocial+Ext.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    [ShareREC setSyncAudioComment:YES];
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {

        [platformsRegister setupWeChatWithAppId:@"wx4868b35061f87885" appSecret:@"64020361b8ec4c99936c0e3999a9f249"];

        [platformsRegister setupSinaWeiboWithAppkey:@"568898243" appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3" redirectUrl:@"http://www.sharesdk.cn"];

        [platformsRegister setupQQWithAppId:@"100371282" appkey:@"aed9b0303e3ed1e27bae87c33761161d"];

    }];
//
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    //设置必须上传完成后才可进行分享
    [ShareRECSocial setShareAfterUploadCompleted:YES];

    return YES;
}


@end
