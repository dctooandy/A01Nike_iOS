//
//  PublicMethod.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "PublicMethod.h"
#import "AppDelegate.h"

@implementation PublicMethod

/**
 *获取当前window的根控制器
 */
+(UIViewController *)getRootViewController
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.window.rootViewController;
}


/**
 *根据控制器名字获得其对于的控制器
 */
+(UIViewController *)getVCByItsClassName:(NSString *)className
{
    //循环遍历tabbar的自控制器
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabBarVC = (UITabBarController*)appDelegate.window.rootViewController;
        for (UINavigationController * navVC in tabBarVC.viewControllers) {
            for (UIViewController * temVC in navVC.viewControllers) {
                if ([temVC isKindOfClass:NSClassFromString(className)]) {
                    return temVC;
                }
            }
        }
    }
    return nil;
}

/**
 *获取当前选中的导航控制器
 */
+ (UINavigationController *)getCurrentNavVC
{
    //循环遍历tabbar的自控制器
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabBarVC = (UITabBarController*)appDelegate.window.rootViewController;
        UINavigationController * navVC = tabBarVC.childViewControllers[tabBarVC.selectedIndex];
        return [navVC isKindOfClass:[UINavigationController class]] ? navVC : nil;
    }
    return nil;
}

/**
 *获取当前屏幕显示的viewcontroller
 */
+(UIViewController *)getCurrentVC
{
    UIViewController * result = nil;
    UIViewController * rootVC = [PublicMethod getRootViewController];
    if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        result = ((UINavigationController *)rootVC).visibleViewController;
    }
    else if ([rootVC isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbarVC = (UITabBarController*)rootVC;
        UIViewController * tabbarSelectVC = [tabbarVC.childViewControllers objectAtIndex:tabbarVC.selectedIndex];
        if ([tabbarSelectVC isKindOfClass:[UINavigationController class]]) {
            result = ((UINavigationController *)tabbarSelectVC).visibleViewController;
        }
    }
    return result;
}

/**
 * 获取当前顶层窗口
 */
+ (UIWindow *)getTopWindow {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 300)];
    aView.backgroundColor = [UIColor redColor];
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    return window;
}


/**
 获取当前的window
 
 @return 当前的window
 */
+ (UIWindow *)currentWindow {
    return [UIApplication sharedApplication].delegate.window;
}



#pragma mark - 字典与字符串互相转换

/**
 *NSString转JSON
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *JSON转NSString
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                         
                                                        options:NSJSONWritingPrettyPrinted
                         
                                                          error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+ (CGSize)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font:(CGFloat)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    
    return rect.size;
}


/**
 * 生成随机数
 */
+ (NSString *)generateUUID {
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    
    return result;
}

/**
 * 创建指定名字的文件夹
 * 路径如下
 * /Documents/FlyingPigeon/(工号)/fileName
 * fileName:音视频、数据库等文件所在目录的名字。
 * 保证不同用户登录的时候，自动切换到其工号所对应的文件夹目录下
 */
+ (NSString *)createDirectoryWithFileName:(NSString *)fileName userName:(NSString *)userName {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * appName = @"A01";
    NSString * tempPath = [[array objectAtIndex:0] stringByAppendingPathComponent:appName];
    tempPath = [tempPath stringByAppendingPathComponent:userName];
    NSString * path = [tempPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        NSError *error = nil;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if(error){
            NSLog(@"%@",error);
        }
        return path;
    }
    return path;
}

/**
 某个时间和当前时间比较是否超过时间间隔
 @param timeInterval 时间间隔
 @param time 要比较的时间
 @return 比较的结果
 */
+ (BOOL)compareCurrentTimeinterval:(NSInteger)timeInterval compareTime:(NSTimeInterval)time {
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970] ;
    if (nowTime - timeInterval > timeInterval) {
        return NO;
    }
    return YES;
}



+ (NSString*)getPreferredLanguage {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    NSLog(@"当前语言:%@", preferredLang);
    return preferredLang;
}


static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (NSData *)dataFromBase64String:(NSString *)base64 {
    if (base64 && ![base64 isEqualToString:@""]) {
        if (base64 == nil || [base64 length] == 0)
            return nil;
        
        static char *decodingTable = NULL;
        if (decodingTable == NULL)
        {
            decodingTable = (char *)malloc(256);
            if (decodingTable == NULL)
                return nil;
            memset(decodingTable, CHAR_MAX, 256);
            NSUInteger i;
            for (i = 0; i < 64; i++)
                decodingTable[(short)encodingTable[i]] = i;
        }
        
        const char *characters = [base64 cStringUsingEncoding:NSASCIIStringEncoding];
        if (characters == NULL)     //  Not an ASCII string!
            return nil;
        char *bytes = (char *)malloc((([base64 length] + 3) / 4) * 3);
        if (bytes == NULL)
            return nil;
        NSUInteger length = 0;
        
        NSUInteger i = 0;
        while (YES)
        {
            char buffer[4];
            short bufferLength;
            for (bufferLength = 0; bufferLength < 4; i++)
            {
                if (characters[i] == '\0')
                    break;
                if (isspace(characters[i]) || characters[i] == '=')
                    continue;
                buffer[bufferLength] = decodingTable[(short)characters[i]];
                if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
                {
                    free(bytes);
                    return nil;
                }
            }
            
            if (bufferLength == 0)
                break;
            if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
            {
                free(bytes);
                return nil;
            }
            
            //  Decode the characters in the buffer to bytes.
            bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
            if (bufferLength > 2)
                bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
            if (bufferLength > 3)
                bytes[length++] = (buffer[2] << 6) | buffer[3];
        }
        
        bytes = (char *)realloc(bytes, length);
        NSData *data = [NSData dataWithBytesNoCopy:bytes length:length];
        
        return data;
        //        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return nil;
    }
}

/**
 *  @return 当前时间距1970年的毫秒数
 */
+ (NSString *)timeIntervalSince1970 {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *mid = [NSString stringWithFormat:@"%lld",(unsigned long long)time];
    
    return mid;
}

+ (int)second:(NSDate *)date_ {
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitSecond];
    return ordinality;
}

+ (int)minute:(NSDate *)date_
{
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitMinute];
    return ordinality;
}

+ (int)hour:(NSDate *)date_
{
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitHour];
    return ordinality;
}

+ (int)day:(NSDate *)date_
{
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitDay];
    return ordinality;
}

+ (int)month:(NSDate *)date_
{
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitMonth];
    return ordinality;
}

+ (int)year:(NSDate *)date_
{
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitYear];
    return ordinality;
}

+ (BOOL)isDateToday:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    //[cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitDay
                         startDate:&start
                          interval:&extends
                           forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isDateYesterday:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *yesterday=[NSDate dateWithTimeIntervalSinceNow:-86400];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitDay
                         startDate:&start
                          interval:&extends
                           forDate:yesterday];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else{
        return NO;
    }
}

/* 判断date_是否在当前星期 */
+ (BOOL)isDateThisWeek:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    [cal setFirstWeekday:2];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
                         startDate:&start
                          interval:&extends
                           forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isDateThisMonth:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitMonth
                         startDate:&start
                          interval:&extends
                           forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isDateThisYear:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitYear
                         startDate:&start
                          interval:&extends
                           forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)twoDateIsSameYear:(NSDate *)fistDate_
                   second:(NSDate *)secondDate_
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    NSDateComponents *fistComponets = [calendar components:unit fromDate:fistDate_];
    NSDateComponents *secondComponets = [calendar components: unit fromDate: secondDate_];
    
    if ([fistComponets year] == [secondComponets year]){
        return YES;
    }
    return NO;
}

+ (BOOL)twoDateIsSameMonth:(NSDate *)fistDate_
                    second:(NSDate *)secondDate_
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitYear;
    NSDateComponents *fistComponets = [calendar components:unit fromDate:fistDate_];
    NSDateComponents *secondComponets = [calendar components:unit fromDate:secondDate_];
    
    if ([fistComponets month] == [secondComponets month] &&
        [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate_
                  second:(NSDate *)secondDate_
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay;
    NSDateComponents *fistComponets = [calendar components: unit fromDate:fistDate_];
    NSDateComponents *secondComponets = [calendar components: unit fromDate:secondDate_];
    
    if ([fistComponets day] == [secondComponets day] &&
        [fistComponets month] == [secondComponets month] &&
        [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    return NO;
}

+ (NSInteger)numberDaysInMonthOfDate:(NSDate *)date_
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:date_];
    
    return range.length;
}

+ (NSDate *)dateByAddingComponents:(NSDate *)date_
                  offsetComponents:(NSDateComponents *)offsetComponents_
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents_
                                                        toDate:date_
                                                       options:0];
    return endOfWorldWar3;
}

+ (NSDate *)startDateInMonthOfDate:(NSDate *)date_
{
    double interval = 0;
    NSDate *beginningOfMonth = nil;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    BOOL ok = [gregorian rangeOfUnit:NSCalendarUnitMonth
                           startDate:&beginningOfMonth
                            interval:&interval
                             forDate:date_];
    if (ok){
        return beginningOfMonth;
    }
    else{
        return nil;
    }
}

+ (NSDate *)endDateInMonthOfDate:(NSDate *)date_
{
    double interval = 0;
    NSDate *beginningOfMonth = nil;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    BOOL ok = [gregorian rangeOfUnit:NSCalendarUnitMonth
                           startDate:&beginningOfMonth
                            interval:&interval
                             forDate:date_];
    if (ok){
        NSDate *endDate = [beginningOfMonth dateByAddingTimeInterval:interval];
        return endDate;
    }
    else{
        return nil;
    }
}

- (BOOL)isDateThisWeek:(NSDate *)date
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today=[NSDate date];
    BOOL success= [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
                         startDate:&start
                          interval:&extends
                           forDate:today];
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSDate *)returnTheDayAfterThreeMouthWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    NSDateComponents *comps = nil;
    //    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:+3];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

#pragma mark - 私有方法
+ (NSInteger)ordinality:(NSDate *)date_ ordinalitySign:(NSCalendarUnit)ordinalitySign_
{
    NSInteger ordinality = -1;
    if (ordinalitySign_ < NSCalendarUnitEra || ordinalitySign_ > NSCalendarUnitWeekdayOrdinal){
        return ordinality;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:ordinalitySign_ fromDate:date_];
    
    switch (ordinalitySign_)
    {
        case NSCalendarUnitSecond:
        {
            ordinality = [components second];
            break;
        }
            
        case NSCalendarUnitMinute:
        {
            ordinality = [components minute];
            break;
        }
            
        case NSCalendarUnitHour:
        {
            ordinality = [components hour];
            break;
        }
            
        case NSCalendarUnitDay:
        {
            ordinality = [components day];
            break;
        }
            
        case NSCalendarUnitMonth:
        {
            ordinality = [components month];
            break;
        }
            
        case NSCalendarUnitYear:
        {
            ordinality = [components year];
            break;
        }
            
        default:
            break;
    }
    
    return ordinality;
}



+ (UIViewController *)mostFrontViewController {
    UIViewController *vc = [self rootViewController];
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}


#pragma mark 判断是否为空字符串
+ (BOOL)isBlankString:(NSString *)aStr{
    
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    
    return NO;
    
}

+ (NSURL *)createFolderWithName:(NSString *)folderName inDirectory:(NSString *)directory {
    NSString *path = [directory stringByAppendingPathComponent:folderName];
    NSURL *folderURL = [NSURL URLWithString:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSError *error;
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        if (!error) {
            return folderURL;
        }else {
            NSLog(@"创建文件失败 %@", error.localizedFailureReason);
            return nil;
        }
        
    }
    return folderURL;
}

+ (NSString*)dataPath {
    static NSString *_dataPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    });
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:_dataPath]){
        [fm createDirectoryAtPath:_dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    
    return _dataPath;
}

+ (BOOL)isValidateLeaveMessage:(NSString *)leaveMessage{
    //预留信息只支持数字,英文小写或中文字符.务必牢记,保护您的交易安全
    NSString *regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,16}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self MATCHES %@",regular];
    BOOL result = [predicate evaluateWithObject:leaveMessage];
    return result;
}
+ (BOOL)checkRealName:(NSString *)realName {
    //中文，英文，·符号，长度2~14位
    NSString *realNameRegex = @"[a-zA-Z·\u4e00-\u9fa5]{2,14}";
    NSPredicate *realNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",realNameRegex];
    if (![realNamePredicate evaluateWithObject:realName]) {
        return NO;
    }
    return YES;
}
+ (BOOL)checkBitcoinAddress:(NSString *)btcAddress {
    NSString *bitcoinRegex = @"^[a-zA-Z0-9]{6,40}";
    NSPredicate *bitcoinPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bitcoinRegex];
    if (![bitcoinPredicate evaluateWithObject:btcAddress]) {
        return NO;
    }
    return YES;
}
+ (BOOL)isValidatePhone:(NSString *)phone{
    NSString *phoneRegex = @"^(1)[3456789]\\d{9}";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if (![phonePredicate evaluateWithObject:phone]) {
        
        return NO;
    }
    return YES;
}
+ (BOOL)isValidateEmail:(NSString *)originalEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *email = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [email evaluateWithObject:originalEmail];
}
/** 正则表达式验证密码是否合法 YES 合法，NO 不合法 */
+ (BOOL)isValidatePwd:(NSString *)originalPwd{
    NSString *pwdRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,10}";
    NSPredicate *pwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwd evaluateWithObject:originalPwd];
}

+ (NSString*)getCurrentTimesWithFormat:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:formatStr];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

@end
