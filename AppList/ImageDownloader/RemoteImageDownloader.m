//
//  RemoteImageDownloader.m
//  UICollectionViewTest
//
//  Created by Sanjit shaw on 19/02/13.
//  Copyright (c) 2013 Sanjit shaw. All rights reserved.
//

#import "RemoteImageDownloader.h"

#import "ImageLoader.h"

@interface RemoteImageDownloader ()

-(void)DownloadRemoteImageforURL:(NSString*)strURL;

@end

@implementation RemoteImageDownloader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)DownloadRemoteImageforURL:(NSString*)strURL
{
    /*NSURL *url = [NSURL URLWithString:strURL];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:urlRequest delegate:self];*/
    
    ImageLoader *subCategoryImgLoader = [[[ImageLoader alloc] initWithUrl:[NSURL URLWithString:strURL]] autorelease];
    
    subCategoryImgLoader.target = self;
    subCategoryImgLoader.didFinishSelector = @selector(imageDownloadDidFinishwithData:andOperation:);
    subCategoryImgLoader.didFailSelector = @selector(imageDownloadfailedwithErrorDesc:andOperation:);
    [_opQueue setMaxConcurrentOperationCount:1];
    
    if ([_opQueue operationCount] > 0)
    {
        NSOperation *lastOperation = [[_opQueue operations] lastObject];
        
        [subCategoryImgLoader addDependency:lastOperation];
    }   
    
    [_opQueue addOperation:subCategoryImgLoader];
    
    if ([self viewWithTag:100])
     {
     UIActivityIndicatorView *tempActivityIndicator = (UIActivityIndicatorView*)[self viewWithTag:100];
     [tempActivityIndicator removeFromSuperview];
     }
    
    /*if (_actIndicatorView)
    {
        [_actIndicatorView removeFromSuperview], _actIndicatorView = nil;
    }*/
    
    _actIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _actIndicatorView.tag = 100;
    _actIndicatorView.center = self.center;
    [self addSubview:_actIndicatorView];
    [_actIndicatorView startAnimating];
    
}


-(void)imageDownloadDidFinishwithData:(NSData*)data andOperation:(ImageLoader*)imageLoader
{
    [self setImage:[UIImage imageWithData:data]];
    
    if (_actIndicatorView && [_actIndicatorView isAnimating])
    {
        [_actIndicatorView stopAnimating];
        [_actIndicatorView removeFromSuperview], _actIndicatorView = nil;
    }
    
    //[imageLoader willChangeValueForKey:@"isExecuting"];
    //[imageLoader willChangeValueForKey:@"isFinished"];
    
    //imageLoader.isExecuting = NO;
    //imageLoader.isFinished = YES;
    
    //[imageLoader didChangeValueForKey:@"isExecuting"];
    //[imageLoader didChangeValueForKey:@"isFinished"];
}

-(void)imageDownloadfailedwithErrorDesc:(NSString*)errDesc andOperation:(ImageLoader*)imageLoader
{
    //[imageLoader willChangeValueForKey:@"isExecuting"];
    //[imageLoader willChangeValueForKey:@"isFinished"];
    
    if (_actIndicatorView && [_actIndicatorView isAnimating])
    {
        [_actIndicatorView stopAnimating];
        [_actIndicatorView removeFromSuperview], _actIndicatorView = nil;
    }
    
    //imageLoader.isExecuting = NO;
    //imageLoader.isFinished = YES;
    
    //[imageLoader didChangeValueForKey:@"isExecuting"];
    //[imageLoader didChangeValueForKey:@"isFinished"];
}

-(void)DownloadRemoteImageforURL:(NSString*)strURL withCachingOption:(NSURLRequestCachePolicy)urlCachePolicy
{
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:urlCachePolicy timeoutInterval:30];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
    /*if ([self viewWithTag:100])
    {
        UIActivityIndicatorView *tempActivityIndicator = (UIActivityIndicatorView*)[self viewWithTag:100];
        [tempActivityIndicator removeFromSuperview];
    }*/
    
    if (_actIndicatorView)
    {
        [_actIndicatorView removeFromSuperview], _actIndicatorView = nil;
    }
    
    _actIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _actIndicatorView.tag = 100;
    _actIndicatorView.center = self.center;
    [self addSubview:_actIndicatorView];
    [_actIndicatorView startAnimating];
    
}

-(void)DownloadRemoteImageforURL:(NSString*)strURL withCachingOption:(NSURLRequestCachePolicy)urlCachePolicy isNeedtoSaveinDocumentDirectory:(BOOL)isNeedSave
{
    _isNeedtoSaveinDocDir = isNeedSave;
    
    self.strFileName = [strURL lastPathComponent];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:urlCachePolicy timeoutInterval:30];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
    /*if ([self viewWithTag:100])
     {
     UIActivityIndicatorView *tempActivityIndicator = (UIActivityIndicatorView*)[self viewWithTag:100];
     [tempActivityIndicator removeFromSuperview];
     }*/
    
    if (_actIndicatorView)
    {
        [_actIndicatorView removeFromSuperview], _actIndicatorView = nil;
    }
    
    _actIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _actIndicatorView.tag = 100;
    _actIndicatorView.center = self.center;
    [self addSubview:_actIndicatorView];
    [_actIndicatorView startAnimating];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error  %@",[error localizedDescription]);
    [_actIndicatorView stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _mData = [[NSMutableData alloc] initWithLength:0];
    NSLog(@"response status  %ld",(long)[(NSHTTPURLResponse*)response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_isNeedtoSaveinDocDir)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", _strFileName]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: path])
        {
            path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@", _strFileName] ];
            
            [_mData writeToFile:path atomically:YES];
        }
    }
    
    [_actIndicatorView stopAnimating];
    self.image = [UIImage imageWithData:_mData];
    //NSLog(@"appdetail  Name %@  Image  %@", _marrAppname, _marrImgUrl);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
