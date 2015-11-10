//
//  MusicCell.m
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

- (void)setMusic:(MusicModel *)music{
    _music = music;
    [self.imgMusicPic sd_setImageWithURL:[NSURL URLWithString:music.picUrl] placeholderImage:[UIImage imageNamed:@"mn"]];
    self.lblMusicName.text = music.name;
    self.lblAuName.text = music.singer;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
