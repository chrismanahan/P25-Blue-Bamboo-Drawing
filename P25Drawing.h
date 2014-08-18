//
//  CMP25Drawing.h
//
//  Created by Chris Manahan on 8/18/14.
//  Copyright (c) 2014 Chris Manahan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  This is a quick implementation to draw lines from points to the Blue Bamboo P25 printer. A sample use is to draw signature from collected points. You are responsible to for settings the commands in your printer's buffer, this class only produces the data.
 */
@interface CMP25Drawing : NSObject

/*!
 *  Begins the drawing process
 *
 *  @param size Size of your canvas
 */
- (void)startDrawingWithSize:(CGSize)size;

/*!
 *  Moves buffer to given point. Adds a dot at that point and gets ready to draw new line
 *
 *  @param pt Point to start at
 */
- (void)moveToPoint:(CGPoint)pt;

/*!
 *  Adds a line from the previous point to the given point
 *
 *  @param pt Point to draw to
 */
- (void)addLineTo:(CGPoint)pt;

/*!
 *  Finishes drawing and returns an array of ints to append to your printer's buffer in order
 *
 *  @return Array of NSNumber ints that can be appended to your printer buffer
 */
- (NSArray*)stopDrawing;

@end
