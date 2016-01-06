//
//  LunarCalendar.m
//  calendar
//
//  Created by cnsyl066 on 15/12/16.
//  Copyright © 2015年 佐筱猪. All rights reserved.
//

#import "LunarCalendar.h"

@implementation LunarCalendar


///计算星座
+(NSString *)Constellation : (NSDate *) date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMdd"];
    int intConstellation = [[formatter stringFromDate:date] intValue];
    
    if (intConstellation >= 120 && intConstellation <= 218)
        return @"水瓶座";
    else if (intConstellation >= 219 && intConstellation <= 320)
        return @"双鱼座";
    else if (intConstellation >= 321 && intConstellation <= 420)
        return @"白羊座";
    else if (intConstellation >= 421 && intConstellation <= 520)
        return @"金牛座";
    else if (intConstellation >= 521 && intConstellation <= 621)
        return @"双子座";
    else if (intConstellation >= 622 && intConstellation <= 722)
        return @"巨蟹座";
    else if (intConstellation >= 723 && intConstellation <= 822)
        return @"狮子座";
    else if (intConstellation >= 823 && intConstellation <= 922)
        return @"处女座";
    else if (intConstellation >= 923 && intConstellation <= 1022)
        return @"天秤座";
    else if (intConstellation >= 1023 && intConstellation <= 1121)
        return @"天蝎座";
    else if (intConstellation >= 1122 && intConstellation <= 1221)
        return @"射手座";
    else
        return @"摩羯座";
    
    
}
///世界节日获取节日
+(NSString *)getWorldHoliday:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setDateFormat:@"MM"];
    int aMonth = [[dateFormatter stringFromDate:date] intValue];
    [dateFormatter setDateFormat:@"dd"];
    int aDay = [[dateFormatter stringFromDate:date] intValue];

    
    NSString *monthDay;
    if(aMonth<10 && aDay<10)
    {
        monthDay=[NSString stringWithFormat:@"0%i0%i",aMonth,aDay] ;
    }
    else if(aMonth<10 && aDay>9)
    {
        monthDay=[NSString stringWithFormat:@"0%i%i",aMonth,aDay] ;
    }
    else if(aMonth>9 && aDay<10)
    {
        monthDay=[NSString stringWithFormat:@"%i0%i",aMonth,aDay] ;
    }
    else
    {
        monthDay=[NSString stringWithFormat:@"%i%i",aMonth,aDay] ;
    }
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:@"元旦" forKey:@"0101"];
    [dict setObject:@"情人节" forKey:@"0214"];
    [dict setObject:@"学雷锋纪念日" forKey:@"0305"];
    [dict setObject:@"妇女节" forKey:@"0308"];
    [dict setObject:@"白色情人节" forKey:@"0314"];
    [dict setObject:@"世界森林日 世界儿歌日 世界睡眠日" forKey:@"0321"];
    [dict setObject:@"世界水日" forKey:@"0322"];
    [dict setObject:@"愚人节" forKey:@"0401"];
    [dict setObject:@"国际儿童图书日" forKey:@"0402"];
    [dict setObject:@"世界卫生日" forKey:@"0407"];
    [dict setObject:@"世界帕金森病日" forKey:@"0411"];
    [dict setObject:@"世界地球日 世界法律日" forKey:@"0422"];
    [dict setObject:@"世界图书和版权日" forKey:@"0423"];
    [dict setObject:@"全国预防接种宣传日" forKey:@"0425"];
    [dict setObject:@"世界知识产权日" forKey:@"0426"];
    [dict setObject:@"世界交通安全反思日" forKey:@"0430"];
    [dict setObject:@"国际劳动节" forKey:@"0501"];
    [dict setObject:@"世界哮喘日 世界新闻自由日" forKey:@"0503"];
    [dict setObject:@"中国五四青年节 科技传播日" forKey:@"0504"];
    [dict setObject:@"世界红十字日" forKey:@"0508"];
    [dict setObject:@"国际护士节" forKey:@"0512"];
    [dict setObject:@"国际家庭日" forKey:@"0515"];
    [dict setObject:@"国际电信日" forKey:@"0517"];
    [dict setObject:@"国际博物馆日" forKey:@"0518"];
    [dict setObject:@"全国母乳喂养宣传日" forKey:@"0520"];
    [dict setObject:@"国际牛奶日" forKey:@"0523"];
    [dict setObject:@"中国“五卅”运动纪念日" forKey:@"0530"];
    [dict setObject:@"世界无烟日" forKey:@"0531"];
    [dict setObject:@"国际儿童节" forKey:@"0601"];
    [dict setObject:@"世界环境保护日" forKey:@"0605"];
    [dict setObject:@"世界献血者日" forKey:@"0614"];
    [dict setObject:@"防治荒漠化和干旱日" forKey:@"0617"];
    [dict setObject:@"世界难民日" forKey:@"0620"];
    [dict setObject:@"中国儿童慈善活动日" forKey:@"0622"];
    [dict setObject:@"国际奥林匹克日" forKey:@"0623"];
    [dict setObject:@"全国土地日" forKey:@"0625"];
    [dict setObject:@"世界青年联欢节" forKey:@"0630"];
    [dict setObject:@"国际体育记者日" forKey:@"0702"];
    [dict setObject:@"抗日战争纪念日" forKey:@"0707"];
    [dict setObject:@"世界人口日 中国航海日" forKey:@"0711"];
    [dict setObject:@"世界语创立日" forKey:@"0726"];
    [dict setObject:@"第一次世界大战爆发" forKey:@"0728"];
    [dict setObject:@"非洲妇女日" forKey:@"0730"];
    [dict setObject:@"建军节" forKey:@"0801"];
    [dict setObject:@"国际电影节" forKey:@"0806"];
    [dict setObject:@"中国男子节" forKey:@"0808"];
    [dict setObject:@"国际青年节" forKey:@"0812"];
    [dict setObject:@"抗日战争胜利纪念" forKey:@"0815"];
    [dict setObject:@"日本签署无条件投降书日" forKey:@"0902"];
    [dict setObject:@"中国抗日战争胜利纪念日" forKey:@"0903"];
    [dict setObject:@"国际扫盲日 国际新闻工作者日" forKey:@"0908"];
    [dict setObject:@"毛泽东逝世纪念日" forKey:@"0909"];
    [dict setObject:@"中国教师节 世界预防自杀日" forKey:@"0910"];
    [dict setObject:@"世界清洁地球日" forKey:@"0914"];
    [dict setObject:@"国际臭氧层保护日 中国脑健康日" forKey:@"0916"];
    [dict setObject:@"九·一八事变纪念日" forKey:@"0918"];
    [dict setObject:@"国际爱牙日" forKey:@"0920"];
    [dict setObject:@"世界停火日 预防世界老年性痴呆宣传日" forKey:@"0921"];
    [dict setObject:@"世界旅游日" forKey:@"0927"];
    [dict setObject:@"孔子诞辰" forKey:@"0928"];
    [dict setObject:@"国际翻译日" forKey:@"0930"];
    [dict setObject:@"国庆节 世界音乐日 国际老人节" forKey:@"1001"];
    [dict setObject:@"国际和平与民主自由斗争日" forKey:@"1002"];
    [dict setObject:@"世界动物日" forKey:@"1004"];
    [dict setObject:@"国际教师节" forKey:@"1005"];
    [dict setObject:@"中国老年节" forKey:@"1006"];
    [dict setObject:@"全国高血压日 世界视觉日" forKey:@"1008"];
    [dict setObject:@"世界邮政日 万国邮联日" forKey:@"1009"];
    [dict setObject:@"辛亥革命纪念日" forKey:@"1010"];
    [dict setObject:@"世界标准日" forKey:@"1014"];
    [dict setObject:@"国际盲人节(白手杖节)" forKey:@"1015"];
    [dict setObject:@"世界粮食日" forKey:@"1016"];
    [dict setObject:@"世界消除贫困日" forKey:@"1017"];
    [dict setObject:@"世界骨质疏松日" forKey:@"1020"];
    [dict setObject:@"世界传统医药日" forKey:@"1022"];
    [dict setObject:@"联合国日 世界发展新闻日" forKey:@"1024"];
    [dict setObject:@"中国男性健康日" forKey:@"1028"];
    [dict setObject:@"万圣节 世界勤俭日" forKey:@"1031"];
    [dict setObject:@"达摩祖师圣诞" forKey:@"1102"];
    [dict setObject:@"柴科夫斯基逝世悼念日" forKey:@"1106"];
    [dict setObject:@"十月社会主义革命纪念日" forKey:@"1107"];
    [dict setObject:@"中国记者日" forKey:@"1108"];
    [dict setObject:@"全国消防安全宣传教育日" forKey:@"1109"];
    [dict setObject:@"世界青年节" forKey:@"1110"];
    [dict setObject:@"光棍节 国际科学与和平周" forKey:@"1111"];
    [dict setObject:@"孙中山诞辰纪念日" forKey:@"1112"];
    [dict setObject:@"世界糖尿病日" forKey:@"1114"];
    [dict setObject:@"泰国大象节" forKey:@"1115"];
    [dict setObject:@"国际大学生节 世界学生节 世界戒烟日" forKey:@"1117"];
    [dict setObject:@"世界儿童日" forKey:@"1120"];
    [dict setObject:@"世界问候日 世界电视日" forKey:@"1121"];
    [dict setObject:@"世界艾滋病日" forKey:@"1201"];
    [dict setObject:@"废除一切形式奴役世界日" forKey:@"1202"];
    [dict setObject:@"世界残疾人日" forKey:@"1203"];
    [dict setObject:@"全国法制宣传日" forKey:@"1204"];
    [dict setObject:@"世界弱能人士日" forKey:@"1205"];
    [dict setObject:@"国际民航日" forKey:@"1207"];
    [dict setObject:@"国际儿童电视日" forKey:@"1208"];
    [dict setObject:@"世界足球日 一二·九运动纪念日" forKey:@"1209"];
    [dict setObject:@"世界人权日" forKey:@"1210"];
    [dict setObject:@"世界防止哮喘日" forKey:@"1211"];
    [dict setObject:@"西安事变纪念日" forKey:@"1212"];
    [dict setObject:@"南京大屠杀纪念日" forKey:@"1213"];
    [dict setObject:@"国际儿童广播电视节" forKey:@"1214"];
    [dict setObject:@"世界强化免疫日" forKey:@"1215"];
    [dict setObject:@"澳门回归纪念" forKey:@"1220"];
    [dict setObject:@"国际篮球日" forKey:@"1221"];
    [dict setObject:@"平安夜" forKey:@"1224"];
    [dict setObject:@"圣诞节" forKey:@"1225"];
    [dict setObject:@"毛泽东诞辰纪念日" forKey:@"1226"];
    [dict setObject:@"国际生物多样性日" forKey:@"1229"];
    
    return [dict objectForKey:monthDay]?:@"无";
}
///获取中国节日
+(NSString *)getChineseHoliday:(NSString *)aMonth day:(NSString *)aDay
{
    NSDictionary *chineseHolidayDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"春节", @"1|1",
                                        @"元宵", @"1|15",
                                        @"端午", @"5|5",
                                        @"七夕", @"7|7",
                                        @"中元", @"7|15",
                                        @"中秋", @"8|15",
                                        @"重阳", @"9|9",
                                        @"腊八", @"12|8",
                                        @"小年", @"12|24",
                                        @"除夕", @"12|30",
                                        nil];
    return [chineseHolidayDict objectForKey:[NSString stringWithFormat:@"%ld|%ld",[self getLunarMonth:aMonth],[self getLunarDay:aDay]]]?:@"无";
}
+(NSInteger)getLunarMonth:(NSString *)aMonth{
    NSArray *monthArr = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月"];
    return [monthArr indexOfObject:aMonth] + 1;
}
+(NSInteger)getLunarDay:(NSString *)aDay{
    NSArray *dayArr = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一"];
    return [dayArr indexOfObject:aDay] + 1;
}
@end

@implementation LunarCalendar (Year)
///获取年的信息
+(NSString *)getYear:(NSInteger )aYear{
    NSArray *HeavenlyStems = @[@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸"];
    NSArray *EarthlyBranches = @[@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥"];
    NSArray *LunarZodiac = @[@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪"];
//    天干
    NSString *Heavenly = HeavenlyStems[( aYear - 4 ) % 10];
//    地支
    NSString *Earthly = EarthlyBranches [(aYear - 4) % 12];
//    属相
    NSString *zodiac = LunarZodiac[( aYear + 8 ) % 12 ] ;
    NSString *year = [NSString stringWithFormat:@"[%@%@年]【%@年】",Heavenly,Earthly,zodiac];
    return year;
}

@end
