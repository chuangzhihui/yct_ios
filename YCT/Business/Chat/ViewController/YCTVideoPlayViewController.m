//
//  YCTVideoPlayViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/11.
//

#import "YCTVideoPlayViewController.h"
@import MediaPlayer;
@import AVFoundation;
@import AVKit;

@interface YCTVideoPlayViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AVPlayerViewController *playerVc;
@end

@implementation YCTVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.videoUrl) {
        [self addPlayer];
    } else if (self.thumbUrl) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.imageView.frame = self.view.bounds;
        self.imageView.backgroundColor = [UIColor blackColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.imageView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeNavigationBarColor:UIColor.clearColor titleColor:UIColor.whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self changeNavigationBarColor:UIColor.whiteColor titleColor:UIColor.navigationBarTitleColor];
}

- (void)addPlayer {
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
    vc.player = [AVPlayer playerWithURL:self.videoUrl];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc.player play];
    vc.view.frame = self.view.frame;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
