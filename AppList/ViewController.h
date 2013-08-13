//
//  ViewController.h
//  AppList
//
//  Created by sanjit_s on 03/07/13.
//  Copyright (c) 2013 sanjit_s. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController
{
    
}

@property (strong, nonatomic) NSOperationQueue *opQueue;
@property (nonatomic,retain)NSMutableArray *marrAppname;
@property (nonatomic,retain)NSMutableArray *marrImgUrl;
@property (nonatomic,retain)NSMutableData *mData;

@end
