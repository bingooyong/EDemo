//
//  ViewController.m
//  BannerAutoChangeDemo
//
//  Created by shuvigoss on 13-1-5.
//  Copyright (c) 2013年 shuvigoss. All rights reserved.
//  http://image.shop.10010.com/upay/biz/images/payfee/common/50yuan.gif
// http://image.shop.10010.com/upay/biz/images/payfee/common/500yuan.gif

#import "ViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "FMDatabase.h"
#import "Image.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "JSONKit.h"

static BOOL download_stat;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkDBHasExist];
    if(!_images)
        _images = [[NSMutableArray alloc] init];
    [self initImageConfig];
    [self initNetWork];
    if(!download_stat)
        [self setupViews];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)setupViews{
    SGFocusImageItem *item;
    NSMutableArray *array = [[[NSMutableArray alloc] init]autorelease];
    for (int i = 0; i < [_images count]; i++) {
        Image *im = [_images objectAtIndex:i];
        item = [[[SGFocusImageItem alloc] initWithTitle:[NSString stringWithFormat:@"title%@", im.image_id] image:[UIImage imageWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.%@", im.image_id, @"jpg"]]] tag:im.image_id.intValue] autorelease];
        [array addObject:item];
    }
    SGFocusImageFrame *imageFrame = [[[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120.0) delegate:self itemsArray:array] autorelease];
    [self.view addSubview:imageFrame];
    return imageFrame;
    
}

- (void) initNetWork{
    
    if(!queue){
        queue = [[ASINetworkQueue alloc] init];
    }

    failed = NO;
    
    [queue reset];
    [queue setQueueDidFinishSelector:@selector(imageFetchComplete:)];
    [queue setRequestDidFailSelector:@selector(imageFetchFailed:)];
    [queue setDelegate:self];
    for (int i = 0; i < [_images count]; i++) {
        Image *im = [_images objectAtIndex:i];
        if([self checkImageHasExist:im])
            continue;
        [self downloadImage:im];
    }
    
    
    
}


- (void)imageFetchComplete:(ASIHTTPRequest *)request{
    download_stat = YES;
    NSLog(@"queue finish");
    [self setupViews];
}
- (void)imageFetchFailed:(ASIHTTPRequest *)request{
    NSLog(@"image downloac faild");
}

//check image has existed if existed return yes else return no
- (BOOL) checkImageHasExist:(Image *) image{
    
        NSString *imageName = [NSString stringWithFormat:@"%@.%@", image.image_id, @"jpg"];
        
        NSString *appFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
        if([[NSFileManager defaultManager] fileExistsAtPath:appFile]){
            NSLog(@"File is found");
            return YES;
        }
    return NO;
}
//download image from internet
- (void) downloadImage:(Image *) im{
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:im.image_url]]autorelease];
    [request setDownloadDestinationPath:[[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", im.image_id]]];
    [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"request%@", im.image_id] forKey:@"name"]];
    [queue addOperation:request];
    NSLog(@"begin download %@", im.image_url);
    [queue go];
}

//init image config by query sqlite 
- (void) initImageConfig{
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.192.202.79:8080/IImageServer/WEB-INF.jsp"]] autorelease];
    [request startSynchronous];
    NSString *response = [request responseString];
    NSDictionary *result = [response objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSArray *list = [result objectForKey:@"imageDATA"];

    FMDatabase *db = [FMDatabase databaseWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"testdb.db"]];
    if([db open]){
        
    [db executeUpdate:@"update image_config set image_status = '1' where image_status = '0'"];
    for (int i = 0; i < [list count]; i++) {
        NSString *image_id = [[list objectAtIndex:i] objectForKey:@"image_id"];
        NSString *image_url = [[list objectAtIndex:i] objectForKey:@"image_url"];
        [db executeUpdate:[NSString stringWithFormat: @"insert into image_config (image_id, image_url, image_status) values ('%@', '%@', '%@')", image_id, image_url, @"0"]];
    }

        FMResultSet *res = [db executeQuery:@"select image_id, image_url, image_status from image_config where image_status = '0'"];
        
        while ([res next]) {
            Image *_item = [[[Image alloc] init] autorelease];
            _item.image_id = [res stringForColumnIndex:0];
            _item.image_url = [res stringForColumnIndex:1];
            _item.image_status = [res stringForColumnIndex:2];
            [_images addObject:_item];
        }
        [res close];
    }
    [db close];
}

- (void) checkDBHasExist{
    NSString *dbFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"testdb.db"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:dbFile]){
        NSLog(@"testdb file not exist! copy source dbfile to documents folder");
        NSData *mainBundleFile = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testdb" ofType:@"db"]];
        [[NSFileManager defaultManager] createFileAtPath:dbFile contents:mainBundleFile  attributes:nil];
    }
}


- (void) dealloc{
    [super dealloc];
    [_images release];
    [frame release];
    [queue release];
}

@end
