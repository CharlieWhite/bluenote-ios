//
//  Note.h
//  Bluenote-ios
//
//  Created by Charlie White on 9/7/13.
//  Copyright (c) 2013 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic, copy) NSNumber *noteId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *createdAt;

@end
