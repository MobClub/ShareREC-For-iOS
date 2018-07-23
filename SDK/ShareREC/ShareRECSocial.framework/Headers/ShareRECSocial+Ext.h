//
//  ShareRECSocial+Ext.h
//  ShareRECSocial
//
//  Created by liyc on 2016/11/30.
//  Copyright © 2016年 掌淘科技. All rights reserved.
//

#import <ShareRECSocial/ShareRECSocial.h>

@interface ShareRECSocial (Ext)

/**
 增加自定义分享平台

 @param platformName 平台名称
 @param handler 回调信息
 */
+ (void)addCustomPlatform:(NSString *)platformName
                  handler:(void (^)(NSString *platformName, NSString *title, NSDictionary *recording))handler;


/**
 *  第三方账号绑定
 *
 *  @param uid 用户id
 *  @param userName 用户名
 *  @param avatarURL 用户头像地址
 *  @param handler  回调信息
 */
+ (void)accountBindWithUid:(NSString *)uid
                  userName:(NSString *)userName
                  imageURL:(NSString *)avatarURL
                   handler:(void (^)(NSError *error))handler;

/**
 屏蔽SNS分享的平台

 @param platforms 屏蔽平台数组
 */
+ (void)setWontBeBindPlatforms:(NSArray *)platforms;

/**
 设置是否显示绑定手机

 @param show 是否社区内是否显示绑定手机操作
 */
+ (void)setShowBindPhone:(BOOL)show;

/**
 设置是否强制上传完再进行分享

 @param state 是否强制上传完再进行分享
 */
+ (void)setShareAfterUploadCompleted:(BOOL)shareAfterUploadCompleted;


@end
