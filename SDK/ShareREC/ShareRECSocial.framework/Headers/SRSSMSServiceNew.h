//
//  SRSSMSServiceNew.h
//  ShareRECSocial
//
//  Created by liyc on 16/1/12.
//  Copyright © 2016年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 获取token信息回调
 *  @param error 当error为空时表示成功
 */
typedef void (^GetTokenResultHandler)(NSString *token,NSError *error);
typedef void (^GetDuidOrTokenResultHandler)(NSString *duid,NSString *token,NSError *error);
typedef void (^InitSDKResultHandler)(NSDictionary *initData,NSError *error);

static NSString *const InitSDK = @"initSDK";
static NSString *const GetZoneList = @"getZoneList";
static NSString *const GetToken = @"getToken";
static NSString *const SubmitUser = @"submitUser";
static NSString *const UploadContacts = @"uploadContacts";
static NSString *const GetFriend = @"getFriend";
static NSString *const LogInstall = @"logInstall";
static NSString *const SendTextSMS = @"sendTextSMS";
static NSString *const SendVoiceSMS = @"sendVoiceSMS";
static NSString *const VerifyCode = @"verifyCode";

@interface SRSSMSServiceNew : NSObject

/**
 *  应用标识
 */
@property (nonatomic, readonly) NSString *appKey;

/**
 *  应用密钥
 */
@property (nonatomic, readonly) NSString *appSecret;

@property (nonatomic, copy) NSString *duid;

/**
 *  返回SMS操作对象
 *
 *  @return 对象单例
 */
+ (SRSSMSServiceNew *)sharedInstance;

/**
 *  获取支持短信的国家列表
 *
 *  @param handler 处理器
 */
- (void)getZoneList:(void(^)(NSArray *zoneList, NSError *error))handler;

/**
 *  @brief                   获取验证码(Get verification code)
 *
 *  @param method            获取验证码的方法(The method of getting verificationCode)
 *  @param phoneNumber       电话号码(The phone number)
 *  @param zone              区域号，不需要加"+"号(Area code)
 *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
 *  @param result            请求结果回调(Results of the request)
 */
-(void)getVerificationCodeWithPhoneNumber:(NSString *)phoneNumber
                                     zone:(NSString *)zone
                         customIdentifier:(NSString *)customIdentifier
                                   result:(void (^)(NSError *error))result;

/**
 * @brief              提交验证码(Commit the verification code)
 *
 * @param code         验证码(Verification code)
 * @param phoneNumber  电话号码(The phone number)
 * @param zone         区域号，不要加"+"号(Area code)
 * @param result       请求结果回调(Results of the request)
 */
-(void)commitVerificationCode:(NSString *)code
                  phoneNumber:(NSString *)phoneNumber
                         zone:(NSString *)zone
                       result:(void (^)(NSError *error))result;

/**
 *  上传通讯录
 *
 *  @param handler 返回结果回调
 */
- (void)uploadContacts:(void(^)(NSError *error))handler;

/**
 *  提交用户信息
 *
 *  @param uid      用户标识
 *  @param nickname 用户昵称
 *  @param avatar   用户头像
 *  @param phone    手机号码
 *  @param zone     区号
 *  @param handler  返回结果回调
 */
- (void)submitUserInfoWithUid:(NSString *)uid
                     nickname:(NSString *)nickname
                       avatar:(NSString *)avatar
                        phone:(NSString *)phone
                         zone:(NSString *)zone
                       result:(void(^)(NSError *error))handler;

@end
