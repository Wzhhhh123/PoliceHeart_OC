//
//  NetworkInterface.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/16.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#ifndef NetworkInterface_h
#define NetworkInterface_h


#define URLHOST @"http://132.232.1.224:7066"
//#define URLHOST @"http://192.168.50.213:7066"
//#define ImageHOST @"http://192.168.50.213:7064/"
#define ImageHOST @"http://132.232.1.224:7064/"

#define baikeUrl @"http://wapbaike.baidu.com/item/%@"

#define InforUrl [URLHOST stringByAppendingFormat:@"/hdata"]

#define LoginUrl [URLHOST stringByAppendingFormat:@"/api/App/Login"]
#define WZList [URLHOST stringByAppendingFormat:@"/api/App/GetWZ_ArticleList"]
#define WZCXList [URLHOST stringByAppendingFormat:@"/api/App/GetWZ_ArticleListBya_Title"]

#define SJUrl [URLHOST stringByAppendingFormat:@"/api/App/GetSJ_TestPaperListBytp_Type"]
#define DZSJUrl [URLHOST stringByAppendingFormat:@"/api/App/GetSJ_TestQuestionsListByua_id"]
#define QWZYUrl [URLHOST stringByAppendingFormat:@"/api/App/GetSJ_TestQuestionsListByua_BH"]

#define SendAns [URLHOST stringByAppendingFormat:@"/api/App/InsertAllDJ_UserAnswerDetail"]
#define ResultUrl [URLHOST stringByAppendingFormat:@"/api/App/GetResultById"]

#define BaoGaoUrl [URLHOST stringByAppendingFormat:@"/api/App/InsertBG_ReportPerson/"]
#define BaoGaoListUrl [URLHOST stringByAppendingFormat:@"/api/App/GetDJ_UserAnswerListByu_id"]
#define LiuYanUrl [URLHOST stringByAppendingFormat:@"/api/App/InsertLM_LeaveMessage"]
#define LiuYanLBUrl [URLHOST stringByAppendingFormat:@"/api/App/GetLM_LeaveMessageList"]

#define CLListUrl [URLHOST stringByAppendingFormat:@"/api/App/GetDJ_UserAnswerListByu_idAndtp_Type"]


#define XiuGaiUrl [URLHOST stringByAppendingFormat:@"/api/App/PutUC_APPUser"]

#define UpIconUrl [URLHOST stringByAppendingFormat:@"/api/App/Postau_ImgUrl"]

#define UpImage [URLHOST stringByAppendingFormat:@"/upload"]

#define QYLogin [URLHOST stringByAppendingFormat:@"/api/App/GetUC_APPUserTestPaperByut_BHAndut_Pwd"]
#define WZLYList [URLHOST stringByAppendingFormat:@"/api/App/GetListByArticleLeaveMegBylm_ObjId"]
#define WZLY [URLHOST stringByAppendingFormat:@"/api/App/InsertWZ_ArticleLeaveMeg"]

#define WZDZ [URLHOST stringByAppendingFormat:@"/api/App/InsertWZ_LikeAndRead"]
#define SJXX [URLHOST stringByAppendingFormat:@"/api/App/GetSJ_TestPaperByid"]
#define SJChaXun [URLHOST stringByAppendingFormat:@"/api/App/GetSJ_TestPaperListBytp_NameAndtp_Type"]

#define WZXhaXun [URLHOST stringByAppendingFormat:@"/api/App/GetWZ_ArticleListBya_Title"]

#define XXList [URLHOST stringByAppendingFormat:@"/api/App/Getsys_MessageBysm_UserID"]

#define TZList [URLHOST stringByAppendingFormat:@"/api/App/GetLM_LeaveMessageListByu_id"]

#define ZCCode [URLHOST stringByAppendingFormat:@"/api/App/SendRegisterCode"]
#define ZCSend [URLHOST stringByAppendingFormat:@"/api/App/Register"]

#define ResetCode [URLHOST stringByAppendingFormat:@"/api/App/SendVerificationCode"]
#define ResetSend [URLHOST stringByAppendingFormat:@"/api/App/ForgerPassword"]

#define DetAns [URLHOST stringByAppendingFormat:@"/api/App/DeleteDJ_UserAnswer"]
#define ArtDet [URLHOST stringByAppendingFormat:@"/api/App/GetWZ_ArticleListById"]



#endif /* NetworkInterface_h */
