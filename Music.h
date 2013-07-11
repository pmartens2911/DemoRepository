//
//  Music.h
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Genre;

@interface Music : NSManagedObject

@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSNumber * favorites;
@property (nonatomic, retain) Genre *genre;

@end
