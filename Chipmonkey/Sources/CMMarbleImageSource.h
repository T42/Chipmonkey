//
//  ATImageSource.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/9/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CMMarbleImageSource <NSObject>
- (UIImage*) nextImage;
- (void) imagesOnField:(NSSet*) images;
@end
