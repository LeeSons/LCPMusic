//
//  PlayingViewController.m
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 李成鹏.com. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "MusicModel.h"
#import "LyricManager.h"
#import "LyricModel.h"

@interface PlayingViewController ()<PlayerManagerDelegate,UITableViewDelegate,UITableViewDataSource>

// 记录当前播放的音乐索引
@property(nonatomic, assign) NSInteger currentIndex;
// 记录当前播放的音乐
@property(nonatomic, retain) MusicModel *currentMusic;

@property(nonatomic, retain) NSTimer *timer;

#pragma mark - 控件

@property (weak, nonatomic) IBOutlet UILabel *lbl2MusicName;
@property (weak, nonatomic) IBOutlet UILabel *lbl2SingerName;
@property (weak, nonatomic) IBOutlet UIImageView *img2Pic;
@property (weak, nonatomic) IBOutlet UILabel *lbl2Duration;
@property (weak, nonatomic) IBOutlet UILabel *lbl2CurrentTime;
@property (weak, nonatomic) IBOutlet UISlider *slider2Time;
@property (weak, nonatomic) IBOutlet UISlider *slider2Volume;
@property (weak, nonatomic) IBOutlet UIButton *btn2PlayOrPause;
@property (weak, nonatomic) IBOutlet UITableView *table2Lyric;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;



- (IBAction)action2Prev:(UIButton *)sender;
- (IBAction)action2PlayOrPause:(UIButton *)sender;
- (IBAction)action2Next:(UIButton *)sender;
- (IBAction)action2ChangeTime:(UISlider *)sender;
- (IBAction)action2ChangeVolume:(UISlider *)sender;


@end

@implementation PlayingViewController

static PlayingViewController *playingVC = nil;
static NSString *cellIdentifier = @"lyricCell";
+ (instancetype)sharedPlayingPVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 拿到main sb
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 在main sb中拿到我们需要的视图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
        playingVC.currentIndex = -1;
    });
    return playingVC;
}

//- (void)setPlayIndex:(NSInteger)playIndex{
//    _playIndex = playIndex;
//    if (_currentIndex == _playIndex) {
//        return;
//    }
//    _currentIndex = _playIndex;
//    [self startPlay];
//}

- (void)startPlay{
    [[PlayerManager sharedManager] playWithUrlString:self.currentMusic.mp3Url];
    [self buildUI];
}

- (void)buildUI{
    self.lbl2MusicName.text = self.currentMusic.name;
    self.lbl2SingerName.text = self.currentMusic.singer;
    [self.img2Pic sd_setImageWithURL:[NSURL URLWithString:self.currentMusic.picUrl]];
    // 更改button
    
    self.slider2Time.maximumValue = [self.currentMusic.duration integerValue] / 1000; // 毫秒换算成秒
    self.slider2Time.value = 0;
    self.lbl2Duration.text = [self stringWithTime:[self.currentMusic.duration integerValue] / 1000];
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.currentMusic.blurPicUrl]];
    // 开始播放时音量和音量控制条一致
    [[PlayerManager sharedManager] seekToVolum:self.slider2Volume.value];
    // 加载歌词
    [[LyricManager sharedManager] loadLyricWith:self.currentMusic.lyric];
    [self.table2Lyric reloadData];
    self.img2Pic.transform = CGAffineTransformMakeRotation(0);
    [_timer setFireDate:[NSDate date]];
}


- (IBAction)action2Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 如果传过来的index和当前播放的索引一样，则什么都不做。直接返回
    if (_playIndex == _currentIndex) {
        return;
    }
    // 否则，记录要播放的索引
    _currentIndex = _playIndex;
    // 开始播放新的音乐
    [self startPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = -1;
    [PlayerManager sharedManager].delegate = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(rote) userInfo:nil repeats:YES];
    [self.btn2PlayOrPause setBackgroundImage:[UIImage imageNamed:@"pause_48px_1183436_easyicon.net.png"] forState:(UIControlStateNormal)];
    // 注册cell
    [self.table2Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    self.slider2Volume.value = [[PlayerManager sharedManager] volume];
}
#pragma mark -- 计时器方法
// 旋转
- (void)rote{
    self.img2Pic.transform = CGAffineTransformRotate(self.img2Pic.transform, M_PI / 30);
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)action2Prev:(UIButton *)sender {
    _currentIndex--;
    if (_currentIndex < 0) {
        _currentIndex = 0;
        return;
    }
    [self startPlay];
}

- (IBAction)action2PlayOrPause:(UIButton *)sender {
    if ([PlayerManager sharedManager].isPlaying) {
        // 如果正在播放，就让播放器暂停，同时改变button 的text
        [[PlayerManager sharedManager] pause];
        [sender setBackgroundImage:[UIImage imageNamed:@"play_48px_1183440_easyicon.net.png"] forState:(UIControlStateNormal)];
        [self.timer setFireDate:[NSDate distantFuture]];
    }else{
        // 暂停状态：开始播放，并改变btn为暂停
        [[PlayerManager sharedManager] play];
        [sender setBackgroundImage:[UIImage imageNamed:@"pause_48px_1183436_easyicon.net.png"] forState:(UIControlStateNormal)];
        [self.timer setFireDate:[NSDate date]];
    }
}

- (IBAction)action2Next:(UIButton *)sender {
    _currentIndex++;
    // 判断是不是最后一首
    if (_currentIndex == [DataManager sharedManager].allMusic.count) {
        // 如果是最后一首，点击下一首的时候就直接播放第一首
        _currentIndex = 0;
    }
    [self startPlay];
}

// 改变播放进度
- (IBAction)action2ChangeTime:(UISlider *)sender {
    [[PlayerManager sharedManager] seekToTime:sender.value];
}

- (IBAction)action2ChangeVolume:(UISlider *)sender {
    [[PlayerManager sharedManager] seekToVolum:sender.value];
}


#pragma mark -PlayerManagerDelegate
- (void)playerDidPlayEnd{
    [self action2Next:nil];
}
// 计时器0.1秒就会让代理执行一下这个事件
- (void)playerPlayWithTime:(NSTimeInterval)time{
    self.slider2Time.value = time;
    self.lbl2CurrentTime.text = [self stringWithTime:time];
    // 根据当前播放时间获取歌词
    NSInteger inepx = [[LyricManager sharedManager] indexWith:time];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:inepx inSection:0];
    [self.table2Lyric selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
   
}
- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger minutes = time / 60;
    NSInteger seconde = (int)time % 60;
    return [NSString stringWithFormat:@"%ld:%02ld",minutes,seconde];
}

#pragma mark - getter
// 确保当前播放的音乐是最新的
- (MusicModel *)currentMusic{
    MusicModel *music = [[DataManager sharedManager] musicModelWithIndex:self.currentIndex];
    return music;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [LyricManager sharedManager].allLyric.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    // 取到对应的model
    LyricModel *lyric = [LyricManager sharedManager].allLyric[indexPath.row];
    // 设置歌词
    cell.textLabel.text = lyric.lyricContext;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    UIView  *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView=view;
    
    return cell;
}

@end
