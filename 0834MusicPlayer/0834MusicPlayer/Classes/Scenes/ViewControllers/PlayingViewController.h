//
//  PlayingViewController.h
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController

// 要播放第几首歌曲
@property(nonatomic, assign) NSInteger  playIndex;

+ (instancetype)sharedPlayingPVC;

@end
