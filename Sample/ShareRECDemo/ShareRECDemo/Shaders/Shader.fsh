//
//  Shader.fsh
//  ShareRECDemo
//
//  Created by 冯 鸿杰 on 14-12-18.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
