//
//  RemoteImageDownloader.h
//  UICollectionViewTest
//
//  Created by Sanjit shaw on 19/02/13.
//  Copyright (c) 2013 Sanjit shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteImageDownloader : UIImageView
{
    
}

@property (assign, nonatomic) BOOL isNeedtoSaveinDocDir;
@property (retain, nonatomic) NSString *strFileName;

@property (strong, nonatomic) NSOperationQueue *opQueue;

@property (nonatomic, retain) NSMutableData *mData;
@property (nonatomic, retain) UIActivityIndicatorView *actIndicatorView;

-(void)DownloadRemoteImageforURL:(NSString*)strURL withCachingOption:(NSURLRequestCachePolicy)urlCachePolicy;

-(void)DownloadRemoteImageforURL:(NSString*)strURL withCachingOption:(NSURLRequestCachePolicy)urlCachePolicy isNeedtoSaveinDocumentDirectory:(BOOL)isNeedSave;

-(void)DownloadRemoteImageforURL:(NSString*)strURL;

@end
