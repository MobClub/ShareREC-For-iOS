//
//  SRERecording.h
//  ShareRec
//
//  Created by vimfung on 14-11-21.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareRECTypeDef.h"

/**
 *  录像信息
 */
@interface SRERecording : NSObject <NSCoding>

/**
 *  创建时间
 */
@property (nonatomic, readonly) CFAbsoluteTime createTime;

/**
 *  视频时长
 */
@property (nonatomic, readonly) CFAbsoluteTime duration;

/**
 *  视频路径
 */
@property (nonatomic, copy, readonly) NSString *path;

/**
 *  视频尺寸
 */
@property (nonatomic, readonly) CGSize videoSize;

/**
 *  解说路径
 */
@property (nonatomic, copy, readonly) NSString *commentPath;

/**
 *  解说类型
 */
@property (nonatomic, readonly) SREVideoCommentType commentType;

/**
 *  与音频解说混合后的视频路径
 */
@property (nonatomic, copy, readonly) NSString *mergeAudioVideoPath;


@end
