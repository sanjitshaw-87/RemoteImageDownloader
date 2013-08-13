//
//  ViewController.m
//  AppList
//
//  Created by sanjit_s on 03/07/13.
//  Copyright (c) 2013 sanjit_s. All rights reserved.
//

#import "ViewController.h"

#import "RemoteImageDownloader.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _marrImgUrl = [[NSMutableArray alloc] init];
    _marrAppname = [[NSMutableArray alloc] init];
    self.opQueue = [[[NSOperationQueue alloc] init] autorelease];
    
    //[self fetchDataFromURL:[NSURL URLWithString:@"http://www.google.com/ig/calculator?hl=en&q=1USD=?INR"]];
    
    [self fetchDataFromURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=400/json"]];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_marrAppname && ([_marrAppname count] > 0))
    {
        return [_marrAppname count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (_marrImgUrl && (indexPath.row <= [_marrImgUrl count]))
    {
        RemoteImageDownloader *imgView = (RemoteImageDownloader*)[cell viewWithTag:1];
        
        if (imgView == nil)
        {
            imgView = [[RemoteImageDownloader alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, cell.frame.size.height)];
            imgView.tag = 1;
            [cell.contentView addSubview:imgView];
        }
        imgView.image = nil;
        imgView.backgroundColor = [UIColor grayColor];
        imgView.opQueue = _opQueue;
        //[imgView performSelector:@selector(DownloadRemoteImageforURL:withCachingOption:) withObject:[_marrImgUrl objectAtIndex:indexPath.row]];
        
        if ([self checkDocDirectoryforFileName:[[_marrImgUrl objectAtIndex:indexPath.row] lastPathComponent]])
        {
            [imgView setImage:[UIImage imageWithData:[self checkDocDirectoryforFileName:[[_marrImgUrl objectAtIndex:indexPath.row] lastPathComponent]]]];
        }
        else
        {
            [imgView DownloadRemoteImageforURL:[_marrImgUrl objectAtIndex:indexPath.row] withCachingOption:NSURLRequestReloadRevalidatingCacheData isNeedtoSaveinDocumentDirectory:YES];
        }
        
        
        
        //[imgView DownloadRemoteImageforURL:[_marrImgUrl objectAtIndex:indexPath.row]];
    }
    
    if (_marrAppname && ([_marrAppname count] > 0))
    {
        //cell.textLabel.text = [_marrAppname objectAtIndex:indexPath.row];
        
        UILabel *lblAppName = (UILabel*)[cell viewWithTag:2];
        
        if (lblAppName == nil)
        {
            lblAppName = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 0.0, 250.0, cell.frame.size.height)];
            lblAppName.tag = 2;
            [cell.contentView addSubview:lblAppName];
        }
        lblAppName.text = [_marrAppname objectAtIndex:indexPath.row];
    }
    
    // Configure the cell...
    
    return cell;
}

-(NSData*)checkDocDirectoryforFileName:(NSString*)strFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", strFileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        return data;
    }
    else
    {
        return nil;
    }
}


#pragma mark NSUrlConnection delegates

-(void)fetchDataFromURL:(NSURL*)url
{
    NSMutableURLRequest *murlRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:murlRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error  %@",[error localizedDescription]);
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
    //NSString *data_Response = [[NSString alloc] initWithData:_mData encoding:NSUTF8StringEncoding] ;
    
    NSError *err = nil;
    
    //NSLog(@"check  %@", [[NSJSONSerialization JSONObjectWithData:_mData options:NSJSONReadingMutableContainers error:&err] class]);
    //NSLog(@"error  %@", err);
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_mData options:NSJSONReadingMutableContainers error:&err];
    
    for (int i =0; i < [[[dictResponse objectForKey:@"feed"] objectForKey:@"entry"] count]; i++)
    {
        [_marrAppname addObject:[[[[[dictResponse objectForKey:@"feed"] objectForKey:@"entry"] objectAtIndex:i] objectForKey:@"im:name"]  objectForKey:@"label"]];
        
        [_marrImgUrl addObject:[[[[[[dictResponse objectForKey:@"feed"] objectForKey:@"entry"] objectAtIndex:i] objectForKey:@"im:image"] objectAtIndex:2] objectForKey:@"label"]];
    }
    [self.tableView reloadData];
    //NSLog(@"appdetail  Name %@  Image  %@", _marrAppname, _marrImgUrl);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
