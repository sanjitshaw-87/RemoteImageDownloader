//
//  ImageLoader.h
//  SaveImageForOfflineUsage
//
//  Created by sanjit_s on 03/07/13.
//  Copyright (c) 2013 sanjit_s. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageLoader : NSOperation
{
    NSMutableData *mData;
}


@property (nonatomic,retain) NSURL *urlToHit;
@property (nonatomic,retain) NSString *strKey;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL didFinishSelector;
@property (nonatomic, assign) SEL didFailSelector;
//@property (nonatomic,retain) NSManagedObject *m_object;
//@property (nonatomic,retain) NSManagedObjectContext *m_context;

-(id)initWithUrl:(NSURL*)url;

@end
