//
//  YCTImagePickerViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/24.
//

#import <TZImagePickerController/TZImagePickerController.h>
#import "YCTImageUploader.h"
NS_ASSUME_NONNULL_BEGIN

@class YCTImagePickerViewController;

@protocol YCTImagePickerViewControllerDelegate <NSObject>

@optional
- (void)imagePickerController:(YCTImagePickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos;
- (void)imagePickerController:(YCTImagePickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets;

@end


typedef void(^didFinishPickingPhotos) (NSArray<UIImage *> * photos);
@interface YCTImagePickerViewController : TZImagePickerController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<YCTImagePickerViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount didFinishPickingPhotos:(didFinishPickingPhotos)completion NS_DESIGNATED_INITIALIZER;

- (void)configCircleCrop;
- (void)configCropSize:(CGSize)cropSize;

@end

NS_ASSUME_NONNULL_END
