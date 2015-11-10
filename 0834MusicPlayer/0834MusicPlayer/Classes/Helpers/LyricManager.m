//
//  LyricManager.m
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"

@interface LyricManager ()
// 用来存放歌词
@property(nonatomic, strong) NSMutableArray *lyrics;

@end


@implementation LyricManager
static LyricManager *manager = nil;

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LyricManager new];
    });
    return manager;
}
// 歌词长这样：
//[00:00.00] 作曲 : Wiz Khalifa
//[00:01.00] 作词 : Wiz Khalifa
//[00:10.440]It's been a long day without you my friend
//[00:17.400]And I'll tell you all about it when I see you again
//[00:23.200]We've come a long way from where we began
//[00:29.080]Oh I'll tell you all about it when I see you again
//[00:35.100]When I see you again
//[00:39.920]Damn who knew all the planes we flew
//[00:42.900]Good things we've been through
//[00:44.610]That I'll be standing right here
//[00:46.330]Talking to you about another path
//[00:48.750]I know we loved to hit the road and laugh
- (void)loadLyricWith:(NSString *)lyricStr{
    // 先将之前的歌词移除
    [self.lyrics removeAllObjects];
    if ([lyricStr isEqualToString:@""]) {
        LyricModel *model = [[LyricModel alloc] initWithTime:0 Lyric:@"暂时没有歌词"];
        [self.lyrics addObject:model];
    }else{
        // 1分行
        NSMutableArray *lyricStringArray = [[lyricStr componentsSeparatedByString:@"\n"] mutableCopy];
        // 移除最后一行空行
        [lyricStringArray removeLastObject];
        for (NSString *str in lyricStringArray) {
            // 2.分开时间和歌词
            NSMutableArray *timeAndLyric = [[str componentsSeparatedByString:@"]"] mutableCopy];
            if (timeAndLyric.count < 2) {
                [timeAndLyric insertObject:@"[00:00.000" atIndex:0];
            }
            // 3.去掉时间左侧的括号“[”
            NSString *time = [timeAndLyric[0] substringFromIndex:1];
            // 4.截取时间获取分和秒
            NSArray *minuteAndSecond = [time componentsSeparatedByString:@":"];
            // 分
            NSInteger minute = [minuteAndSecond[0] integerValue];
            // 秒
            double second = [minuteAndSecond[1] doubleValue];
            // 装成model
            LyricModel *model = [[LyricModel alloc] initWithTime:(minute * 60 + second) Lyric:timeAndLyric[1]];
            // 添加到数组
            [self.lyrics addObject:model];
        }
    }
}

- (NSInteger)indexWith:(NSTimeInterval)time{
    NSInteger index = 0;
    // 遍历数组，找到还没播放的那句歌词
    for (int i = 0; i < self.lyrics.count; i++) {
        LyricModel *model = self.lyrics[i];
        if (model.time > time) {
            // 注意如果是第0个元素，而且元素时间要比播放的时间大，i - 1就会小于0，这样tableView就会崩
            index = (i - 1 > 0)?i - 1 : 0;
            break;
        }
        index = i;
    }
    return index;
}

- (NSMutableArray *)lyrics{
    if (!_lyrics) {
        _lyrics = [NSMutableArray new];
    }
    return _lyrics;
}

- (NSArray *)allLyric{
    return self.lyrics;
}

@end
