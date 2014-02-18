//
//  PFObject+NSCoding.h
//  UpdateZen
//
//  Created by Martin Rybak on 2/3/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFObject (NSCoding)

//Re-declare timestamp properties as read-write
@property (nonatomic, retain, readwrite) NSDate* updatedAt;
@property (nonatomic, retain, readwrite) NSDate* createdAt;

- (void)encodeWithCoder:(NSCoder*)encoder;
- (id)initWithCoder:(NSCoder*)aDecoder;

@end
