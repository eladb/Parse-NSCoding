//
//  PFGeoPoint+NSCoding.m
//  Finding Rover
//
//  Created by Brandon Schlenker on 05/03/2014.
//  Copyright (c) 2014 Boldium LLC. All rights reserved.
//

#import "PFGeoPoint+NSCoding.h"
#import <objc/runtime.h>

#define kPFGeoPointLatitude @"_latitude"
#define kPFGeoPointLongitude @"_longitude"
#define kPFGeoPointIvars @"ivars"

@implementation PFGeoPoint (NSCoding)

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:[NSNumber numberWithDouble:self.latitude] forKey:kPFGeoPointLatitude];
	[encoder encodeObject:[NSNumber numberWithDouble:self.longitude] forKey:kPFGeoPointLongitude];

}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	NSNumber *latitude = [aDecoder decodeObjectForKey:kPFGeoPointLatitude];
	NSNumber *longitude = [aDecoder decodeObjectForKey:kPFGeoPointLongitude];
    NSDictionary* ivars = [aDecoder decodeObjectForKey:kPFGeoPointIvars];

	self = [PFGeoPoint geoPointWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
	if (self) {
		for (NSString* key in [ivars allKeys]) {
			[self setValue:ivars[key] forKey:key];
		}
	}
	return self;
}

- (NSDictionary *)ivars
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    unsigned int outCount;
	
    Ivar* ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i++){
        Ivar ivar = ivars[i];
        NSString* ivarNameString = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSValue* value = [self valueForKey:ivarNameString];
        if (value) {
            [dict setValue:value forKey:ivarNameString];
        }
    }
	
    free(ivars);
    return dict;
}

@end
