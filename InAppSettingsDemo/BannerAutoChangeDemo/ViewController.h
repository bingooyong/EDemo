//
//  ViewController.h
//  BannerAutoChangeDemo
//
//  Created by shuvigoss on 13-1-5.
//  Copyright (c) 2013年 shuvigoss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASINetworkQueue;
@class SGFocusImageFrame;


@interface ViewController : UIViewController{
    NSMutableArray *_images;
    ASINetworkQueue *queue;
    BOOL failed;
    SGFocusImageFrame *frame;
    
}

@end
