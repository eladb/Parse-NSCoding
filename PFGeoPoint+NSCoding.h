//
//  PFGeoPoint+NSCoding.h
//  Finding Rover
//
//  Created by Brandon Schlenker on 05/03/2014.
//  Copyright (c) 2014 Boldium LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFGeoPoint (NSCoding)

- (void)encodeWithCoder:(NSCoder*)encoder;
- (id)initWithCoder:(NSCoder*)aDecoder;

@end
