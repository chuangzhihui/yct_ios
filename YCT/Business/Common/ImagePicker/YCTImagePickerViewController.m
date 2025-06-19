//
//  YCTImagePickerViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/24.
//

#import "YCTImagePickerViewController.h"

@interface YCTImagePickerViewController ()<TZImagePickerControllerDelegate> {
    NSArray *_selectedPhotos;
    NSArray *_selectedAssets;
}

@property (weak, nonatomic) id<YCTImagePickerViewControllerDelegate> yct_delegate;
@property (copy, nonatomic) didFinishPickingPhotos didFinishPickingPhotos;
@end

@implementation YCTImagePickerViewController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<YCTImagePickerViewControllerDelegate>)delegate {
    if (self = [super initWithMaxImagesCount:maxImagesCount columnNumber:4 delegate:self pushPhotoPickerVc:YES]) {
        self.yct_delegate = delegate;
        [self setup];
    }
    return self;
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount didFinishPickingPhotos:(didFinishPickingPhotos)completion{
    if (self = [super initWithMaxImagesCount:maxImagesCount columnNumber:4 delegate:self pushPhotoPickerVc:YES]) {
        self.didFinishPickingPhotos = completion;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    self.preferredLanguage = [YCTSanboxTool getCurrentLanguage];
    
    self.autoDismiss = NO;
    self.allowEditVideo = NO;
    self.isSelectOriginalPhoto = NO;
    
    self.navigationBar.barTintColor = UIColor.whiteColor;
    self.oKButtonTitleColorDisabled = UIColor.lightGrayColor;
    self.oKButtonTitleColorNormal = UIColor.mainTextColor;
    if (self.maxImagesCount == 1) {
        self.oKButtonTitleColorNormal = UIColor.whiteColor;
    }
    self.barItemTextColor = UIColor.mainTextColor;
    self.navigationBar.translucent = NO;
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.mainTextColor}];
    self.navigationBar.tintColor = UIColor.mainTextColor;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
        barAppearance.backgroundColor = self.navigationBar.barTintColor;
        barAppearance.shadowColor = UIColor.clearColor;
        barAppearance.titleTextAttributes = self.navigationBar.titleTextAttributes;
        self.navigationBar.standardAppearance = barAppearance;
        self.navigationBar.scrollEdgeAppearance = barAppearance;
    }
    
    self.iconThemeColor = UIColor.mainThemeColor;
    self.showPhotoCannotSelectLayer = YES;
    self.cannotSelectLayerColor = [UIColor.whiteColor colorWithAlphaComponent:0.8];
    
    self.allowPickingMultipleVideo = YES;
    self.allowPickingVideo = NO;
    self.allowPickingImage = YES;
    self.allowPickingOriginalPhoto = YES;
    self.allowCameraLocation = NO;
    
    self.showSelectBtn = NO;
    self.allowCrop = NO;
    self.needCircleCrop = NO;
    
    self.sortAscendingByModificationDate = YES;
    
    self.statusBarStyle = UIStatusBarStyleDefault;
    
    self.showSelectedIndex = YES;
}

- (void)configCircleCrop {
    self.allowCrop = YES;
    self.needCircleCrop = YES;
    self.cropRect = (CGRect){
        0,
        (self.view.bounds.size.height - self.view.bounds.size.width) / 2,
        self.view.bounds.size.width,
        self.view.bounds.size.width
    };
    self.scaleAspectFillCrop = YES;
}

- (void)configCropSize:(CGSize)cropSize {
    self.allowCrop = YES;
    self.needCircleCrop = NO;
    self.cropRect = (CGRect){
        (self.view.bounds.size.width - cropSize.width) / 2,
        (self.view.bounds.size.height - cropSize.height) / 2,
        cropSize
    };
    self.scaleAspectFillCrop = YES;
}

#pragma mark - TZImagePickerControllerDelegate

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    _selectedPhotos = [NSArray arrayWithArray:photos];
    _selectedAssets = [NSArray arrayWithArray:assets];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.yct_delegate && [self.yct_delegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:)]) {
            [self.yct_delegate imagePickerController:self didFinishPickingPhotos:photos];
        }
        if (self.yct_delegate && [self.yct_delegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:)]) {
            [self.yct_delegate imagePickerController:self didFinishPickingPhotos:photos sourceAssets:assets];
        }
        if (self.didFinishPickingPhotos) {
            self.didFinishPickingPhotos(photos);
        }
    }];

//    self.operationQueue = [[NSOperationQueue alloc] init];
//    self.operationQueue.maxConcurrentOperationCount = 1;
//    for (NSInteger i = 0; i < assets.count; i++) {
//        PHAsset *asset = assets[i];
//        TZImageUploadOperation *operation = [[TZImageUploadOperation alloc] initWithAsset:asset completion:^(UIImage * photo, NSDictionary *info, BOOL isDegraded) {
//            if (isDegraded) return;
//            NSLog(@"图片获取&上传完成");
//        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
//            NSLog(@"获取原图进度 %f", progress);
//        }];
//        [self.operationQueue addOperation:operation];
//    }
}

@end
