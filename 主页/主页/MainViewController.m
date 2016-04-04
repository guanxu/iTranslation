//
//  MainViewController.m
//  iTranslation
//
//  Created by 关 旭 on 14-9-27.
//  Copyright (c) 2014年 guanxu. All rights reserved.
//

#import "MainViewController.h"
#import "MainlTableViewCell.h"
#import "MakeInterface.h"
#import "APIClient.h"
#import "DataModel.h"
#import "LoadingView.h"
#import "SetUpViewController.h"

@interface MainViewController ()


@end

@implementation MainViewController

{
    //主视图列表
    UITableView         *mainTableView;
    //历史翻译数据
    NSMutableArray      *translatedArray;
    //带听写界面的识别对象
    IFlyRecognizerView  *iflyRecognizerView;
    //短提示
    PopupView           *popView;
    //识别内容
    NSString            *IFlyResultStr;
    //键盘输入框
    UITextView          *popTextView;
    //隐藏键盘按钮
    UIButton            *keyboardHidenBtn;
    //键盘工具栏
    UIToolbar           *keyboardToolbar;
    //弹出键盘高度(普通216 中文252)
    int                 keyboardHeight;
    //语言选择按钮
    UIButton            *languageBtnLeft,*languageBtnRight;
    //语言选择器
    UIPickerView        *languagePicker;
    //选择器工具栏
    UIToolbar           *pickerToolbar;
    //输入、输出语言数据源
    NSMutableArray      *inPutCodes,*inPutNames;
    NSArray             *outPutCodes,*outPutNames;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化数据
    [self initData];
    //导航栏
    [self createNavgationView];
    //讯飞识别界面
    [self createIFlyView];
    //主视图
    [self createMainView];
    //底部功能区
    [self createBottomViewWithFrame:CGRectMake(0, self.view.frame.size.height-kBottomViewHeight, self.view.frame.size.width, kBottomViewHeight)];
    //键盘输入框
    [self createTextView];
    //语言选择器
    [self createPickerView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //存储翻译列表数据
    NSData *savedTranslteList = [MakeInterface getAsynchronousWithKey:@"翻译记录"];
    if(savedTranslteList == nil){
        translatedArray = [[NSMutableArray alloc] init];
    }else{
        translatedArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedTranslteList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化数据
- (void)initData
{
    //初始化讯飞识别结果
    IFlyResultStr = @"";
    
    //读取输入语言列表 code作为图片标示
    NSString *inPutPath = [[NSBundle mainBundle] pathForResource:@"InPutLanguage" ofType:@"plist"];
    NSDictionary *inPutDic = [[NSDictionary alloc] initWithContentsOfFile:inPutPath];
    inPutCodes = [[NSMutableArray alloc] init];
    [inPutCodes addObject:@"auto"];
    [inPutCodes addObjectsFromArray:[inPutDic allKeys]];
    inPutNames = [[NSMutableArray alloc] init];
    [inPutNames addObject:@"自动语言检测"];
    [inPutNames addObjectsFromArray:[inPutDic allValues]];
    
    //读取输出语言列表 code作为图片标示
    NSString *outPutPath = [[NSBundle mainBundle] pathForResource:@"OutPutLanguage" ofType:@"plist"];
    NSDictionary *outPutDic = [[NSDictionary alloc] initWithContentsOfFile:outPutPath];
    outPutCodes = [outPutDic allKeys];
    outPutNames = [outPutDic allValues];
}

#pragma mark - 导航栏
- (void)createNavgationView
{
    //不透明
    self.navigationController.navigationBar.translucent = YES;
    //背景
    self.view.backgroundColor = GColor(242, 242, 242);
    //右侧按钮
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:[MakeInterface createRightBtnWithImageName:@"setting" Target:self selector:@selector(pushSetUp)]];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}
#pragma mark - 设置
- (void)pushSetUp
{
    SetUpViewController *setUpView = [[SetUpViewController alloc] init];
    [self.navigationController pushViewController:setUpView animated:YES];
}

#pragma mark - 识别界面
- (void)createIFlyView
{
    //短提示
    popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
    popView.ParentView = self.view;
    
    //创建语音听写的对象
    iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    
    //delegate需要设置，确保delegate回调可以正常返回
    iflyRecognizerView.delegate = self;
}

#pragma mark - 键盘输入框
- (void)createTextView
{
    //输入框
    popTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 120+(iPhone5?88:0))];
    popTextView.textColor = [UIColor blackColor];
    popTextView.font = [UIFont fontWithName:@"Arial" size:18];
    popTextView.delegate = self;
    popTextView.backgroundColor = [UIColor whiteColor];
    popTextView.returnKeyType = UIReturnKeyDefault;
    popTextView.keyboardType = UIKeyboardTypeDefault;
    popTextView.scrollEnabled = YES;
    popTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:popTextView];
    //工具栏
    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 44)];
    [self.view addSubview:keyboardToolbar];
    //完成
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:1];
    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardHide)];
    [items addObject:confirmBtn];
    keyboardToolbar.items = items;
    //注册键盘通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow:)
                          name:UIKeyboardWillShowNotification
                        object:nil];
}

#pragma mark - 主视图
- (void)createMainView
{
    //列表
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kBottomViewHeight) style:UITableViewStylePlain];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundView = nil;
    mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainTableView];

}

#pragma mark - 底部功能区
- (void)createBottomViewWithFrame:(CGRect)frame
{
    //背景图
    UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
    backgroundView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:backgroundView];
    //左右声控、键盘按钮
    for(int i=0;i<2;i++){
        UIButton *inputBtn = [MakeInterface createCommonButtonWithFrame:CGRectMake(20+240*i, 10, 40, 40) tag:i target:self selector:@selector(keyboardShow:)];
        [inputBtn setImage:[UIImage imageNamed:@"speak"] forState:UIControlStateNormal];
        [backgroundView addSubview:inputBtn];
        //button长按事件
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(voiceStart:)];
        longPress.minimumPressDuration = 0.5; //定义按的时间
        [inputBtn addGestureRecognizer:longPress];
    }
    //语言选择按钮
    languageBtnLeft = [MakeInterface createCommonButtonWithFrame:CGRectMake(75, 10, 40, 40) tag:0 target:self selector:@selector(languageChoice)];
    languageBtnRight = [MakeInterface createCommonButtonWithFrame:CGRectMake(200, 10, 40, 40) tag:0 target:self selector:@selector(languageChoice)];
    [languageBtnLeft setImage:[UIImage imageNamed:@"zh"] forState:UIControlStateNormal];
    [languageBtnRight setImage:[UIImage imageNamed:@"en"] forState:UIControlStateNormal];
    [backgroundView addSubview:languageBtnLeft];
    [backgroundView addSubview:languageBtnRight];
    //语言交换
    UIButton *languageChangeBtn = [MakeInterface createCommonButtonWithFrame:CGRectMake((320-40)>>1, 10, 40, 40) tag:0 target:self selector:@selector(languageChange)];
    [languageChangeBtn setImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    [backgroundView addSubview:languageChangeBtn];
    
}

#pragma mark - 选择器
- (void)createPickerView
{
    //语言选择
    languagePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 200+(iPhone5?88:0))];
    languagePicker.delegate = self;
    languagePicker.backgroundColor = [UIColor whiteColor];
    languagePicker.showsSelectionIndicator = YES;
    [languagePicker selectRow:11 inComponent:0 animated:YES];
    [languagePicker selectRow:9 inComponent:1 animated:YES];
    [self.view addSubview:languagePicker];
    //工具栏
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, languagePicker.frame.origin.y, 320, 44)];
    [self.view addSubview:pickerToolbar];
    //确定 取消
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(pickerConfirm)];
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerHide)];
    [items addObject:cancelBtn];
    [items addObject:flexibleSpaceItem];
    [items addObject:confirmBtn];
    pickerToolbar.items = items;
    
}

#pragma mark - 语言选择
- (void)languageChoice
{
    //弹出语言选择器
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        languagePicker.frame = CGRectMake(0, self.view.frame.size.height-languagePicker.frame.size.height, 320, 200+(iPhone5?88:0));
        pickerToolbar.frame = CGRectMake(0, languagePicker.frame.origin.y - 44, 320, 44);
    }];
}

#pragma mark - 确认
- (void)pickerConfirm
{
    //设置语言图片
    NSInteger inputRow = [languagePicker selectedRowInComponent:0];
    NSString *inPutCode = [inPutCodes objectAtIndex:inputRow];
    [languageBtnLeft setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",inPutCode]] forState:UIControlStateNormal];
    
    NSInteger outputRow = [languagePicker selectedRowInComponent:1];
    NSString *outputCode = [outPutCodes objectAtIndex:outputRow];
    [languageBtnRight setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",outputCode]] forState:UIControlStateNormal];
    
    //隐藏
    [self pickerHide];
}

#pragma mark - 取消
- (void)pickerHide
{
    //隐藏语言选择器
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        languagePicker.frame = CGRectMake(0, self.view.frame.size.height, 320, 200+(iPhone5?88:0));
        pickerToolbar.frame = CGRectMake(0, languagePicker.frame.origin.y, 320, 44);
    }];
}


#define kCanVocieCodeArray @[@"zh",@"en"]
#pragma mark - 检测是否支持语音录入
- (BOOL)canVoiceWithIndex:(int)index
{
    BOOL flag = NO;
    //得到左右两边选择的语言
    NSInteger inputRow = [languagePicker selectedRowInComponent:0];
    NSString *inPutCode = [inPutCodes objectAtIndex:inputRow];
    NSInteger outputRow = [languagePicker selectedRowInComponent:1];
    NSString *outputCode = [outPutCodes objectAtIndex:outputRow];
    //目前仅支持中、英语音输入 zh、en
    if(index == 0){
        //长按左边
        if([kCanVocieCodeArray containsObject:inPutCode]){
            flag = YES;
        }else{
            [self.view addSubview:popView];
            [popView setText:@"所选语种暂不支持语音识别"];
        }
    }else{
        //长按右边
        if([kCanVocieCodeArray containsObject:outputCode]){
            flag = YES;
        }else{
            [self.view addSubview:popView];
            [popView setText:@"所选语种暂不支持语音识别"];
        }
    }
    return flag;
}

#pragma mark - 声音识别开始
- (void)voiceStart:(id)sender
{
    //检测是否支持语音录入
    if(![self canVoiceWithIndex:((UIButton *)[sender view]).tag]){
        return;
    }
    [iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //设置结果数据格式，可设置为json，xml，plain，默认为json。
    [iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    [iflyRecognizerView start];
}

#pragma mark IFlyRecognizerViewDelegate

/** 识别结果回调方法
 @param resultArray 结果列表
 @param isLast YES 表示最后一个，NO表示后面还有结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    
    //解析识别结果
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    IFlyResultStr = [NSString stringWithFormat:@"%@%@",IFlyResultStr,result];
    //回调若干次 所有内容拼接后请求翻译接口
    if(isLast){
        [self requestTranslateAPIWithStr:IFlyResultStr];
        IFlyResultStr = @"";
    }
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    //显示错误信息
    if(error.errorCode!=0){
        [self.view addSubview:popView];
        [popView setText:error.errorDesc];
    }
}

#pragma mark - 弹出键盘
- (void)keyboardShow:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [popTextView becomeFirstResponder];
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            popTextView.frame = CGRectMake(0, 65, self.view.frame.size.width, 120+(iPhone5?88:0));
        }];
    }
}

#pragma mark - 弹出键盘通知
- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    //获取键盘高度
    keyboardHeight = keyboardSize.height;
    //弹出隐藏键盘按钮
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        keyboardToolbar.frame = CGRectMake(0, self.view.frame.size.height-keyboardHeight-44, 320, 44);
    }];
}

#pragma mark - 隐藏键盘
- (void)keyboardHide
{
    [popTextView resignFirstResponder];
    //关闭键盘
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        popTextView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 120+(iPhone5?88:0));
        keyboardToolbar.frame = CGRectMake(0, self.view.frame.size.height, 320, 44);
    }];
    
    //联网
    if(popTextView.text.length>0){
        [self requestTranslateAPIWithStr:popTextView.text];
    }
    popTextView.text = @"";
    
}

#pragma mark - 请求翻译接口
- (void)requestTranslateAPIWithStr:(NSString *)str
{
    [[LoadingView sharedLoadingView] loadingViewInView:self.view];
    //选择的语言
    NSString *inputSelectedStr = [inPutCodes objectAtIndex:[languagePicker selectedRowInComponent:0]];
    NSString *outputSelectedStr = [outPutCodes objectAtIndex:[languagePicker selectedRowInComponent:1]];
    //提交参数
    NSDictionary *paramet = @{@"client_id": API_KEY,
                              @"from":      inputSelectedStr,
                              @"to":        outputSelectedStr,
                              @"q":         str};
    //请求
    [[APIClient sharedClient] requestPath:TRANSLATE_URL
                               parameters:paramet
                                  success:^(AFHTTPRequestOperation *operation, id JSON)
     //成功回调
     {
         //解析数据
         if (![JSON isKindOfClass:[NSDictionary class]]) {
             //联网结束 刷新列表
             [self requestEnd];
             [self.view addSubview:popView];
             [popView setText:@"数据类型错误"];
             return ;
         }
         if(![JSON objectForKey:@"error_code"]){
             GLog(@"接口请求成功!");
             NSArray *result = [JSON objectForKey:@"trans_result"];
             //数据格式错误
             if (![result isKindOfClass:[NSArray class]] || [result count] == 0) {
                 //联网结束 刷新列表
                 [self requestEnd];
                 [self.view addSubview:popView];
                 [popView setText:@"数据格式错误"];
                 return ;
             }
             //存到实体中
             for (NSDictionary *d in result)
             {
                 TranslateResult *result = [TranslateResult newsItemWithDict:d];
                 [translatedArray addObject:result];
             }
             //持久化存储
             [self saveTranslateList];
         }else{
             [self.view addSubview:popView];
             [popView setText:@"没能翻译成功，再试一次吧"];
         }
         //联网结束 刷新列表
         [self requestEnd];
         
         
     }
     //失败回调
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.view addSubview:popView];
         [popView setText:@"网络有问题了"];
         //联网结束 刷新列表
         [self requestEnd];
     }];
    
    
}

#pragma mark - 结束请求
- (void)requestEnd
{
    //刷新列表
    [mainTableView reloadData];
    [[LoadingView sharedLoadingView] removeView];
}

#pragma mark - 存储翻译记录
- (void)saveTranslateList
{
    //NSUserDefaults 不能存储自定义类型 将translatedArray转化成NSData 同时translatedArray中保存的对象必须遵守NSCoding协议
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:translatedArray];
    [MakeInterface setAsynchronous:data WithKey:@"翻译记录"];
}

#pragma mark - 交换当前语言
- (void)languageChange
{
}

#pragma mark -
#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return translatedArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"MainlTableViewCell";
    MainlTableViewCell *cell = (MainlTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MainlTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    //布局
    [cell layoutWithResult:[translatedArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //滑动删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [translatedArray removeObjectAtIndex:indexPath.row];
        [self saveTranslateList];
        [mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark
#pragma mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //弹出键盘
    [UIView animateWithDuration:ANIMATION_TIME animations:^{

    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:ANIMATION_TIME animations:^{

    }];
}
- (void)textViewDidChange:(UITextView *)textView
{
    
}

#pragma mark 
#pragma mark - UIPickerView delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return inPutCodes.count;
    }else{
        return outPutCodes.count;
    }
}
//显示
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //麦克风
    UIImageView *micView;
    if (!view){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        //语言
        UILabel *languageLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, 115, 24)];
        languageLabel.backgroundColor = [UIColor clearColor];
        [view addSubview:languageLabel];
        //国旗
        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 24, 24)];
        flagView.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:flagView];
        //麦克风
        micView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"microphone"]];
        micView.frame = CGRectMake(110, 3, 24, 24);
        micView.hidden = YES;
        [view addSubview:micView];
    }
    //显示图片
    if(component == 0){
        [(UILabel *)[view.subviews objectAtIndex:0] setText:[inPutNames objectAtIndex:row]];
        UIImage *flag = [UIImage imageNamed:[[inPutCodes objectAtIndex:row] stringByAppendingPathExtension:@"png"]];
        [(UIImageView *)[view.subviews objectAtIndex:1] setImage:flag];
        //显示麦克风图标
        if([[inPutCodes objectAtIndex:row] isEqualToString:@"en"]||[[inPutCodes objectAtIndex:row] isEqualToString:@"zh"]){
            micView.hidden = NO;
        }
    }else{
        [(UILabel *)[view.subviews objectAtIndex:0] setText:[outPutNames objectAtIndex:row]];
        UIImage *flag = [UIImage imageNamed:[[outPutCodes objectAtIndex:row] stringByAppendingPathExtension:@"png"]];
        [(UIImageView *)[view.subviews objectAtIndex:1] setImage:flag];
        //显示麦克风图标
        if([[outPutCodes objectAtIndex:row] isEqualToString:@"en"]||[[outPutCodes objectAtIndex:row] isEqualToString:@"zh"]){
            micView.hidden = NO;
        }
    }
    return view;
}
//点击
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}





@end
