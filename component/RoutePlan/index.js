/**
 * @name: index
 * @author: LIULIU
 * @date: 2020-10-12 11:10
 * @description：index
 * @update: 2020-10-12 11:10
 */
import React, {Component} from 'react';
import {
    View,
    Text,
    SafeAreaView,
    StatusBar,
    NativeModules,
    Dimensions,
    StyleSheet,
    Image,
    ScrollView,
    TouchableWithoutFeedback
} from 'react-native';
import FontAwesome5 from 'react-native-vector-icons/FontAwesome5'
import Ionicons from 'react-native-vector-icons/Ionicons'
import AntDesign from 'react-native-vector-icons/AntDesign'
import Modal from 'react-native-modal';
import {inject, observer} from "mobx-react";
import {Actions} from "react-native-router-flux";
import { Toast, Provider, portal} from "@ant-design/react-native"
const {StatusBarManager} = NativeModules;
const deviceWidth = Dimensions.get("window").width;
const deviceHeight = Dimensions.get("window").height;
@inject("homeStore")
@observer
export default class index extends Component {
    constructor(props) {
        super(props);
        this.state = {
            StartPoint: null,
            EndPoint: null,
            NowTime: null,
            selectRoutePlan:0,// 选择的路线
            isModalVisible: false,
            RouteMsg:[] // 高德地图路线规划
        };
    }
    async componentDidMount() {
        await this.getDirections()
        this.getmyDate()
    }
    render() {
        let statusBarHeight;
        if (Platform.OS === "ios") {
            StatusBarManager.getHeight(height => {
                statusBarHeight = height;
            });
        } else {
            statusBarHeight = StatusBar.currentHeight;
        }
        const {departure, destination} = this.props.homeStore
        return (
            <SafeAreaView
                style={[{paddingTop: statusBarHeight, flex: 1, backgroundColor: 'rgba(0, 41, 84, 1.000)'}]}
            >
                <StatusBar
                    animated={true} //指定状态栏的变化是否应以动画形式呈现。目前支持这几种样式：backgroundColor, barStyle和hidden 

                    hidden={false}  //是否隐藏状态栏。 

                    backgroundColor={'rgba(0, 41, 84, 1.000)'} //状态栏的背景色 

                    translucent={true}//指定状态栏是否透明。设置为true时，应用会在状态栏之下绘制（即所谓“沉浸式”——被状态栏遮住一部分）。常和带有半透明背景色的状态栏搭配使用。 

                    barStyle={'light-content'}/>
                    <Provider>
                        <View style={styles.Content}>
                            <View style={styles.Header}>
                                <View style={styles.HeaderBox}>
                                    <View style={styles.HeaderLeft}>
                                        <View style={styles.HeaderLeftOne}></View>
                                        <View style={styles.HeaderLeftTwo}></View>
                                        <View style={styles.HeaderLeftThree}>
                                            <Ionicons name='md-location-sharp' color='rgba(224, 195, 48, 1.000)'
                                                      size={12}></Ionicons>
                                        </View>
                                    </View>
                                    <View style={styles.HeaderCenter}>
                                        <Text
                                            style={styles.HeaderCenterStart}>{departure}</Text>
                                        <View style={styles.HeaderCenterMiddle}></View>
                                        <Text
                                            style={styles.HeaderCenterEnd}>{destination}</Text>
                                    </View>
                                    <View style={styles.HeaderRight}>
                                        <Image source={require('../../images/Transfer.png')}></Image>
                                    </View>
                                </View>
                                <View style={styles.HeaderBtn}>
                                    <FontAwesome5 name='location-arrow' color='#fff' size={22}></FontAwesome5>
                                </View>
                            </View>
                            <View style={styles.Times}>
                                <Ionicons name='time-sharp' size={14} color='rgba(0, 152, 110, 1.000)'></Ionicons>
                                <Text style={styles.TimesText}>{this.state.NowTime}出发</Text>
                                <AntDesign name="down" color="#FFFFFF" size={14}></AntDesign>
                            </View>
                            <ScrollView
                                showsVerticalScrollIndicator = {false}>
                                <View style={styles.PointList}>
                                    {
                                        this.state.RouteMsg.length > 0 ? (
                                            this.state.RouteMsg.map((item, index) => {
                                                return (
                                                    <TouchableWithoutFeedback
                                                        onPress={this.handleSelectItem.bind(this, true, index)}>
                                                        <View style={styles.PointListItem}>
                                                            <View style={styles.PointListItemLeft}>
                                                                <View style={styles.PointListItemTop}>
                                                                    <Text
                                                                        style={styles.PointListItemTopText}>{this.secondToDate(item.duration)}</Text>
                                                                    <FontAwesome5 name='walking' size={20}
                                                                                  color='rgba(81, 81, 81, 1.000)'
                                                                                  style={styles.PointListItemTopIcon}></FontAwesome5>
                                                                    <Text
                                                                        style={styles.PointListItemTopText}>{item.walking_distance}米</Text>
                                                                </View>
                                                                <View style={styles.PointListItemCenter}>
                                                                    {
                                                                        item.segments.map((step, stepindex) => {
                                                                            return (
                                                                                stepindex < 5 && <View style={styles.PointListItemCenterBox} key = {stepindex}>
                                                                                    <View
                                                                                        style={styles.PointListItemCenterBoxStep}>
                                                                                        {
                                                                                            step.bus.buslines.length>0 ?
                                                                                                <Text
                                                                                                    style={styles.PointListItemCenterText}>{this.handleBuslinesName(step.bus.buslines[0].name)}</Text>:<Text
                                                                                                    style={styles.PointListItemCenterText}>步行</Text>
                                                                                        }
                                                                                    </View>
                                                                                    {
                                                                                        item.segments.length > stepindex + 1 &&
                                                                                        <AntDesign name='caretright' size={10}
                                                                                                   color='rgba(232, 227, 228, 1.000)'
                                                                                                   style={styles.PointListItemCenterIcon}></AntDesign>
                                                                                    }
                                                                                </View>
                                                                            )
                                                                        })
                                                                    }
                                                                </View>
                                                                <View style={styles.PointListItemEnd}>
                                                                    <Text
                                                                        style={styles.PointListItemEndText}>{this.handleCountBusline(item)}站 {item.cost}元</Text>
                                                                    <View style={styles.PointListItemEndIcon}></View>
                                                                    {
                                                                        item.segments[0].bus&&item.segments[0].bus.buslines[0]&&<Text
                                                                            style={styles.PointListItemEndText}>{item.segments[0].bus.buslines[0].departure_stop.name}站上车</Text>
                                                                    }
                                                                </View>
                                                                {
                                                                    index === 0 &&
                                                                    <View style={styles.PointListItemIsrecommend}>
                                                                        <Text
                                                                            style={styles.PointListItemIsrecommendText}>推荐路线</Text>
                                                                    </View>
                                                                }
                                                            </View>
                                                            <View style={styles.PointListItemRight}>
                                                                <AntDesign name='right' size={24} color='#bbb'></AntDesign>
                                                            </View>
                                                        </View>
                                                    </TouchableWithoutFeedback>
                                                )
                                            })
                                        ) : null
                                    }
                                </View>
                            </ScrollView>
                            <Modal isVisible={this.state.isModalVisible} swipeDirection='down' style={styles.DrawerBottom}>
                                <View style={styles.DrawerBottomBox}>
                                    <TouchableWithoutFeedback onPress={this.handleSelectItem.bind(this, false)}>
                                        <AntDesign name='close' size={22}></AntDesign>
                                    </TouchableWithoutFeedback>
                                    <Text style={styles.DrawerBottomText}>是否确认进入行程</Text>
                                    <TouchableWithoutFeedback onPress={this.handleToNavigation}>
                                    <View style={styles.DrawerBottomBtn}>
                                            <Text style={styles.DrawerBottomBtnText}>确定</Text>
                                    </View>
                                    </TouchableWithoutFeedback>
                                </View>
                            </Modal>
                        </View>
                    </Provider>
            </SafeAreaView>
        )
    }

    // 地图规划 时间 秒转时分秒
    secondToDate = (result) => {
        var h = Math.floor(result / 3600) < 10 ? '0'+Math.floor(result / 3600) : Math.floor(result / 3600);
        var m = Math.floor((result / 60 % 60)) < 10 ? '0' + Math.floor((result / 60 % 60)) : Math.floor((result / 60 % 60));
        var s = Math.floor((result % 60)) < 10 ? '0' + Math.floor((result % 60)) : Math.floor((result % 60));
        return result = h + "小时" + m + "分";
    }
    // 地图规划 显示规划名称 处理
    handleBuslinesName = (name) => {
        let result = name.replace('轨道交通','').replace('','')
        let indexs = result.indexOf('(')
        result = result.replace(result.substring(indexs,result.length-1),'').replace(')','')
        return result
    }
    // 地图路线规划显示 站台数量
    handleCountBusline = (data) => {
        let num = 0
        data.segments.forEach((item) => {
            if (item.bus && item.bus.buslines.length >0) {
                item.bus.buslines.forEach((xx) => {
                    num = +num + (+xx.via_num)
                })
            }
        })
        return num;
    }
    // 选择路线后跳出弹窗或者关闭弹窗
    handleSelectItem = (bole, index) => {
        this.setState({
            isModalVisible: bole
        })
        if (index) {
            this.setState({
                selectRoutePlan:index
            })
        }
    }
    // 进入行程
   handleToNavigation = () => {
       this.handleCountRoute(this.state.RouteMsg[this.state.selectRoutePlan])
    }

    // 处理路径规划 提取每个步骤的经纬度
    handleCountRoute = (data) =>{
        let Polyline = []
        data.segments.forEach((item) => {
            if (item.walking && item.walking.steps) {
                item.walking.steps.forEach((step) => {
                   let stepary = step.polyline.split(';')
                    stepary.forEach((xx) => {
                        let xxarr = xx.split(',')
                        Polyline = [...Polyline,{latitude:Number(xxarr[1]),longitude:Number(xxarr[0])}]
                    })
                })
            }
            if (item.bus && item.bus.buslines && item.bus.buslines.length>0) {
                if (item.bus.buslines[0].type === '普通公交线路') {
                    let stepary = item.bus.buslines[0].polyline.split(';')
                    stepary.forEach((xx) => {
                        let xxarr = xx.split(',')
                        Polyline = [...Polyline,{latitude:Number(xxarr[1]),longitude:Number(xxarr[0])}]
                    })
                } else {
                    item.bus.buslines.forEach((step) => {
                        let stepary = step.polyline.split(';')
                        stepary.forEach((xx) => {
                            let xxarr = xx.split(',')
                            Polyline = [...Polyline,{latitude:Number(xxarr[1]),longitude:Number(xxarr[0])}]
                        })
                    })
                }
            }
        })
        this.setState({
            Polyline:Polyline
        })
        this.setState({
            isModalVisible: false
        })
        Actions.push('route_plan_detail',{Polyline:Polyline,RouteMsg:this.state.RouteMsg[this.state.selectRoutePlan]})
    }

    // 获取当前时间
    getmyDate() {
        let date = new Date();
        // let year = date.getFullYear().toString();
        let month = (date.getMonth() + 1).toString();
        let day = date.getDate().toString();
        let hour = date.getHours().toString();
        let minute = date.getMinutes().toString();
        this.setState({
            NowTime: month + '月' + day + '日' + ' ' + hour + ':' + minute
        })
    }
    // 获取路径交通规划
    getDirections = async () => {
        const key = Toast.loading('正在计算路径规划', 0);
        const {departureLocation, destinationLocation, amapkey, defineDestination} = this.props.homeStore
        let one = departureLocation.split(',')
        let two = destinationLocation.split(',')
        fetch(`https://restapi.amap.com/v3/direction/transit/integrated?key=${amapkey}&origin=${one[0]},${one[1]}&destination=${two[0]},${two[1]}&city=${defineDestination.addressComponent.province}&strategy=0&nightflag=0`,{
            method: 'GET',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body:''
        }).then((response) => response.json())
            .then((json) =>{
                this.setState({
                    RouteMsg:json.route.transits||[]
                })
                portal.remove(key);
            }).catch((err) =>console.log(err)).finally(()=>console.log('finally'))

    }

}
const styles = StyleSheet.create({
    Content: {
        paddingTop: deviceWidth * 0.11,
        paddingLeft: deviceWidth * 0.03,
        paddingRight: deviceWidth * 0.03
    },
    Header: {
        justifyContent: 'center',
        flexDirection: 'row',
        height: deviceWidth * 0.2
    },
    HeaderBox: {
        flex: 6,
        backgroundColor: '#fff',
        borderRadius: deviceWidth * 0.02,
        flexDirection: 'row',
        alignItems: 'center'
    },
    HeaderLeft: {
        flex: 1,
        alignItems: 'center'
    },
    HeaderLeftOne: {
        height: deviceWidth * 0.02,
        width: deviceWidth * 0.02,
        borderRadius: deviceWidth * 0.01,
        backgroundColor: '#fff',
        borderWidth: deviceWidth * 0.005,
        borderColor: 'rgba(35, 178, 147, 1.000)',
        marginLeft: deviceWidth * 0.05
    },
    HeaderLeftTwo: {
        height: deviceWidth * 0.06,
        width: deviceWidth * 0.001,
        backgroundColor: 'rgba(231, 230, 230, 1.000)',
        marginLeft: deviceWidth * 0.05
    },
    HeaderLeftThree: {
        // height:deviceWidth*0.02,
        // width: deviceWidth*0.02,
        // borderRadius:deviceWidth*0.01,
        // backgroundColor:'#fff',
        // borderWidth:deviceWidth*0.005,
        // borderColor:'rgba(224, 195, 48, 1.000)',
        marginLeft: deviceWidth * 0.05
    },
    HeaderCenter: {
        flex: 5.5
    },
    HeaderCenterStart: {
        color: '#000000',
        fontSize: 12,
        lineHeight: deviceWidth * 0.08
    },
    HeaderCenterMiddle: {
        height: deviceWidth * 0.002,
        backgroundColor: 'rgba(237, 237, 237, 1.000)'
    },
    HeaderCenterEnd: {
        color: '#000000',
        fontSize: 12,
        lineHeight: deviceWidth * 0.08
    },
    HeaderRight: {
        flex: 1.2,
        alignItems: 'center'
    },
    HeaderBtn: {
        flex: 0.6,
        alignItems: 'flex-end',
        justifyContent: 'center'
    },
    Times: {
        flexDirection: 'row',
        marginTop: deviceWidth * 0.05,
        alignItems: 'center'
    },
    TimesText: {
        fontSize: 13,
        color: '#fff',
        paddingLeft: deviceWidth * 0.015,
        paddingRight: deviceWidth * 0.015
    },
    PointList: {
        marginBottom: deviceWidth * 0.3
    },
    PointListItem: {
        marginTop: deviceWidth * 0.06,
        backgroundColor: '#fff',
        borderRadius: deviceWidth * 0.02,
        paddingLeft: deviceWidth * 0.04,
        paddingRight: deviceWidth * 0.04,
        paddingTop: deviceWidth * 0.03,
        paddingBottom: deviceWidth * 0.03,
        flexDirection: 'row'
    },
    PointListItemLeft: {
        flex: 8
    },
    PointListItemTop: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    PointListItemTopText: {
        fontSize: 15,
        color: '#000'
    },
    PointListItemTopIcon: {
        marginLeft: deviceWidth * 0.03,
        marginRight: deviceWidth * 0.03
    },
    PointListItemCenter: {
        flexDirection: 'row',
        marginTop: deviceWidth * 0.019,
        flexWrap: 'wrap'
    },
    PointListItemCenterBox: {
        flexDirection: 'row',
        fontSize: 13,
        alignItems: 'center'
    },
    PointListItemCenterIcon: {
        marginRight: deviceWidth * 0.012,
        marginLeft: deviceWidth * 0.012
    },
    PointListItemCenterBoxStep: {
        borderRadius: deviceWidth * 0.05,
        paddingTop: deviceWidth * 0.006,
        paddingRight: deviceWidth * 0.02,
        marginTop:deviceWidth * 0.006,
        paddingBottom: deviceWidth * 0.006,
        paddingLeft: deviceWidth * 0.02,
        backgroundColor: 'rgba(0, 131, 143, 1.000)'
    },
    PointListItemCenterText: {
        fontSize: 12,
        color: '#fff'
    },
    PointListItemEnd: {
        flexDirection: 'row',
        marginTop: deviceWidth * 0.025,
        alignItems: 'center'
    },
    PointListItemEndText: {
        color: '#999999',
        fontSize: 13,
        marginRight: deviceWidth * 0.1
    },
    PointListItemEndIcon: {
        height: 13,
        width: 2,
        backgroundColor: '#eee',
        marginRight: 2
    },
    PointListItemIsrecommend: {
        marginTop: deviceWidth * 0.025,
        backgroundColor: 'rgba(0, 151, 110, 1.000)',
        width: deviceWidth * 0.2,
        height: deviceWidth * 0.05,
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: deviceWidth * 0.015
    },
    PointListItemIsrecommendText: {
        color: '#fff',
        fontSize: 14
    },
    PointListItemRight: {
        alignItems: 'center',
        flex: 1,
        justifyContent: 'center'
    },
    DrawerBottom: {
        // alignItems:'flex-end'，
        alignItems: 'center',
        justifyContent: 'center'
        // flexDirection: 'row',
        // alignItems: 'center',
        // justifyContent: 'flex-end',
    },
    DrawerBottomBox: {
        marginTop: deviceHeight - deviceWidth * 0.45,
        width: deviceWidth * 0.95,
        height: deviceWidth * 0.45,
        borderTopLeftRadius: deviceWidth * 0.08,
        borderTopRightRadius: deviceWidth * 0.08,
        backgroundColor: "#fff",
        paddingTop: deviceWidth * 0.5 * 0.1,
        paddingLeft: deviceWidth * 0.5 * 0.1,
        paddingRight: deviceWidth * 0.05
    },
    DrawerBottomText: {
        fontSize: 18,
        color: '#000',
        textAlign: 'center',
        marginTop: deviceWidth * 0.5 * 0.12
    },
    DrawerBottomBtn: {
        alignItems: 'center',
        width: deviceWidth * 0.18,
        height: deviceWidth * 0.06,
        borderColor: 'rgba(38, 165, 234, 1.000)',
        borderWidth: 1,
        borderRadius: deviceWidth * 0.04,
        marginTop: deviceWidth * 0.5 * 0.12,
        justifyContent: 'center',
        marginLeft: deviceWidth * 0.335
    },
    DrawerBottomBtnText: {
        fontSize: 14,
        color: 'rgba(38, 165, 234, 1.000)'
    }
})
