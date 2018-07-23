//
//  ShareREC+Ext.h
//  ShareREC
//
//  Created by 冯 鸿杰 on 15/3/20.
//  Copyright (c) 2015年 掌淘科技. All rights reserved.
//

#import "ShareREC.h"

/**
 *  ShareREC 扩展接口
 */
@interface ShareREC (Ext)

/**
 *  设置码率（单位bps），默认为2Mbps = 2 * 1024 * 1024
 *
 *  @param bitRate 码率
 */
+ (void)setBitRate:(NSInteger)bitRate;

/**
 *  设置帧率，默认为30fps
 *
 *  @param fps 帧率
 */
+ (void)setFPS:(NSInteger)fps;

/**
 *  设置最短的视频录制时间，如果小于这个时间在调用stopRecording方法时会录制失败，默认为4秒
 *
 *  @param  time   时间（单位：秒）
 */
+ (void)setMinimumRecordingTime:(NSTimeInterval)time;

/**
 *  获取最后录制视频路径
 *
 *  @return 视频路径
 */
+ (NSString *)lastRecordingPath;

/**
 *	@brief	同步音频解说, 在录制过程中是否同步录制麦克风声音。默认为NO
 *
 *	@param 	syncAudioComment 	YES 表示录制视频同时录入麦克风声音，NO 表示录制视频时不录入麦克风声音
 */
+ (void)setSyncAudioComment:(BOOL)syncAudioComment;

@end
