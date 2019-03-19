//
//  ShareRECCloud.h
//  ShareRECCloud
//
//  Created by liyc on 2017/7/14.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SRCDidCompleteUploadRecordNotification;

@class SRERecording;

@interface ShareRECCloud : NSObject

+ (void)shareWithTitle:(NSString *)title Recording:(SRERecording *)recording result:(void (^)())result;

@end
