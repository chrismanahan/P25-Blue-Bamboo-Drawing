CMP25Drawing
============

This is a quick implementation to draw lines from points to the Blue Bamboo P25 printer. You can use this to draw line images to the P25. An example of usage:

```
-(void)addSignatureFromPoints:(NSArray*)sigPoints
{
    uint16_t x = 0X19;
    uint16_t y = 0X46;
    
    printBuffer[bufferPtr++] = 0x1B;  // COMMAND
    printBuffer[bufferPtr++] = 0X58;  // COMMAND
    printBuffer[bufferPtr++] = 0X34;  // COMMAND
    printBuffer[bufferPtr++] = x;  // X
    printBuffer[bufferPtr++] = y;  // Y
    
    CMP25Drawing *drawing = [[CMP25Drawing alloc] init];
    [drawing startDrawingWithSize:CGSizeMake(x, y)];
    
    int pointsDrawn = 0;
    BOOL beginNewPath = NO;
    for (NSValue *val in sigPoints)
    {
        CGPoint pt = [val CGPointValue];
        if (pt.y > 60000)
        {
            beginNewPath = YES;
            continue;
        }

        if (!pointsDrawn || beginNewPath)
        {
            [drawing moveToPoint:pt];
            beginNewPath = NO;
        }
        else
        {
            [drawing addLineTo:pt];
        }
        
        pointsDrawn++;
        
    }
    
    NSArray *nums = [drawing stopDrawing];
    for (NSNumber *num in nums)
    {
        int n = [num intValue];
        printBuffer[bufferPtr++] = n;
    }

}
```

This example method is in my class that handles the P25 printing. The argument `sigPoints` is an array of NSValue CGPoints that make up the signature