//
//  PFFile+NSCoding.m
//  UpdateZen
//
//  Created by Martin Rybak on 2/3/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import "PFFile+NSCoding.h"
#import "NSObject+introspect.h"

#define kPFFileName @"_name"
#define kPFFileIvars @"ivars"
#define kPFFileData @"data"

@implementation PFFile (NSCoding)

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:self.name forKey:kPFFileName];
	[encoder encodeObject:[self iVarsDict] forKey:kPFFileIvars];
	if (self.isDataAvailable) {
		[encoder encodeObject:[self getData] forKey:kPFFileData];
	}
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	NSString* name = [aDecoder decodeObjectForKey:kPFFileName];
	NSDictionary* ivars = [aDecoder decodeObjectForKey:kPFFileIvars];
	NSData* data = [aDecoder decodeObjectForKey:kPFFileData];
	
	self = [PFFile fileWithName:name data:data];
	if (self) {
		for (NSString* key in [ivars allKeys]) {
			[self setValue:ivars[key] forKey:key];
		}
	}
	return self;
}

@end
