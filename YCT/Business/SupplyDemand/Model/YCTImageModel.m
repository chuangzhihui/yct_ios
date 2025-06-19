//
//  YCTImageModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/11.
//

#import "YCTImageModel.h"
#import "UIImage+Common.h"

@interface YCTImageModel ()
@property (nonatomic, copy, readwrite) NSString *imageHash;
@end

@implementation YCTImageModel

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageHash = [_image imageHash];
}

@end
