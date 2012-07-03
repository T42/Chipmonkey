//
//  CMLayerStackView.h
//  Chipmonkey
//
//  Created by Carsten Müller on 7/3/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLayerStackView : UIView

- (void) pushLayer:(CALayer*) aLayer;
- (CALayer*) popLayer;
- (void) clearStack;
@end
