//支出状态
var pStatus;
//支出分类
var pType;
//人员支出
var pPerson;

//获取数据服务
var dataService = function () {

    var service = {
        getChart: function (type, index) {
            var data;

            if (type == "p") {
                if (index == 1) {
                    data = pStatus;
                } else {
                    data = pType;
                }
            } else {
                switch (index) {
                    case 1:
                        data = pStatus;
                        break;
                    case 2:
                        data = pType;
                        break;
                    case 3:
                        data = pPerson;
                        break;
                    default:
                        data = pStatus;
                        break;
                }
            }
            return data;
        },

        setData: function (type, data) {
            var dataModel = jQuery.parseJSON(data);
            pStatus = {"total": dataModel.totalAmount,
                "detailList": []};
            pType = {"total": dataModel.totalAmount,
                "detailList": []};

            //个人支出状态统计
            if (dataModel.statusSummary&&dataModel.statusSummary.length > 0) {
                for (var i = 0; i < dataModel.statusSummary.length; i++) {
                    var statusName = "";

                    switch (dataModel.statusSummary[i].status) {
                        case 1:
                            statusName = "处理中";
                            break;
                        case 2:
                            statusName = "成功";
                            break;
                        case 4:
                            statusName = "驳回";
                            break;
                        default :
                            statusName = "未知";
                            break;
                    }

                    pStatus.detailList.push({name: statusName, value: dataModel.statusSummary[i].amount, color: dataModel.statusSummary[i].color});
                }
            }

            //个人支出类型统计
            if (dataModel.categorySummary&&dataModel.categorySummary.length > 0) {
                for (var i = 0; i < dataModel.categorySummary.length; i++) {
                    pType.detailList.push({name: dataModel.categorySummary[i].categoryName, value: dataModel.categorySummary[i].amount, color: dataModel.categorySummary[i].color});
                }
            }

            //公社支出统计有按人员的支出统计
            if (type != "p") {
                pPerson = {"total": dataModel.totalAmount,
                    "detailList": []};

                //个人支出类型统计
                if (dataModel.memberSummary&&dataModel.memberSummary.length > 0) {
                    for (var i = 0; i < dataModel.memberSummary.length; i++) {
                        pPerson.detailList.push({name: dataModel.memberSummary[i].commentName, value: dataModel.memberSummary[i].amount, color: dataModel.memberSummary[i].color});
                    }
                }
            }
        }
    };

    return service;
}