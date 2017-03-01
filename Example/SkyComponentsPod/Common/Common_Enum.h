//
//  Common_Enum.h
//  SkyComponentsPod
//
//  Created by Mark Yang on 3/16/16.
//  Copyright © 2016 Jason.He. All rights reserved.
//

#ifndef Common_Enum_h
#define Common_Enum_h

typedef NS_ENUM(NSInteger, ModuleSection) {
    ModuleSection_Basic = 0,
    ModuleSection_Peripheral,
    ModuleSection_Function,
    ModuleSection_Payment,
    ModuleSection_Security,
    ModuleSection_WeChatPublic,
//    ModuleSection_Backend,            // just for Server
    ModuleSection_Test_Deployment,
    ModuleSection_Count,
};//

typedef NS_ENUM(NSInteger, BasicItem) {
    BasicItem_Landing = 0,
    BasicItem_Bubble,
    BasicItem_Version,
    BasicItem_NewUser,
    BasicItem_Notification,
    BasicItem_Tracking,
    BasicItem_Networking,
    BasicItem_Menu_Setting,
    BasicItem_SMS_Validate,
    BasicItem_Graph_Lock,
    BasicItem_Count,
};// Used for ModuleSection_Basic

typedef NS_ENUM(NSInteger, PeripheralItem) {
    PeripheralItem_Camera = 0,
    PeripheralItem_Bluetooth,
    PeripheralItem_Vibrator,
    PeripheralItem_GPS,
    PeripheralItem_WIFI,
    PeripheralItem_FingerMark,
    PeripheralItem_Count,
};// Used for ModuleSection_Peripheral

typedef NS_ENUM(NSInteger, FunctionItem) {
    FunctionItem_H5Chart = 0,
    FunctionItem_Maps,
    FunctionItem_3rd_Data,
    FunctionItem_3rd_Reader,
    FunctionItem_Sharing,       // via wechat/whatapp/fb/sms
    FunctionItem_SSO,           // using QQ/FB
    FunctionItem_Operation_Count,
    FunctionItem_LiveVideo,
    FunctionItem_Count,
};// Used for ModuleSection_Function

typedef NS_ENUM(NSInteger, PaymentItem) {
    PaymentItem_Alipay = 0,
    PaymentItem_WechatPay,
    PaymentItem_Paypal,
    PaymentItem_ApplePay,
    PaymentItem_Count,
};// Used for ModuleSection_Payment

typedef NS_ENUM(NSInteger, SecurityItem) {
    SecurityItem_LocalProperties = 0,
    SecurityItem_Decompiler,
    SecurityItem_Socket,                // Encrypt using https
    SecurityItem_API_Call,
    SecurityItem_Count,
};// Used for ModuleSection_Security

typedef NS_ENUM(NSInteger, WeChatPublicItem) {
    WeChatPublicItem_Online_Vote = 0,
    WeChatPublicItem_Response,
    WeChatPublicItem_Messaging,
    WeChatPublicItem_Count,
};// Used for ModuleSection_WeChatPublic

typedef NS_ENUM(NSInteger, TestItem) {
    TestItem_AWS = 0,                   // Amzaon Web Service
    TestItem_Auto_Test,
    TestItem_Auto_Deployment,
    TestItem_Performance_Test,
    TestItem_Count,
};//

#endif /* Common_Enum_h */
