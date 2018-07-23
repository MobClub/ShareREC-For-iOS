//
//  ShareREC+RecordingEdit.h
//  ShareREC
//
//  Created by liyc on 15/8/26.
//  Copyright (c) 2015年 掌淘科技. All rights reserved.
//

#import "ShareREC.h"
#import "SRERecording.h"

@interface ShareREC (RecordingEdit)

/**
*  @breif 剪辑视频
*
*  @param recording 视频对象
*  @param startTime 开始时间
*  @param endTime   结束时间
*  @param handler   返回事件处理
*/
+ (BOOL)trimRecording:(SRERecording *)recording
            startTime:(NSTimeInterval)startTime
              endTime:(NSTimeInterval)endTime
               result:(NSError *)error;

/**
 *  @breif 确认剪辑/合并
 *
 *  @param recording 视频对象
 *  @param handler   返回事件处理 (mainVideoPath 未录制麦克风时，表示视频路径；录制麦克风时，表示合并后路径 commentPath:麦克风路径)
 */
+ (void)confirmEditRecording:(SRERecording *)recording result:(void (^)(NSString *mainVideoPath, NSString *commentPath))handler;


@end
