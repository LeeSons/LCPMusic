//
//  LyricManager.h
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject
@property(nonatomic, strong)NSArray *allLyric; // 对外歌词数组

+ (instancetype)sharedManager;
// 加载歌词
- (void)loadLyricWith:(NSString *)lyricStr;
/**
 *  根据播放时间获取到应该显示的歌词索引
 *
 *  @param time 播放时间
 *
 *  @return 歌词索引
 */
- (NSInteger)indexWith:(NSTimeInterval)time;
@end
