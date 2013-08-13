//
//  ImageLoader.h
//  SaveImageForOfflineUsage
//
//  Created by Betrand Yella on 06/09/12.
//  Copyright (c) 2012 betrand@ibeesolutions.com. All rights reserved.
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
