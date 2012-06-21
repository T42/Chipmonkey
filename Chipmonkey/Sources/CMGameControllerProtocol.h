//
//  CMGameControllerProtocol.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/17/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#ifndef Chipmonkey_CMGameControllerProtocol_h
#define Chipmonkey_CMGameControllerProtocol_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CMGameControllerProtocol <NSObject>

@property (assign,nonatomic) NSUInteger framerate,simulationrate,timescale;

- (IBAction)startLevel:(id)sender;
- (IBAction)cancelLevel:(id)sender;
- (IBAction)finishLevel:(id)sender;
@end



#endif
