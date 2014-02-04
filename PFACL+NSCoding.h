//
//  PFACL+NSCoding.h
//  UpdateZen
//
//  Created by Martin Rybak on 2/3/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFACL (NSCoding)

- (void)encodeWithCoder:(NSCoder*)encoder;
- (id)initWithCoder:(NSCoder*)aDecoder;

@end
