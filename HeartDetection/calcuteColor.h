//
//  calcuteColor.h
//  heartDetection
//
//  Created by hundred wang on 17/5/2.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#ifndef calcuteColor_h
#define calcuteColor_h

#include <stdio.h>

typedef struct Color {
    double r;
    double g;
    double b;
}Color;

typedef struct HSV{
    double h;
    double s;
    double v;
}HSV;

HSV conversionRGBtoHSV(Color color);

void conversionBytesToHSV(uint8_t * buf, float width, float height, size_t pr, HSV *hsv);

#endif /* calcuteColor_h */
