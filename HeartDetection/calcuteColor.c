//
//  calcuteColor.c
//  heartDetection
//
//  Created by hundred wang on 17/5/2.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#include "calcuteColor.h"
#include <math.h>

/**
 将RGB转换为HSV来表示和计算
 
 @param color color
 @return HSV 转换后的hsv
 */
HSV conversionRGBtoHSV(Color color){
    
    double max = fmax((fmax(color.r, color.b)), color.g);
    double min = fmin((fmin(color.r, color.b)), color.g);
    HSV hsv = {0, 0, 0};
    
    if (max == min) hsv.h = 0;
    else if (max == color.r && color.g >= color.b) hsv.h = 60 * ((color.g - color.b) / (max - min));
    else if (max == color.r && color.g < color.b) hsv.h = 60 * ((color.g - color.b) / (max - min)) + 360;
    else if (max == color.g) hsv.h = 60 * ((color.b - color.r) / (max - min)) + 120;
    else if (max == color.b) hsv.h = 60 * ((color.r - color.g) / (max - min)) + 240;
    
    if (max == 0) hsv.s = 0;
    else hsv.s = (1 - min / max);
    
    hsv.v = max;
    
    return hsv;
}

void TORGB (uint8_t *buf, float width, float height, size_t pr, Color *color){
    float size = (float)(width * height);
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width * 4; x += 4) {
            (*color).r += buf[x];
            (*color).g += buf[x + 1];
            (*color).b += buf[x + 2];
        }
        buf += pr;
    }
    (*color).r /= size;
    (*color).g /= size;
    (*color).b /= size;
}

void conversionBytesToHSV(uint8_t * buf, float width, float height, size_t pr, HSV *hsv){
    Color color = {0, 0, 0};
    TORGB(buf, width, height, pr, &color);
    *hsv = conversionRGBtoHSV(color);
}



