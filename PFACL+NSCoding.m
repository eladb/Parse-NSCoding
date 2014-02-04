//
//  PFACL+NSCoding.m
//  UpdateZen
//
//  Created by Martin Rybak on 2/3/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import "PFACL+NSCoding.h"

#define kPFACLPermissions @"permissionsById"

@implementation PFACL (NSCoding)

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:[self valueForKey:kPFACLPermissions] forKey:kPFACLPermissions];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    if (self) {
        [self setValue:[aDecoder decodeObjectForKey:kPFACLPermissions] forKey:kPFACLPermissions];
    }
    return self;
}

@end
