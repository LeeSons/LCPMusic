//
//  DataManager.m
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import "DataManager.h"
#import "MusicModel.h"

@interface DataManager ()

@property(nonatomic ,retain) NSMutableArray *dataArray;

@end

@implementation DataManager

// command + control + ⬆️ / ⬇️切换.h .m
static DataManager *manager = nil;
+ (DataManager *)sharedManager{
    // GCD提供的一种创建单例的方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self requestData];
    }
    return self;
}

- (void)requestData{
    // 子线程中请求数据，防止页面假死
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 数据连接
        NSURL *url = [NSURL URLWithString:MUSICLIST_URL];
        // 请求数据
        NSArray *dataArray = [NSArray arrayWithContentsOfURL:url];
        for (int i = 0; i < dataArray.count; i++) {
            // 构建model
            MusicModel *model = [MusicModel new];
            [model setValuesForKeysWithDictionary:dataArray[i]];
            [self.dataArray addObject:model];
        }
        // 返回主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.callBack) {
                NSLog(@"block 没实现");
            }else{
                self.callBack();
            }
        });
    });
}

- (MusicModel *)musicModelWithIndex:(NSInteger)index{
    return self.allMusic[index];
}

#pragma mark - lazy load

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)allMusic{
    return self.dataArray;
}


@end
