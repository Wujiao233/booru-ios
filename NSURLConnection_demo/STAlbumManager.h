//
//  STAlbumManager.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/7/20.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AssetsLibrary/AssetsLibrary.h>

@class UIImage;
typedef void (^STAlbumSaveHandler)(UIImage *image, NSError *error);

/**
 * @brief 将图片写入相册,使用ALAssetLibrary
 *
 * @param  image    需要写入的图片
 * @param  album    相册名称，如果相册不存在，则新建相册
 * @param  completionHandler 回调
 */
extern void STImageWriteToPhotosAlbum(UIImage *image, NSString *album, STAlbumSaveHandler completionHandler);

@interface STAlbumManager : NSObject

+ (instancetype)sharedManager;

/**
 * @brief 将图片写入相册,使用ALAssetLibrary
 *
 * @param  image    需要写入的图片
 * @param  album    相册名称，如果相册不存在，则新建相册
 * @param  completionHandler 回调
 */
- (void)saveImage:(UIImage *)image toAlbum:(NSString *)album completionHandler:(STAlbumSaveHandler)completionHandler;

@end

@interface ALAssetsLibrary (STAssetsLibrary)

- (void)writeImage:(UIImage *)image toAlbum:(NSString *)album completionHandler:(STAlbumSaveHandler)completionHandler;

@end
