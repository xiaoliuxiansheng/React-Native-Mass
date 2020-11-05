/**
 * @name: detail
 * @author: LIULIU
 * @date: 2020-10-14 13:33
 * @description：detail
 * @update: 2020-10-14 13:33
 */
import React, {Component} from "react";
import {
    StyleSheet,
    Text,
    View,
    PermissionsAndroid,
    Platform,
    Dimensions,
    StatusBar,
    NativeModules, SafeAreaView, TouchableWithoutFeedback, ScrollView, Animated, Easing
} from "react-native";
import FontAwesome from "react-native-vector-icons/FontAwesome"
import AntDesign from 'react-native-vector-icons/AntDesign'
import {MapView} from "react-native-amap3d";
import Modal from 'react-native-modal';
import FontAwesome5 from "react-native-vector-icons/FontAwesome5";
import MaterialCommunityIcons from "react-native-vector-icons/MaterialCommunityIcons"
import {Actions} from "react-native-router-flux";

const {StatusBarManager} = NativeModules;
const deviceHeight = Dimensions.get("window").height;
const deviceWidth = Dimensions.get("window").width;
import {observer, inject} from 'mobx-react';

@inject("homeStore")
@observer
export default class EventsExample extends Component {

    state = {
        logs: [],
        coordinate: {
            latitude: 39.91095,
            longitude: 116.37296
        },
        mapTypeArr: ['standard', 'satellite', 'navigation', 'night', 'bus'],
        mapType: 3,
        isModalVisible: false,
        SubwayColor: ['rgba(39, 205, 146, 1.000)', 'rgba(255, 99, 91, 1.000)', 'rgba(255, 151, 58, 1.000)', 'rgba(253, 214, 72, 1.000)', 'rgba(39, 205, 146, 1.000)', 'rgba(255, 99, 91, 1.000)', 'rgba(255, 151, 58, 1.000)', 'rgba(253, 214, 72, 1.000)'],
        lines: [{
            latitude: 39.91095,
            longitude: 116.37296
        }],
        RouteMsg: {},
        offset: new Animated.Value(0),
        opacitys: new Animated.Value(0),
        show: false
    };

    async componentWillMount() {
        await this.setState({
            lines: [...this.props.Polyline],
            RouteMsg: this.props.RouteMsg
        })
        console.log(this.props.RouteMsg)
        await PermissionsAndroid.requestMultiple([
            PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
            PermissionsAndroid.PERMISSIONS.ACCESS_COARSE_LOCATION,
        ]);
    }

    _log(event, data) {
        this.setState({
            coordinate: {
                latitude: data.latitude,
                longitude: data.longitude
            },
            logs: [
                {
                    key: Date.now().toString(),
                    time: new Date().toLocaleString(),
                    event,
                    data: JSON.stringify(data, null, 2)
                },
                ...this.state.logs
            ]
        });
    }

    _logClickEvent = data => this._log("onClick", data);
    _logLongClickEvent = data => this._log("onLongClick", data);
    _logLocationEvent = data => this._log("onLocation", data);
    _logStatusChangeCompleteEvent = data => this._log("onStatusChangeComplete", data);

    _renderItem = ({item}) => (
        <Text style={styles.logText}>
            {item.time} {item.event}: {item.data}
        </Text>
    );
    // 打开弹窗
    handleOpenDrawer = (bole) => {
        this.show()
    }
    // 地图规划 时间 秒转时分秒
    secondToDate = (result) => {
        var h = Math.floor(result / 3600) < 10 ? '0' + Math.floor(result / 3600) : Math.floor(result / 3600);
        var m = Math.floor((result / 60 % 60)) < 10 ? '0' + Math.floor((result / 60 % 60)) : Math.floor((result / 60 % 60));
        var s = Math.floor((result % 60)) < 10 ? '0' + Math.floor((result % 60)) : Math.floor((result % 60));
        return result = h + "小时" + m + "分";
    }
    // 地图规划 显示规划名称 处理
    handleBuslinesName = (name) => {
        let result = name.replace('轨道交通', '').replace('', '')
        let indexs = result.indexOf('(')
        result = result.replace(result.substring(indexs, result.length - 1), '').replace(')', '')
        return result
    }
    // 地图路线规划显示 站台数量
    handleCountBusline = (data) => {
        let num = 0
        data.segments.forEach((item) => {
            if (item.bus && item.bus.buslines.length > 0) {
                item.bus.buslines.forEach((xx) => {
                    num = +num + (+xx.via_num)
                })
            }
        })
        return num;
    }

    // 弹窗动画 弹出
    in() {
        Animated.parallel([
            Animated.timing(
                this.state.offset,
                {
                    easing: Easing.linear,
                    duration: 500,
                    toValue: 1
                }
            ),
            Animated.timing(
                this.state.opacitys,
                {
                    easing: Easing.linear,
                    duration: 500,
                    toValue: 0.9
                }
            )
        ]).start()
    }

    // 弹窗动画下拉
    out() {
        Animated.parallel([
            Animated.timing(
                this.state.offset,
                {
                    easing: Easing.linear,
                    duration: 500,
                    toValue: 0
                }
            ),
            Animated.timing(
                this.state.opacitys,
                {
                    easing: Easing.linear,
                    duration: 300,
                    toValue: 0
                }
            )
        ]).start()

        setTimeout(
            () => this.setState({show: false}),
            1500
        )
    }

    show() {
        this.setState({
            show: true
        }, this.in())
    }

    hide() {
        this.out()
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
        return (
            <SafeAreaView
                style={[{flex: 1, backgroundColor: 'rgba(0, 41, 84, 1.000)'}]}
            >
                <StatusBar
                    animated={true} //指定状态栏的变化是否应以动画形式呈现。目前支持这几种样式：backgroundColor, barStyle和hidden 

                    hidden={false}  //是否隐藏状态栏。 

                    backgroundColor={'rgba(0, 41, 84, 1.000)'} //状态栏的背景色 

                    translucent={true}//指定状态栏是否透明。设置为true时，应用会在状态栏之下绘制（即所谓“沉浸式”——被状态栏遮住一部分）。常和带有半透明背景色的状态栏搭配使用。 

                    barStyle={'light-content'}/>
                {
                    this.state.lines.length > 0 && <View style={styles.RouteDetail}>
                        <MapView
                            style={styles.absoluteFill}
                            locationEnabled
                            // 定位间隔(ms)
                            locationInterval={3000}
                            //  定位的最小更新距离
                            distanceFilter={10}
                            // 是否显示交通状况
                            showsTraffic={true}
                            zoomLevel={14}
                            center={{
                                latitude: this.state.lines[0].latitude || null,
                                longitude: this.state.lines[0].longitude || null
                            }}
                            onLocation={this._logLocationEvent}
                            coordinate={{
                                latitude: this.state.lines[0].latitude || null,
                                longitude: this.state.lines[0].longitude || null
                            }}
                        >
                            <MapView.Polyline
                                width={10}
                                color="rgba(0, 120, 198, 1.000)"
                                coordinates={this.state.lines}
                            />
                            {
                                this.state.lines && this.state.lines[0] && <MapView.Marker
                                    draggable
                                    title='起点'
                                    icon={() =>
                                        <View style={styles.MarkerStart}>
                                            <MaterialCommunityIcons name='near-me' size={24}
                                                                    color='rgba(0, 157, 250, 1.000)'/>
                                        </View>
                                    }
                                    coordinate={{
                                        latitude: this.state.lines[0].latitude || null,
                                        longitude: this.state.lines[0].longitude || null
                                    }}
                                />
                            }
                            {
                                this.state.lines && this.state.lines[0] && <MapView.Marker
                                    draggable
                                    title='终点'
                                    icon={() =>
                                        <View style={styles.MarkerStart}>
                                            <Text style={styles.MarkerText}>终</Text>
                                        </View>
                                    }
                                    coordinate={{
                                        latitude: this.state.lines[this.state.lines.length - 1].latitude || null,
                                        longitude: this.state.lines[this.state.lines.length - 1].longitude || null
                                    }}
                                />
                            }
                        </MapView>
                        <View style={styles.MsgBox}>
                            <View style={styles.MsgBoxContent}>
                                <View style={styles.MsgBoxContentHead}>
                                    <Text
                                        style={styles.MsgBoxContentHeadtext}>全程 {this.secondToDate(this.props.RouteMsg.duration)}</Text>
                                    <View style={styles.MsgBoxContentHeadbtn}>
                                        <FontAwesome name='bell' siz={14} color='#fff'></FontAwesome>
                                        <Text style={styles.MsgBoxContentHeadbtntext}>下车提醒</Text>
                                    </View>
                                </View>
                                <View style={styles.MsgBoxCenter}>
                                    {
                                        this.props.RouteMsg.segments.map((step, stepindex) => {
                                            return (
                                                stepindex < 5 &&
                                                <View style={styles.PointListItemCenterBox} key={stepindex}>
                                                    <View
                                                        style={styles.MsgBoxCenterItem}>
                                                        {
                                                            step.bus.buslines.length > 0 ?
                                                                <Text
                                                                    style={styles.MsgBoxCenterItemText}>{this.handleBuslinesName(step.bus.buslines[0].name)}</Text> :
                                                                <Text
                                                                    style={styles.MsgBoxCenterItemText}>步行</Text>
                                                        }
                                                    </View>
                                                </View>
                                            )
                                        })
                                    }
                                </View>
                                <View style={styles.MsgBoxContentBottom}>
                                    <Text
                                        style={styles.MsgBoxContentBottomtext}>步行{this.props.RouteMsg.walking_distance / 1000}公里·途径{this.handleCountBusline(this.props.RouteMsg)}站·{this.props.RouteMsg.cost}元</Text>
                                    <View style={styles.MsgBoxContentBottombtn}>
                                        <Text style={styles.MsgBoxContentBottombtntext}>站内导航</Text>
                                    </View>
                                </View>
                                <View styles={styles.MsgBoxContentBtn}>
                                    <TouchableWithoutFeedback onPress={this.handleOpenDrawer.bind(this, true)}>
                                        <AntDesign name='down' color='#ccc' size={14}
                                                   style={styles.MsgBoxContentBtnIcon}></AntDesign>
                                    </TouchableWithoutFeedback>
                                </View>
                            </View>
                            <View style={styles.MsgBoxBtn}>
                                <TouchableWithoutFeedback onPress={() => {
                                    Actions.push('routePay',{ RouteMsg: this.props.RouteMsg})
                                }
                                }>
                                    <View style={styles.MsgBoxContentBtnBox}>
                                        <Text style={styles.MsgBoxBtntext}>结束行程</Text>
                                    </View>
                                </TouchableWithoutFeedback>
                            </View>
                        </View>
                        <TouchableWithoutFeedback onPress={() => Actions.push('needhelp')}>
                            <View style={styles.needHelp}>
                                <View style={styles.needHelpIcon}>
                                    <Text style={styles.needHelpText}>SOS</Text>
                                </View>
                                <Text style={styles.needHelpText}>紧急求助</Text>
                            </View>
                        </TouchableWithoutFeedback>
                        <TouchableWithoutFeedback>
                            <View style={[styles.needHelp, {top: 115}]}>
                                <View style={styles.needHelpIcon}>
                                    {/*<Text style={styles.needHelpText}>SOS</Text>*/}
                                    <FontAwesome name='subway' size={20}
                                                 color='rgba(0, 41, 84, 1.000)'></FontAwesome>
                                </View>
                                <Text style={styles.needHelpText}>站内导航</Text>
                            </View>
                        </TouchableWithoutFeedback>
                    </View>
                }
                {
                    this.state.show && <Animated.View style={[styles.modal, {
                        transform: [{
                            translateY: this.state.offset.interpolate({
                                inputRange: [0, 1],
                                outputRange: [deviceHeight, 0]
                            }),
                        }]
                    }, {opacity: this.state.opacitys}]}>
                        <View style={styles.DrawerBottomBigBox}>
                            <View style={[styles.MsgBoxContent, styles.DrawerMsgBoxContent]}>
                                <View style={styles.MsgBoxContentHead}>
                                    <Text
                                        style={styles.MsgBoxContentHeadtext}>全程 {this.secondToDate(this.props.RouteMsg.duration)}</Text>
                                    <View style={styles.MsgBoxContentHeadbtn}>
                                        <FontAwesome name='bell' siz={14} color='#fff'></FontAwesome>
                                        <Text style={styles.MsgBoxContentHeadbtntext}>下车提醒</Text>
                                    </View>
                                </View>
                                <View style={styles.MsgBoxCenter}>
                                    {
                                        this.props.RouteMsg.segments.map((step, stepindex) => {
                                            return (
                                                stepindex < 5 &&
                                                <View style={styles.PointListItemCenterBox} key={stepindex}>
                                                    <View
                                                        style={styles.MsgBoxCenterItem}>
                                                        {
                                                            step.bus.buslines.length > 0 ?
                                                                <Text
                                                                    style={styles.MsgBoxCenterItemText}>{this.handleBuslinesName(step.bus.buslines[0].name)}</Text> :
                                                                <Text
                                                                    style={styles.MsgBoxCenterItemText}>步行</Text>
                                                        }
                                                    </View>
                                                </View>
                                            )
                                        })
                                    }
                                </View>
                                <View style={styles.MsgBoxContentBottom}>
                                    <Text
                                        style={styles.MsgBoxContentBottomtext}>步行{this.props.RouteMsg.walking_distance / 1000}公里·途径{this.handleCountBusline(this.props.RouteMsg)}站·{this.props.RouteMsg.cost}元</Text>
                                    <View style={styles.MsgBoxContentBottombtn}>
                                        <Text style={styles.MsgBoxContentBottombtntext}>站内导航</Text>
                                    </View>
                                </View>
                                <View styles={styles.MsgBoxContentBtn}>
                                    <TouchableWithoutFeedback onPress={() => {
                                        this.out()
                                    }}>
                                        <AntDesign name='up' color='#ccc' size={14}
                                                   style={styles.MsgBoxContentBtnIcon}></AntDesign>
                                    </TouchableWithoutFeedback>
                                </View>
                            </View>
                            <View style={styles.DrawerBottomContent}>
                                <ScrollView
                                    showsVerticalScrollIndicator={false}
                                >
                                    {
                                        this.props.RouteMsg.segments.map((step, stepindex) => {
                                            if (step.bus.buslines.length === 0) {
                                                return (
                                                    <View style={styles.planItem}>
                                                        <FontAwesome5 name='walking' size={20}
                                                                      color='rgba(253, 173, 46, 1.000)'
                                                                      style={styles.PointListItemTopIcon}></FontAwesome5>
                                                        <View style={styles.planItemCenter}>
                                                            <View style={styles.planItemCentercircular}></View>
                                                            {
                                                                ['', '', '', '', ''].map((item) => {
                                                                    return (
                                                                        <View
                                                                            style={styles.planItemCentercirculartwo}></View>
                                                                    )
                                                                })
                                                            }
                                                        </View>
                                                        <View style={styles.planItemRight}>
                                                            {/*{Array.isArray(step.walking.steps[0].road)*/}
                                                            {/*    ? <Text style={styles.planItemRightTitle}>未知地名</Text> :*/}
                                                                <Text
                                                                    style={styles.planItemRightTitle}>{!Array.isArray(step.walking.steps[0].road) ? step.walking.steps[0].road:this.props.RouteMsg.segments[stepindex-1].bus.buslines[0].arrival_stop.name}</Text>
                                                            {/*}*/}
                                                            <Text
                                                                style={styles.planItemRightContent}>步行{step.walking.distance / 1000}公里（{this.secondToDate(step.walking.duration)})</Text>
                                                        </View>
                                                    </View>
                                                )
                                            } else if (step.bus.buslines.length > 0) {
                                                return (
                                                    <View style={[styles.TrainContent, styles.planItem]}>
                                                        {
                                                            step.bus.buslines[0].type === '地铁线路' ?
                                                                <FontAwesome name='subway' size={20}
                                                                             color='rgba(0, 152, 110, 1.000)'
                                                                             style={styles.PointListItemTopIcon}></FontAwesome> :
                                                                <FontAwesome5 name='bus' size={20}
                                                                              color='rgba(0, 86, 136, 1.000)'
                                                                              style={styles.PointListItemTopIcon}></FontAwesome5>
                                                        }
                                                        <View style={styles.planItemCenter}>
                                                            <View
                                                                style={[styles.planItemCentercircular, styles.circularTypeTwo]}></View>
                                                            <View style={styles.planItemCenterBoxTypeOne}></View>
                                                            <View
                                                                style={[styles.planItemCentercircular, styles.circularTypeTwo]}></View>
                                                            {
                                                                step.walking.distance && ['', '', '', '', ''].map((item) => {
                                                                    return (
                                                                        <View
                                                                            style={styles.planItemCentercirculartwo}></View>
                                                                    )
                                                                })
                                                            }
                                                        </View>
                                                        <View style={styles.planItemRight}>
                                                            {
                                                                step.bus.buslines[0].type === '地铁线路' ? <Text
                                                                        style={styles.planItemRightTitle}>{step.bus.buslines[0].departure_stop.name} 地铁站{step.exit.name ? `-${step.exit.name}` : ''}</Text> :
                                                                    <Text
                                                                        style={styles.planItemRightTitle}>{step.bus.buslines[0].departure_stop.name} 公交站</Text>

                                                            }
                                                            <View style={styles.planItemRightHead}>
                                                                <View style={styles.planItemRightContentMsg}>
                                                                    <Text
                                                                        style={styles.planItemRightstart}>{this.handleBuslinesName(step.bus.buslines[0].name)}</Text>
                                                                </View>
                                                                <Text
                                                                    style={styles.planItemRightEnd}>{step.bus.buslines[0].name}</Text>
                                                            </View>
                                                            <View style={styles.planItemRightbody}>
                                                                {/*<Text style={styles.planItemRightbodyOne}>11:20进站</Text>*/}
                                                                <View style={styles.planItemRightbodyBox}>
                                                                    {
                                                                        step.bus.buslines[0].type === '地铁线路' && this.state.SubwayColor.map((item, index) => {
                                                                            return (
                                                                                <View
                                                                                    style={[styles.planItemRightbodyBoxItem, {backgroundColor: item}, {borderTopLeftRadius: index === 0 ? deviceWidth * 0.025 : 0}, {borderTopRightRadius: index === this.state.SubwayColor.length - 1 ? deviceWidth * 0.025 : 0}]}>
                                                                                    <Text
                                                                                        style={[styles.planItemRightbodyBoxItemText]}>{index + 1}</Text>
                                                                                </View>
                                                                            )
                                                                        })
                                                                    }
                                                                </View>
                                                            </View>
                                                            {
                                                                step.walking.distance && <View style={styles.planItemRightBottom}>
                                                                    <AntDesign name='down'
                                                                               color='rgba(162, 162, 162, 1.000)'
                                                                               size={14}></AntDesign>
                                                                    <Text
                                                                        style={styles.planItemRightBottomText}>步行{step.walking.distance / 1000}公里</Text>
                                                                </View>
                                                            }
                                                            <View style={styles.planItemRightBottom}>
                                                                <AntDesign name='down'
                                                                           color='rgba(162, 162, 162, 1.000)'
                                                                           size={14}></AntDesign>
                                                                <Text
                                                                    style={styles.planItemRightBottomText}>乘坐{step.bus.buslines[0].via_num}站（{this.secondToDate(step.bus.buslines[0].duration)})</Text>
                                                            </View>
                                                            {
                                                                step.bus.buslines[0].type === '地铁线路' ? <Text
                                                                        style={[styles.planItemRightTitle, {marginTop: deviceWidth * 0.03}]}>{step.bus.buslines[0].arrival_stop.name} 地铁站{step.exit.name ? `-${step.exit.name}` : ''}</Text> :
                                                                    <Text
                                                                        style={[styles.planItemRightTitle, {marginTop: deviceWidth * 0.03}]}>{step.bus.buslines[0].arrival_stop.name} 公交站</Text>
                                                            }
                                                            {
                                                                step.walking.distance &&
                                                                <Text
                                                                    style={styles.planItemRightContent}>换乘{step.walking.distance}米（{this.secondToDate(step.walking.duration)}）</Text>
                                                            }
                                                        </View>
                                                    </View>
                                                )
                                            }
                                        })
                                    }
                                </ScrollView>
                            </View>
                        </View>
                    </Animated.View>
                }
            </SafeAreaView>
        );
    }
}
const styles = StyleSheet.create({
    RouteDetail: {
        position: 'relative',
        flex: 1
    },
    absoluteFill: {
        // flex:1,
        height: deviceHeight,
        width: deviceWidth
    },
    MsgBox: {
        position: 'absolute',
        left: deviceWidth * 0.05,
        right: deviceWidth * 0.05,
        bottom: deviceWidth * 0.2,
    },
    MsgBoxContent: {
        width: deviceWidth * 0.9,
        backgroundColor: '#fff',
        borderRadius: deviceWidth * 0.02,
        paddingTop: deviceWidth * 0.03,
        paddingLeft: deviceWidth * 0.04,
        paddingRight: deviceWidth * 0.04,
        paddingBottom: deviceWidth * 0.02
        // height:deviceWidth*0.3
    },
    MsgBoxContentHead: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingBottom: deviceWidth * 0.01,
        borderBottomWidth: 1,
        borderBottomColor: '#ccc'
    },
    MsgBoxContentHeadtext: {
        fontSize: 14,
        color: '#000000',
        fontWeight: '500'
    },
    MsgBoxContentHeadbtn: {
        // width: deviceWidth * 0.2,
        paddingLeft: 5,
        paddingRight: 5,
        borderRadius: deviceWidth * 0.02,
        flexDirection: 'row',
        justifyContent: 'center',
        backgroundColor: 'rgba(0, 133, 227, 1.000)',
        alignItems: 'center'
    },
    MsgBoxContentHeadbtntext: {
        fontSize: 14,
        lineHeight: deviceWidth * 0.05,
        color: '#fff',
        marginLeft: deviceWidth * 0.01,
        fontWeight: '500'
    },
    MsgBoxCenter: {
        marginTop: deviceWidth * 0.01,
        flexDirection: 'row',
        alignItems: 'center',
        flexWrap:'wrap'
    },
    MsgBoxCenterItem: {
        marginTop: deviceWidth * 0.01,
        backgroundColor: 'rgba(0, 151, 110, 1.000)',
        marginRight: deviceWidth * 0.025,
        borderRadius: deviceWidth * 0.015,
        paddingLeft: deviceWidth * 0.035,
        paddingRight: deviceWidth * 0.035,
        alignItems: 'center'
    },
    MsgBoxCenterItemText: {
        fontSize: 14,
        color: '#fff',
        lineHeight: 22
    },
    MsgBoxContentBottom: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        marginTop: deviceWidth * 0.02,
    },
    MsgBoxContentBottomtext: {
        fontSize: 12,
        color: '#999999'
    },
    MsgBoxContentBottombtn: {
        width: deviceWidth * 0.2,
        borderWidth: 1,
        borderRadius: deviceWidth * 0.02,
        borderColor: 'rgba(0, 133, 227, 1.000)',
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    MsgBoxContentBottombtntext: {
        fontSize: 14,
        lineHeight: deviceWidth * 0.05,
        color: 'rgba(0, 133, 227, 1.000)',
        marginLeft: deviceWidth * 0.01,
        fontWeight: '500'
    },
    MsgBoxContentBtn: {
        // flex:1,
        flexDirection: 'row',
        justifyContent: 'center',
        // alignItems:'center',
        marginTop: deviceWidth * 0.02,
        marginBottom: deviceWidth * 0.02,
        textAlign: 'center',
        paddingBottom: deviceWidth * 0.01,
    },
    MsgBoxContentBtnIcon: {
        textAlign: 'center'
    },
    MsgBoxBtn: {
        marginTop: deviceWidth * 0.05,
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'center',
    },
    MsgBoxContentBtnBox: {
        width: deviceWidth * 0.33,
        alignItems: 'center',
        backgroundColor: 'rgba(0, 133, 227, 1.000)',
        borderRadius: deviceWidth * 0.03,
        height: deviceWidth * 0.07,
        justifyContent: 'center'
    },
    MsgBoxBtntext: {
        color: '#fff',
        fontWeight: '500'
    },
    DrawerBottom: {
        alignItems: 'center',
        // justifyContent: 'flex-end'
    },
    DrawerBottomBigBox: {
        height: deviceHeight * 0.8,
        marginTop: deviceHeight * 0.15 + 60,
        alignItems: 'center',
        justifyContent:'flex-end',
        position:'relative'
    },
    DrawerBottomContent: {
        width: deviceWidth,
        backgroundColor: '#fff',
        height:deviceHeight * 0.8,
        // marginTop: -60,
        paddingTop: 60,
        paddingBottom: 20,
        zIndex: -1,
        overflow: 'hidden'
    },
    DrawerMsgBoxContent: {
        borderWidth: 1,
        borderColor: '#eee',
        position: 'absolute',
        top:-75
    },
    planItem: {
        marginTop: deviceWidth * 0.05,
        flexDirection: 'row',
        // alignItems:'center'
    },
    PointListItemTopIcon: {
        flex: 2,
        textAlign: 'center'
    },
    planItemCenter: {
        flex: 1,
        alignItems: 'center'
    },
    planItemRight: {
        flex: 12
    },
    planItemCentercircular: {
        width: deviceWidth * 0.04,
        height: deviceWidth * 0.04,
        borderWidth: deviceWidth * 0.005,
        borderRadius: deviceWidth * 0.025,
        borderColor: 'rgba(253, 173, 46, 1.000)'
    },
    circularTypeTwo: {
        borderColor: 'rgba(0, 152, 110, 1.000)'
    },
    planItemCentercirculartwo: {
        width: deviceWidth * 0.01,
        height: deviceWidth * 0.01,
        backgroundColor: '#ccc',
        marginTop: deviceWidth * 0.02
    },
    planItemRightTitle: {
        fontSize: 16,
        color: '#000'
    },
    planItemRightContent: {
        marginTop: deviceWidth * 0.07,
        fontSize: 14,
        color: '#999'
    },
    planItemCenterBoxTypeOne: {
        backgroundColor: 'rgba(0, 131, 143, 1.000)',
        width: deviceWidth * 0.02,
        height: deviceWidth * 0.3,
        marginTop: -deviceWidth * 0.01,
        zIndex: -10
    },
    planItemRightHead: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: deviceWidth * 0.01
    },
    planItemRightContentMsg: {
        backgroundColor: 'rgba(0, 131, 143, 1.000)',
        paddingLeft: 2,
        paddingTop: 1,
        paddingRight: 2,
        paddingBottom: 1,
        borderRadius: 2,
        textAlign: 'center',
        marginRight: deviceWidth * 0.02
        // borderRadius:
    },
    planItemRightstart: {
        color: '#fff',
        fontSize: 10,
        textAlign: 'center'
    },
    planItemRightEnd: {
        fontSize: 10,
        color: '#999'
    },
    planItemRightbody: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: deviceWidth * 0.01
    },
    planItemRightbodyOne: {
        fontSize: 12,
        color: '#999',
        marginRight: deviceWidth * 0.02
    },
    planItemRightbodyBox: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center'
    },
    planItemRightbodyBoxItem: {
        width: deviceWidth * 0.05,
        height: deviceWidth * 0.05,
        backgroundColor: 'rgba(39, 205, 146, 1.000)',
        alignItems: 'center',
        justifyContent: 'center',
        marginRight: deviceWidth * 0.003
    },
    planItemRightbodyBoxItemText: {
        fontSize: 10,
        color: 'rgba(40, 40, 40, 1.000)'
    },
    planItemRightBottom: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: deviceWidth * 0.03
    },
    planItemRightBottomText: {
        color: 'rgba(162, 162, 162, 1.000)',
        fontSize: 14,
        marginLeft: deviceWidth * 0.01
    },
    needHelp: {
        position: 'absolute',
        right: 20,
        bottom: 0,
        top: 70,
        height: 50,
        flexDirection: 'column',
        alignItems: 'center',
    },
    needHelpIcon: {
        height: 26, //窗口高度
        width: 26,
        borderRadius: 13,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#fff',
    },
    needHelpText: {
        fontSize: 10
    },
    MarkerStart: {
        width: 26,
        height: 26,
        borderRadius: 13,
        backgroundColor: '#fff',
        alignItems: 'center',
        justifyContent: 'center'
    },
    MarkerText: {
        color: 'rgba(0, 157, 250, 1.000)',
        fontSize: 16
    },
    modal: {
        height: deviceHeight,
        width: deviceWidth,
        backgroundColor: 'rgba(0, 16, 30, 1.000)',
        justifyContent: 'flex-end'
    },
    modalContent: {
        backgroundColor: '#fff',
        height: deviceHeight * 0.8,
        width: deviceWidth
    }
})
