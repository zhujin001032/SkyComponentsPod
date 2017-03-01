//获取屏幕宽度
var width = window.screen.width;

//获取屏幕高度
var height = window.screen.height;

console.log(width);
console.log(height);

//绘图数据
var paintData;

//定义当前统计类型、统计图数、当前统计图以及总金额
var total = 0, type = "p", currentIndex = 1, totalCount = 2;

var pieRadius=width/640*132;

//定义饼图对象
var Donut2D = {
    render: 'canvasDiv',
    center: {
        fontsize: 20*width/640,
        color: '#6f6f6f'
    },
    animation: true,
    empty: {
        text: '暂无数据',
        fontsize: 20*width/640,
        color: '#666666'
    },
    background_color: null,
    donutwidth: 0.6,
    align: 'center',
    shadow: false,
   // separate_angle: 6,//分离角度
    border: 0,
    padding: 0,
    label: false,
    sub_option: {
        mini_label_threshold_angle: 0,//迷你label的阀值,单位:角度
        mini_label: {//迷你label配置项
            fontsize: 20*width/640,
           // fontweight: 400,
            color: '#ffffff'
        },
        label: {
            background_color: null,
            sign: false,//设置禁用label的小图标
            padding: '0 4',
            border: {
                enable: false,
                color: '#666666'
            },
            fontsize: 20*width/640,
           // fontweight: 400,
            color: '#4572a7'
        },
        border: {
            width: 1,
            color: '#ffffff'
        },
        listeners: {
            parseText: function (d, t) {
                return d.get('value');//自定义label文本
            }
        },
        color_factor: 0.3
    },
    showpercent: true,
    decimalsnum: 2,
    width: width,
    height:pieRadius*2+width/320*94,
    radius:pieRadius
};


//获取url中的参数
var getUrlParam = function (name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
    var r = window.location.search.substr(1).match(reg);  //匹配目标参数
    if (r != null) {
        return unescape(r[2]);
    }

    return null; //返回参数值
}

//绘制饼图
var drawChart = function () {
    // var centerText = $filter('currency')($scope.total,'共 \n￥');
    var data = dataService().getChart(type, currentIndex);
    total = data.total;
    paintData = data.detailList;
    var painttype = "Donut2D", obj = Donut2D;
    obj.data = paintData;
    var chart = new iChart[painttype](obj);
    chart.id = 'canvasDiv';
    chart.draw();

    //绘制列表
    drawList(data.detailList);

    //调整饼图上下空白
    document.getElementById("canvasDiv").firstChild.style.margin = "-40px auto -40px";
    var donutHeight = document.getElementById("canvasDiv").clientHeight - 20;
    document.getElementById("btnDiv").style.height = donutHeight + "px";
    document.getElementById("btnDiv").style.lineHeight = donutHeight + "px";

    var btnHeight = width / 640 * 72;
    var btnWidth = width / 640 * 39;
    var btnPadding = width / 640 * 33;
    document.getElementById("btnLeft").style.width = btnWidth + "px";
    document.getElementById("btnLeft").style.height = btnHeight + "px";
    document.getElementById("btnLeft").style.left = btnPadding + "px";
    document.getElementById("btnLeft").style.top = (donutHeight / 2 - btnHeight) + "px";

    document.getElementById("btnRight").style.width = btnWidth + "px";
    document.getElementById("btnRight").style.height = btnHeight + "px";
    document.getElementById("btnRight").style.top = (donutHeight / 2 - btnHeight) + "px";
    document.getElementById("btnRight").style.left = (width - btnWidth - btnPadding) + "px";

    $(".name").css("height",32*width/640+"px");
    $(".name").css("margin-top",11*width/640+"px");
    $(".name").css("margin-left",42*width/640+"px");
    $(".name").css("line-height",32*width/640+"px");
    $(".name").css("font-size",28*width/640+"px");

    $(".percent").css("font-size",20*width/640+"px");
    $(".percent").css("margin-top",4*width/640+"px");
    $(".percent").css("margin-left",42*width/640+"px");
    $(".percent").css("height",24*width/640+"px");
    $(".percent").css("line-height",24*width/640+"px");
    $(".momey").css("font-size",28*width/640+"px");
    $(".item_data").css("height",78*width/640+"px");
    $(".item_data").css("line-height",78*width/640+"px");
}

//绘制图表下的列表
var drawList = function (data) {
    //清空原有内容
    $("#lstData").html("");
    if (!data || data.length == 0) {
        $("#lstData").hide()
    } else {
        $("#lstData").show();
        var listHtml = '<div class="split-top"></div><ul>';
        for (var i = 0; i < data.length; i++) {
            var item = data[i];
            var percent = (item.value / total) * 100;
            var liData = '<li class="item item_data" style="border-left: ' + width / 640 * 46 + 'px solid ' + item.color + ';">'
                + '<span style="float:left">'
                + '   <div><div class="name">' + item.name + '</div>'
                + '     <div class="percent">' + (isNaN(percent) ? 0 : percent).toFixed(2) + '%</div></div>'
                + ' </span>'
                + '  <span class="momey item-note">￥ ' + item.value.toFixed(2) + '</span>'
                + '  <div class="split"></div>'
                + '</li>';
            listHtml = listHtml + liData;
        }
        listHtml = listHtml + "</ul>";
        $("#lstData").append(listHtml);
    }
}

//初始化参数
var init = function () {
    // var param1 = $location.search()['month'];
    type = getUrlParam('type');
    type = !type ? "p" : type;

    if (type != "p") {
        totalCount = 3;
    }

}

//左右点击事件
var change = function (flag) {
    currentIndex = flag == 0 ? currentIndex - 1 : currentIndex + 1;
    //已经是最左边一个图表
    if (currentIndex == 1) {
        $("#btnLeft").hide();
        $("#btnRight").show();
    } else if (currentIndex == totalCount) {
        $("#btnLeft").show();
        $("#btnRight").hide();
    } else {
        $("#btnLeft").show();
        $("#btnRight").show();
    }
    drawChart();

}

//初始化数据
function initData(data) {
    dataService().setData(type, data);
    //初始设置左点按钮隐藏
    $("#btnLeft").hide();
    $("#btnRight").show();
    currentIndex=1;
    drawChart();
}


//页面加载完成
$(function () {
        init();
        //var dd = '{"memberSummary":[{"amount":"2975.17","commentName":"晕倒1","color":"#00FFFF"},{"amount":"871.00","commentName":"后勤","color":"#FF8C00"},{"amount":"653.00","commentName":"行政","color":"#F08080"},{"amount":"100.00","commentName":"前台","color":"#3CB371"},{"amount":46,"commentName":"其他","color":"#B0C4DE"},{"amount":"46.00","commentName":"秘书"}],"statusSummary":[{"amount":"3105.00","color":"#00FFFF","status":"1"},{"amount":"1640.17","color":"#FF8C00","status":"2"},{"amount":"0.00","color":"#F08080","status":"4"}],"totalAmount":4745.17,"categorySummary":[{"amount":"200.00","categoryName":"交通","color":"#00FFFF"},{"amount":"1640.17","categoryName":"餐饮","color":"#FF8C00"},{"amount":"916.00","categoryName":"住宿","color":"#F08080"},{"amount":"1943.00","categoryName":"办公用品","color":"#3CB371"},{"amount":"46.00","categoryName":"其他","color":"#B0C4DE"}]}';
        //initData(dd);
    }
)

