//
//  MusicCell.h
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"


@interface MusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMusicName;
@property (weak, nonatomic) IBOutlet UILabel *lblAuName;
@property (weak, nonatomic) IBOutlet UIImageView *imgMusicPic;
@property (weak, nonatomic) IBOutlet UIImageView *isPlaying;


@property(nonatomic, retain) MusicModel * music;

@end
