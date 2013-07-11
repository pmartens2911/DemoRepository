//
//  ITDataManager.h
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/29/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALL_ITEMS @"all"
#define IMAGE_ITEMS @"image"
#define TEXT_ITEMS @"text"

@interface ITDataManager : NSObject
@property (strong, nonatomic) NSMutableDictionary *dictIT;
+ (ITDataManager *)sharedInstance;
+ (void)sendDataRequest;
@end
