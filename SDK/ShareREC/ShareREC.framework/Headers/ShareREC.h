//
//  ShareRec.h
//  ShareRec
//
//  Created by vimfung on 14-11-13.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SRERecording.h"

/**
 *  游戏录像SDK
 */
@interface ShareREC : NSObject

/**
 *	@brief	开始录制视频
 */
+ (void)startRecording;

/**
 *	@brief	结束录制视频
 *
 *  @param  finishedHandler 完成事件处理
 */
+ (void)stopRecording:(void(^)(NSError *error))finishedHandler;

/**
 *  暂停录像
 */
+ (void)pauseRecording;

/**
 *  恢复录像
 */
+ (void)resumeRecording;

/**
 *	@brief	播放最后录制的视频
 */
+ (void)playLastRecording;

/**
 *  播放指定的录制视频
 *
 *  @param recording 指定的视频对象
 */
+ (void)playRecording:(SRERecording *)recording;

/**
 *  编辑最后录制的视频
 *
 *  @param title        标题
 *  @param userData     用户数据
 *  @param closeHandler 关闭事件
 */
+ (void)editLastRecordingWithTitle:(NSString *)title
                          userData:(NSDictionary *)userData
                           onClose:(void(^)())closeHandler DEPRECATED_MSG_ATTRIBUTE("use -[editLastRecording:] method instead.");


/**
 *  编辑最后录制的视频
 *
 *  @param block 返回回调
 *
 *  @return YES 表示成功进入编辑界面，NO 表示不能编辑
 */
+ (BOOL)editLastRecording:(void(^)(BOOL cancelled))block;

@end
