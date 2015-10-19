//
//  geometry.hpp
//  openCVTest
//
//  Created by 김운하 on 2015. 10. 19..
//  Copyright © 2015년 bnsworks. All rights reserved.
//


#include <math.h>

bool nearPoint(int a_x, int a_y, int b_x, int b_y, float ab_bg_x, float ab_bg_y){
    float xx=(a_x-b_x)/ab_bg_x;
    float yy=(a_y-b_y)/ab_bg_y;
    bool result;
    
    if (sqrt(pow(xx,2)+pow(yy,2))<0.1){
        result=true;
    }else{
        result=false;
    }
        return result;
}
