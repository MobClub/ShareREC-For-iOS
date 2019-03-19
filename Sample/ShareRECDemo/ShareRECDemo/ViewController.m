//
//  ViewController.m
//  ShareRECDemo
//
//  Created by 冯 鸿杰 on 14-12-18.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES2/glext.h>
#import <ShareREC/ShareREC.h>
#import <ShareRECSocial/ShareRECSocial.h>
#import <AVFoundation/AVFoundation.h>
#import <ShareREC/ShareREC+RecordingManager.h>
#import <ShareREC/SRERecording.h>
#import <ShareRECSocial/ShareRECSocial+Ext.h>

#import <ShareSDKUI/ShareSDKUI.h>

#define BUTTON_HEIGHT 45

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

typedef enum {
    RECORD_INVALID = 0,
    RECORD_START = 1,
    RECORD_STOP  = 2,
    RECORD_PUASE = 3,
    RECORD_RESUME = 4,
} RecordState;

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

GLfloat gCubeVertexData[216] = 
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};

@interface ViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    AVAudioPlayer                       *_audioPlayer;
    
    RecordState currentState;
    
    UIButton * _recordButton; //录像启动、停止
    UIButton * _stateButton;  //录像暂停、恢复
    UIButton * _shareButton;  //分享
    UIButton * _editButton;   //编辑
    UIButton * _playButton;   //播放
    UIButton * _getRecListButton;//获取本地视频列表
    UIButton * _deleteRecListButton; //删除本地视频列表
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"_" withExtension:@"mp3"] error:NULL];
    _audioPlayer.numberOfLoops = -1;
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setTitle:@"开始录制" forState:UIControlStateNormal];
    [_recordButton setTitle:@"结束录制" forState:UIControlStateSelected];
    [_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton setBackgroundColor:[UIColor yellowColor]];
    _recordButton.frame = CGRectMake(10, 20, self.view.frame.size.width - 20, BUTTON_HEIGHT);
    [self.view addSubview:_recordButton];
    
    _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stateButton setTitle:@"暂停录制" forState:UIControlStateNormal];
    [_stateButton setTitle:@"恢复录制" forState:UIControlStateSelected];
    [_stateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_stateButton addTarget:self action:@selector(stateButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_stateButton setBackgroundColor:[UIColor redColor]];
    _stateButton.frame = CGRectMake(10, _recordButton.frame.origin.y + _recordButton.frame.size.height, self.view.frame.size.width - 20, BUTTON_HEIGHT);
    [self.view addSubview:_stateButton];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setBackgroundColor:[UIColor greenColor]];
    _shareButton.frame = CGRectMake(10, _stateButton.frame.origin.y + _stateButton.frame.size.height, self.view.frame.size.width - 20, BUTTON_HEIGHT);
    [self.view addSubview:_shareButton];
    
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(editButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_editButton setBackgroundColor:[UIColor orangeColor]];
    _editButton.frame = CGRectMake(10, _shareButton.frame.origin.y + _shareButton.frame.size.height, self.view.frame.size.width - 20, BUTTON_HEIGHT);
    [self.view addSubview:_editButton];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setTitle:@"播放" forState:UIControlStateNormal];
    [_playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setBackgroundColor:[UIColor brownColor]];
    _playButton.frame = CGRectMake(10, _editButton.frame.origin.y + _editButton.frame.size.height, self.view.frame.size.width - 20, BUTTON_HEIGHT);
    [self.view addSubview:_playButton];
    
    _getRecListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getRecListButton setTitle:@"获取" forState:UIControlStateNormal];
    [_getRecListButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_getRecListButton addTarget:self action:@selector(getRecordListClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_getRecListButton setBackgroundColor:[UIColor purpleColor]];
    _getRecListButton.frame = CGRectMake(10, _playButton.frame.origin.y + _playButton.frame.size.height, self.view.frame.size.width - 20, BUTTON_HEIGHT);
    [self.view addSubview:_getRecListButton];
    
    _deleteRecListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteRecListButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteRecListButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_deleteRecListButton addTarget:self action:@selector(deleteRecordClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteRecListButton setBackgroundColor:[UIColor darkGrayColor]];
    _deleteRecListButton.frame = CGRectMake(10, _getRecListButton.frame.origin.y + _getRecListButton.frame.size.height, self.view.frame.size.width - 20, BUTTON_HEIGHT);
    [self.view addSubview:_deleteRecListButton];
    
    currentState = RECORD_INVALID;
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    
    // Compute the model view matrix for the object rendered with GLKit
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    // Compute the model view matrix for the object rendered with ES2
    modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // Render the object with GLKit
    [self.effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    // Render the object again with ES2
    glUseProgram(_program);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - click handler
//录像开始、结束
- (void)recordButtonClickHandler:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        currentState = RECORD_START;
        //开始录制视频
        [ShareREC startRecording];
        
    }
    else
    {
        if (currentState == RECORD_PUASE) {
            
            [self stateButtonClickHandler:nil];
        }
        currentState = RECORD_STOP;
        
        //结束录制视频
        [ShareREC stopRecording:^(NSError *error) {
            
            if (!error)
            {
                //结束后编辑视频
                [ShareRECSocial openByTitle:@"这是一个测试视频录像的Demo"
                                   userData:@{@"游戏元素" : @"元素值"}
                                   pageType:ShareRECSocialPageTypeShare
                                    onClose:nil shareResult:^(SREShareResponseState shareState) {
                                        NSLog(@"分享状态 = %zd", shareState);
                                    }];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:error.localizedDescription
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            
            
        }];
    }
}

//录像暂停、恢复
- (void)stateButtonClickHandler:(UIButton *)sender
{
    if (sender == nil) {
        _stateButton.selected = !_stateButton.selected;
        return;
    }
    
    if (currentState == RECORD_START || currentState == RECORD_RESUME) {
        currentState = RECORD_PUASE;;
        sender.selected = !sender.selected;
        
        [ShareREC pauseRecording];
        
    }else if (currentState == RECORD_PUASE){
        currentState = RECORD_RESUME;
        sender.selected = !sender.selected;
        
        [ShareREC resumeRecording];
        
    }
}

//分享
- (void)shareButtonClickHandler:(UIButton *)sender
{
    //打开视频分享界面
    [ShareRECSocial openByTitle:@"我在游戏中得了2000分，求超越"
                       userData:@{@"score" : @(2000)}
                       pageType:ShareRECSocialPageTypeShare
                        onClose:nil];
}

//编辑
- (void)editButtonClickHandler:(UIButton *)sender
{
    [ShareREC editLastRecording:^(BOOL cancelled) {
        NSLog(@"====close");
    }];
}

//播放
- (void)playButtonClickHandler:(UIButton *)sender
{
    [ShareREC playLastRecording];
}

//获取
- (void)getRecordListClickHandler:(UIButton *)sender
{
    //获取本地视频列表
    NSArray *recordings = [ShareREC currentLocalRecordings];
    NSLog(@"本地视频 = %@", recordings);
}

- (void)deleteRecordClickHandler:(UIButton *)sender
{
    //    //清空本地视频列表
    //    [ShareREC clearLocalRecordings];
    
    //单独删除
    NSArray *recordings = [ShareREC currentLocalRecordings];
    SRERecording *recording = [recordings lastObject];
    if (recording) {
        [ShareREC deleteLocalRecording:recording];
    }
    
}

@end
