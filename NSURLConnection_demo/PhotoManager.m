//
//  PhotoManager.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/7/21.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "PhotoManager.h"
#import <Photos/Photos.h>
#import <UIImage+MultiFormat.h>

@implementation PhotoManager

+(PHAssetCollection * )createCollection{
    // 创建一个新的相册
    // 查看所有的自定义相册
    // 先查看是否有自己要创建的自定义相册
    // 如果没有自己要创建的自定义相册那么我们就进行创建
    NSString * title = @"Moe_Image";
    PHFetchResult<PHAssetCollection *> *collections =  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHAssetCollection * createCollection = nil; // 最终要获取的自己创建的相册
    for (PHAssetCollection * collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {    // 如果有自己要创建的相册
            createCollection = collection;
            break;
        }
    }
    if (createCollection == nil) {  // 如果没有自己要创建的相册
        // 创建自己要创建的相册
        NSError * error1 = nil;
        __block NSString * createCollectionID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error1];
        
        if (error1) {
            NSLog(@"创建相册失败...");
        }
        // 创建相册之后我们还要获取此相册  因为我们要往进存储相片
        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
    }
    
    return createCollection;
}

+(PHFetchResult<PHAsset *> *)createAssetWithImage:(UIImage *)image{
    NSError * error = nil;
    __block NSString * assetID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID =  [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error) return nil;
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

+ (void)saveImaeWithFile:(NSString *)file {
    UIImage *seavedImage = [UIImage imageWithContentsOfFile:file];
    if (seavedImage) {
        NSError * error = nil;
        PHAssetCollection *createdCollection = [PhotoManager createCollection];
        PHFetchResult<PHAsset *> *asset = [PhotoManager createAssetWithImage:seavedImage];
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            PHAssetCollectionChangeRequest * request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
            [request insertAssets:asset atIndexes:[NSIndexSet indexSetWithIndex:0]];
        } error:&error];
        if (!error){
            NSLog(@"%@ Saved!!!!",error);
//            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"图片已保存！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show] ;
        }else{
            NSLog(@"%@",error);
        }
    }
  
}


@end
