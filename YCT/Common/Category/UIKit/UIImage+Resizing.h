//
//  UIImage+Resize.h
//  NYXImagesKit
//
//  Created by @Nyx0uf on 02/05/11.
//  Copyright 2012 Nyx0uf. All rights reserved.
//  www.cocoaintheshell.com
//


typedef enum
{
	NYXCropModeTopLeft,
	NYXCropModeTopCenter,
	NYXCropModeTopRight,
	NYXCropModeBottomLeft,
	NYXCropModeBottomCenter,
	NYXCropModeBottomRight,
	NYXCropModeLeftCenter,
	NYXCropModeRightCenter,
	NYXCropModeCenter
} NYXCropMode;

typedef enum
{
	NYXResizeModeScaleToFill,
	NYXResizeModeAspectFit,
	NYXResizeModeAspectFill
} NYXResizeMode;


@interface UIImage (NYX_Resizing)

-(UIImage*)cropToSize:(CGSize)newSize usingMode:(NYXCropMode)cropMode;

// NYXCropModeTopLeft crop mode used
-(UIImage*)cropToSize:(CGSize)newSize;

-(UIImage*)scaleByFactor:(float)scaleFactor;

-(UIImage*)scaleToSize:(CGSize)newSize usingMode:(NYXResizeMode)resizeMode;

// NYXResizeModeScaleToFill resize mode used
-(UIImage*)scaleToSize:(CGSize)newSize;

// Same as 'scale to fill' in IB.
-(UIImage*)scaleToFillSize:(CGSize)newSize;

// Preserves aspect ratio. Same as 'aspect fit' in IB.
-(UIImage*)scaleToFitSize:(CGSize)newSize;

// Preserves aspect ratio. Same as 'aspect fill' in IB.
-(UIImage*)scaleToCoverSize:(CGSize)newSize;


+ (UIImage *)grayImage:(UIImage *)sourceImage;



@end
