//
//  PFGeoPoint+NSCoding.h
//  PrecoJusto
//
//  Created by Pedro Almeida on 5/1/14.
//
//

#import <Parse/Parse.h>

@interface PFGeoPoint (NSCoding)

- (void)encodeWithCoder:(NSCoder*)encoder;
- (id)initWithCoder:(NSCoder*)aDecoder;

@end
