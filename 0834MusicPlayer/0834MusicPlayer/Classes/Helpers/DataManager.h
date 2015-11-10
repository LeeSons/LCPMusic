//
//  DataManager.h
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

typedef void (^UpdateUI)(void);

@interface DataManager : NSObject
@property (nonatomic,strong) NSArray * allMusic;
@property (nonatomic, copy) UpdateUI  callBack;


/**
 *  创建单例
 *
 *  @return
 */
+ (DataManager *)sharedManager;

/**
 *  根据cell的索引返回一个model
 *
 *  @param index 索引值
 *
 *  @return model
 */
- (MusicModel *)musicModelWithIndex:(NSInteger)index;

@end
