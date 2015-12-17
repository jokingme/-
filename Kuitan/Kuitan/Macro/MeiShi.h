//
//  MeiShi.h
//  Kuitan
//
//  Created by lanouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#ifndef Kuitan_MeiShi_h
#define Kuitan_MeiShi_h

//分类URL
#define FenLeiListURL @"http://api.haodou.com/index.php?appid=2&format=json&vc=76&method=Search.getCateList&v=2"
#define FenLeiDetailUrl @"http://api.haodou.com/index.php?appid=2&format=json&vc=76&method=Search.getList&v=2&limit=20&scene=t1&tagid=%@&offset=%d"
#define FenLeiMovieStepUrl @"http://api.haodou.com/index.php?appid=2&format=json&vc=76&method=Info.getInfo&signmethod=md5&v=2&rid=%@"
#define FenLeiMovieUrl @"http://api.haodou.com/index.php?appid=2&format=json&vc=76&method=Info.getVideoUrl&v=2&rid=%@"

//首页URL
#define ShouYeListUrl @"http://api.izhangchu.com/?cat_id=377&methodName=CategorySearch&page=1&size=6&type=1&user_id=0&version=1.0"
#define ShouYeListUrl2 @"http://api.izhangchu.com/?methodName=HomeIndex&version=1.0"
#define ShouYeDetailUrl @"http://api.izhangchu.com/?methodName=HomeSerial&page=%ld&serial_id=%@&size=6&user_id=0&version=1.0"
#define ShouYeDetailDetailUrl @"http://api.izhangchu.com/?dishes_id=%@&methodName=DishesView&user_id=0&version=1.0"

//专题URL
#define FindListUrl @"http://api.izhangchu.com/?page=%ld&methodName=TopicList&size=10"
#define FindDetailUrl @"http://api.izhangchu.com/?methodName=TopicView&version=1.0&user_id=0&topic_id=%d"

//宽度高度
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

//主题色
#define COLOR [UIColor colorWithRed:244.0 / 256 green:122.0 / 256 blue:73.0 / 256 alpha:1.0]

#endif
