//
//  CMP25Drawing.m
//
//  Created by Chris Manahan on 8/18/14.
//  Copyright (c) 2014 Chris Manahan. All rights reserved.
//

#import "CMP25Drawing.h"

@interface CMP25Drawing ()
{
    int **_binary;
    
    int _width;
    int _height;
    
    int _pointsDrawn;
    
    CGPoint _currentPoint;
}

@end

@implementation CMP25Drawing

- (void)startDrawingWithSize:(CGSize)size;
{
    uint16_t x = size.width;
    uint16_t y = size.height;

    _width     = x;
    _height    = y;
    
    _binary = NULL;
    _binary = malloc(y * sizeof(int));
    
    for (int i = 0; i < y; i++)
    {
        _binary[i] = malloc(x*8 * sizeof(int));
        for (int j = 0; j < x*8; j++)
        {
            _binary[i][j] = 0;
        }
    }
}

- (void)moveToPoint:(CGPoint)pt;
{
    NSLog(@"beginning new path");
    _currentPoint = pt;
    
    int x = _currentPoint.x;
    int y = _currentPoint.y;
    _binary[y][x] = 1;
    
    _currentPoint = pt;
    _pointsDrawn++;
}

-(void)addLineTo:(CGPoint)pt;
{
    [self p_drawLineFrom:_currentPoint to:pt];

    _currentPoint = pt;
    _pointsDrawn++;
}

- (NSArray*)stopDrawing;
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 0; i < _height; i++)
    {
        for (int j = 0; j < _width*8; j+=8)
        {
            int *binPtr = &_binary[i][j];
            uint16_t num = 0;
            for (int k = 0; k < 8; k++)
            {
                int b = *binPtr == 1 ? 1 : 0;
                num = (num << 1) | b;
                binPtr++;
            }
            
            [temp addObject:@(num)];
        }
    }
    
    return (NSArray*)temp;
}

#pragma mark - Private
-(void)p_drawLineFrom:(CGPoint)start to:(CGPoint)end
{
    /*
        Algorithm adapted from David Brackeen
        http://www.brackeen.com/vga/shapes.html
     */
    int dx,dy,sdx,sdy,px,py,dxabs,dyabs,i;
    float slope;
    
    int x1 = start.x;
    int y1 = start.y;
    int x2 = end.x;
    int y2 = end.y;
    
    dx    = x2-x1;/* the horizontal distance of the line */
    dy    = y2-y1;/* the vertical distance of the line */
    dxabs = abs(dx);
    dyabs = abs(dy);
    sdx   = [self p_signOfInteger:dx];
    sdy   = [self p_signOfInteger:dy];
    if (dxabs >= dyabs) /* the line is more horizontal than vertical */
    {
        slope = (float)dy / (float)dx;
        for(i = 0; i != dx; i += sdx)
        {
            px             = i + x1;
            py             = slope * i + y1;
            _binary[py][px] = 1;
        }
    }
    else /* the line is more vertical than horizontal */
    {
        slope = (float)dx / (float)dy;
        for(i = 0; i != dy; i += sdy)
        {
            px             = slope * i + x1;
            py             = i + y1;
            _binary[py][px] = 1;
        }
    }
}

- (int)p_signOfInteger:(int)integer {
    if (integer != 0) {
        integer = (integer < 0) ? -1 : +1;
    }
    return integer;
}


@end
