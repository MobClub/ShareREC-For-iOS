//
//  ShareREC+RecordingManager.h
//  ShareREC
//
//  Created by liyc on 15/8/11.
//  Copyright (c) 2015年 掌淘科技. All rights reserved.
//

#import "ShareREC.h"
#import "SRERecording.h"

/**
 *  ShareREC 文件管理扩展
 */
@interface ShareREC (RecordingManager)

/**
 *  获取本地录像视频信息列表
 *
 *  @return 路线信息列表
 */
+ (NSArray *)currentLocalRecordings;

/**
 *  清除所有本地视频
 */
+ (void)clearLocalRecordings;

/**
 *  删除录制视频
 *
 *  @param recording 录像信息
 */
+ (void)deleteLocalRecording:(SRERecording *)recording;

/**
 打开本地视频管理界面
 */
+ (void)openLocalRecordingWindow;

@end
