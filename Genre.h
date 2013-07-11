//
//  Genre.h
//  Week5Proj
//
//  Created by Marcos Vazquez on 6/28/13.
//  Copyright (c) 2013 unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Music;

@interface Genre : NSManagedObject

@property (nonatomic, retain) NSString * genreName;
@property (nonatomic, retain) NSSet *music;
@end

@interface Genre (CoreDataGeneratedAccessors)

- (void)addMusicObject:(Music *)value;
- (void)removeMusicObject:(Music *)value;
- (void)addMusic:(NSSet *)values;
- (void)removeMusic:(NSSet *)values;

@end
