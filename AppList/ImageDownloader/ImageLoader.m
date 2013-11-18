//
//  ImageLoader.m
//  SaveImageForOfflineUsage
//
//  Created by sanjit_s on 03/07/13.
//  Copyright (c) 2013 sanjit_s. All rights reserved.
//

#import "ImageLoader.h"

@implementation ImageLoader

@synthesize urlToHit = _urlToHit;
//@synthesize m_context;
@synthesize strKey = _strKey;
//@synthesize m_object = _m_object;


-(id)initWithUrl:(NSURL*)url
{
    self = [super init];
    if (!self) 
    {
        self = [super init];
        [self setUrlToHit:url];
        return self;
    }
    [self setUrlToHit:url];
    return self;
}

-(void)main
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(main) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self startDownload];
    //NSData *data = [[NSData alloc] initWithContentsOfURL:_urlToHit];
    
    //[_m_object setValue:data forKey:_strKey];
    //DLog(@"db_entity  %@",[db_Entity valueForKey:key]);
        
}

- (BOOL)isConcurrent
{
    return YES;
}

-(void)startDownload
{    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:_urlToHit cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30] delegate:self];
    [conn start];
    NSLog(@"started..");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    mData = [[NSMutableData alloc] init];
    
    NSLog(@"response status  %d",[(NSHTTPURLResponse*)response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error  %@",[error localizedDescription]);
    
    if (_target)
    {
        if ([_target respondsToSelector:_didFailSelector])
        {
            [_target performSelector:_didFailSelector withObject:[error localizedDescription] withObject:self];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"called op. finish");
    //[_m_object setValue:mData forKey:_strKey];
    //DLog(@"db_entity  %@",[db_Entity valueForKey:key]);
    
    if([mData length] > 0)
    {
        //DLog(@"Saved");
        if (_target)
        {
            if ([_target respondsToSelector:_didFinishSelector])
            {
                [_target performSelector:_didFinishSelector withObject:mData withObject:self];
            }
        }
    }
    else
    {
        if (_target)
        {
            if ([_target respondsToSelector:_didFailSelector])
            {
                [_target performSelector:_didFailSelector withObject:@"Download Failed" withObject:self];
            }
        }
        //DLog(@"Failed");
    }
}



-(void)dealloc
{
    [_urlToHit release];
    [mData release];
    [super dealloc];
}

@end
