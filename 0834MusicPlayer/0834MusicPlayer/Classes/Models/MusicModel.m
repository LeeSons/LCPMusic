//
//  MusicModel.m
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

// 容错处理
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    int i = 0;
    if ([key isEqualToString:@"id"]) {
        _ID = value;
        i = 1;
    }
    // 以防万一 便于调试
    if (i == 0) {
        NSLog(@"error key : %@ --- 未处理",key);
    }else{
        NSLog(@"error key : %@ --- 已处理",key);
    }
    
}

@end
