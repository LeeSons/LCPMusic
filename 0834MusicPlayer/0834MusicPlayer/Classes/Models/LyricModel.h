//
//  LyricModel.h
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject
@property(nonatomic, assign) NSTimeInterval time; // 歌词播放时间
@property(nonatomic, strong) NSString * lyricContext; // 歌词内容

- (instancetype)initWithTime:(NSTimeInterval)time
                       Lyric:(NSString *)lyric;
@end
