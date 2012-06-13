//
//  GraffleBezierView.h
//  GraffleReader
//
//  Created by Carsten Müller on 19/01/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BezierDrawView,TGZoomingScrollView;
@interface GraffleBezierViewController : NSViewController {

  IBOutlet BezierDrawView *         _drawingView;
  IBOutlet TGZoomingScrollView *    _scrollView;
  CGFloat                           _zoomFactor;
}

@property (assign) BezierDrawView *drawingView;
@property (assign) TGZoomingScrollView *scrollView;
@property CGFloat zoomFactor;
@end
