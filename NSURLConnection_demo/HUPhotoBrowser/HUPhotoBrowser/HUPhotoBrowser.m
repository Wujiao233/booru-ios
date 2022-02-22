//
//  HUPhotoBrowser.m
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import "HUPhotoBrowser.h"
#import "HUPhotoBrowserCell.h"
#import "hu_const.h"
#import "HUWebImage.h"
#import "HUToast.h"
#import "MBProgressHUD.h"
#import <Photos/Photos.h>


@interface HUPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    CGRect _endTempFrame;
    NSInteger _currentPage;
    NSIndexPath *_zoomingIndexPath;
    BOOL _imageDidLoaded;
    BOOL _animationCompleted;
    BOOL _needShowTags;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *tmpImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, weak) UILabel *countLab;
@property (nonatomic, strong) NSArray *URLStrings;
@property (nonatomic) NSInteger index;
@property (nonatomic) NSInteger imagesCount;
@property (nonatomic, copy) DismissBlock dismissDlock;
@property (nonatomic, strong) NSArray *images;

@end

@implementation HUPhotoBrowser

- (void)dealloc {
    self.collectionView.delegate = nil; 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block {
    HUPhotoBrowser *browser = [[HUPhotoBrowser alloc] initWithFrame:kScreenRect];
    browser.imageView = imageView;
    browser.URLStrings = URLStrings;
    browser.imagesCount = URLStrings.count;
    [browser resetCountLabWithIndex:index+1];
    [browser configureBrowser];
    [browser animateImageViewAtIndex:index];
    browser.placeholderImage = image;
    browser.dismissDlock = block;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:browser action:@selector(handleTap:)];
    [browser addGestureRecognizer:tap];
    
    return browser;
}

-(void)handleTap:(id)sender{
    NSLog(@"Tap!!!!");
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    HUPhotoBrowserCell *cell = (HUPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]];
    [cell.imageView hu_cancelImageDownloadOperationForKey:@"downloadimage"];
    [self dismiss];
}


+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block {
    HUPhotoBrowser *browser = [[HUPhotoBrowser alloc] initWithFrame:kScreenRect];
    browser.imageView = imageView;
    browser.images = images;
    browser.imagesCount = images.count;
    [browser resetCountLabWithIndex:index+1];
    [browser configureBrowser];
    [browser animateImageViewAtIndex:index];
    browser.placeholderImage = image;
    browser.dismissDlock = block;
    
    return browser;
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings atIndex:(NSInteger)index {

    return [self showFromImageView:imageView withURLStrings:URLStrings placeholderImage:nil atIndex:index dismiss:nil];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images atIndex:(NSInteger)index {
    return [self showFromImageView:imageView withImages:images placeholderImage:nil atIndex:index dismiss:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.collectionView];
        
        [self setupToolBar];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadForScreenRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoCellDidZooming:) name:kPhotoCellDidZommingNotification object:nil];
        
    }
    return self;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.URLStrings) {
        count = _URLStrings.count;
    }
    else if (self.images) {
        count = _images.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HUPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoBrowserCellID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    [cell resetZoomingScale];
    __weak __typeof(self) wself = self;
   // __weak __typeof(cell) wcell = cell;
    cell.tapActionBlock = ^(UITapGestureRecognizer *sender) {
       // [wcell.imageView hu_cancelImageDownloadOperationForKey:@"downloadimage"];
        [wself dismiss];
    };
    if (self.URLStrings) {
        NSURL *url = [NSURL URLWithString:self.URLStrings[indexPath.row]];
        if (indexPath.row != _index) {
            [cell.imageView hu_setImageWithURL:url placeholderImage:_placeholderImage];
        }
        else {
            UIImage *placeHolder = _tmpImageView.image;
            [cell.imageView hu_setImageWithURL:url placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, NSURL *imageUrl) {
                if (!_imageDidLoaded) {
                     _imageDidLoaded = YES;
                    NSLog(@"isDownloading");
                    if (_animationCompleted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.collectionView.hidden = NO;
                            [_tmpImageView removeFromSuperview];
                            _animationCompleted = NO;
                            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                        });
                    }
                }
            }];
        }
    }
    else if (self.images) {
        cell.imageView.image = self.images[indexPath.row];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenRect.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPage = scrollView.contentOffset.x/kScreenWidth + 0.5;
    _countLab.text = [NSString stringWithFormat:@"%zd/%zd",_currentPage+1,_imagesCount];
    
    if (_zoomingIndexPath) {
       [self.collectionView reloadItemsAtIndexPaths:@[_zoomingIndexPath]];
        _zoomingIndexPath = nil;
    }
    
}

#pragma mark - notification handler

- (void)reloadForScreenRotate {
     _collectionView.frame = kScreenRect;
   
    [self.collectionView reloadData];
    self.collectionView.contentOffset = CGPointMake(kScreenWidth * _currentPage,0);
}

- (void)photoCellDidZooming:(NSNotification *)nofit {
    NSIndexPath *indexPath = nofit.object;
    _zoomingIndexPath = indexPath;
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.hidden = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    }
    return _collectionView;
}

#pragma mark - private 

- (void)configureBrowser {
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HUPhotoBrowserCell class] forCellWithReuseIdentifier:kPhotoBrowserCellID];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)setupToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-38, self.frame.size.width, 30)];
    _toolBar.backgroundColor = [UIColor clearColor];
    [self addSubview:_toolBar];
    
    UILabel *countLab = [[UILabel alloc] init];
    countLab.textColor = [UIColor whiteColor];
    countLab.layer.cornerRadius = 2;
    countLab.layer.masksToBounds = YES;
    countLab.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    countLab.font = [UIFont systemFontOfSize:13];
    countLab.textAlignment = NSTextAlignmentCenter;
    [_toolBar addSubview:countLab];
    _countLab = countLab;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(_toolBar.frame.size.width-58, 1, 50, 28);
    saveBtn.layer.cornerRadius = 2;
    [saveBtn setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.4]];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [saveBtn addTarget:self action:@selector(saveImae) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:saveBtn];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBtn.frame = CGRectMake(_toolBar.frame.size.width-116, 1, 50, 28);
    infoBtn.layer.cornerRadius = 2;
    [infoBtn setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.4]];
    [infoBtn setTitle:@"Tags" forState:UIControlStateNormal];
    [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    infoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [infoBtn addTarget:self action:@selector(checkPictureTags) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:infoBtn];
    _needShowTags = NO;
    
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.frame = CGRectMake(_toolBar.frame.size.width-174, 1, 50, 28);
    downloadBtn.layer.cornerRadius = 2;
    [downloadBtn setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.4]];
    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    downloadBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [downloadBtn addTarget:self action:@selector(toDownload) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:downloadBtn];
}

-(void)toDownload{
    NSString *url = self.URLStrings[[NSIndexPath indexPathForRow:_currentPage inSection:0].row];
    NSDictionary *dict= @{@"url":url};
    NSLog(@"%@",url);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addToDownload" object:nil userInfo:dict];
}

-(void)checkPictureTags{
    NSLog(@"%d",self.index);
    _needShowTags = YES;
    [self dismiss];
}

- (void)animateImageViewAtIndex:(NSInteger)index {
    _index = index;
    CGRect startFrame = [self.imageView.superview convertRect:self.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGRect endFrame = kScreenRect;
    
    if (self.imageView.image) {
        UIImage *image = self.imageView.image;
        CGFloat ratio = image.size.width / image.size.height;
        
        if (ratio > kScreenRatio) {
            
            endFrame.size.width = kScreenWidth;
            endFrame.size.height = kScreenWidth / ratio;
            
        } else {
            endFrame.size.height = kScreenHeight;
            endFrame.size.width = kScreenHeight * ratio;
            
        }
        endFrame.origin.x = (kScreenWidth - endFrame.size.width) / 2;
        endFrame.origin.y = (kScreenHeight - endFrame.size.height) / 2;
        
    }
    
    _endTempFrame = endFrame;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:startFrame];
    tempImageView.image = self.imageView.image;
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    _tmpImageView = tempImageView;
    
    if (self.URLStrings && !self.images) {
        NSString *key = [HUWebImageDownloader cacheKeyForURL:[NSURL URLWithString:self.URLStrings[_index]]];
        UIImage *image = [HUWebImageDownloader imageFromDiskCacheForKey:key];
        _imageDidLoaded = image != nil;
    }
    [self.collectionView setContentOffset:CGPointMake(kScreenWidth * index,0) animated:NO];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
        
    } completion:^(BOOL finished) {
        _currentPage = index;
        _animationCompleted = YES;
        if(!self.images && !_imageDidLoaded)
            [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES userInterface:NO];
        if (self.images || _imageDidLoaded) {
            self.collectionView.hidden = NO;
            [tempImageView removeFromSuperview];
            _animationCompleted = NO;
        }
        
    }];
    
    
}

- (void)dismiss {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    
    if (self.dismissDlock) {
        HUPhotoBrowserCell *cell = (HUPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]];
        self.dismissDlock(cell.imageView.image, _currentPage);
    }
    
    if (_currentPage != _index) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
        return;
    }
    
    CGRect endFrame = [self.imageView.superview convertRect:self.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:_endTempFrame];
    tempImageView.image = self.imageView.image;
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.collectionView.hidden = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [tempImageView removeFromSuperview];
        if(_needShowTags == YES){
            NSMutableDictionary * dict = [NSMutableDictionary new];
            [dict setValue:[NSString stringWithFormat:@"%d",self.index] forKey:@"index"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"needShowTags" object:nil userInfo:dict];
        }
    }];
    
}

- (void)resetCountLabWithIndex:(NSInteger)index {
    
    NSString *text = [NSString stringWithFormat:@"%zd%zd",_imagesCount,_imagesCount];
    CGFloat width = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width+8;
    _countLab.frame = CGRectMake(8, 1, MAX(50, width), 28);
    _countLab.text = [NSString stringWithFormat:@"%zd/%zd",index,_imagesCount];
}

- (PHAssetCollection * )createCollection{
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

-(PHFetchResult<PHAsset *> *)createAssetWithImage:(UIImage *)image{
    NSError * error = nil;
    __block NSString * assetID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID =  [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error) return nil;
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

- (void)saveImae {
    HUPhotoBrowserCell *cell = (HUPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]];
    
    UIImage *seavedImage = cell.imageView.image;
    if (seavedImage) {
        
        NSError * error = nil;
        PHAssetCollection *createdCollection = [self createCollection];
        PHFetchResult<PHAsset *> *asset = [self createAssetWithImage:seavedImage];
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            PHAssetCollectionChangeRequest * request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
            [request insertAssets:asset atIndexes:[NSIndexSet indexSetWithIndex:0]];
        } error:&error];
        if (!error){
            NSLog(@"%@",error);
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"图片已保存！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show] ;
        }else{
            NSLog(@"%@",error);
        }
        //            UIImageWriteToSavedPhotosAlbum(seavedImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
//        return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
        
    }
   
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
  
    NSString *msg = nil ;
    if(error != nil){
        msg = @"保存图片失败";
    }
    else{
        msg = @"保存图片成功";
    }
    [HUToast showToastWithMsg:msg];
}

@end
