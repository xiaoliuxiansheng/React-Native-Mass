/**
 * @name: Home
 * @author: LIULIU
 * @date: 2020-07-10 16:58
 * @description：Home
 * @update: 2020-07-10 16:58
 */
import React, {Component} from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableWithoutFeedback,
    TextInput,
    Dimensions,
    ScrollView,
    SafeAreaView,
    NativeModules,
    StatusBar,
    Image
} from 'react-native'
import AntDesign from "react-native-vector-icons/AntDesign"
import FontAwesome from 'react-native-vector-icons/FontAwesome'
import FontAwesome5 from 'react-native-vector-icons/FontAwesome5'
import Entypo from 'react-native-vector-icons/Entypo'
import Fontisto from 'react-native-vector-icons/Fontisto'
import Ionicons from 'react-native-vector-icons/Ionicons'
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons'
import {Drawer as DrawerTest} from 'teaset'
import AllModules from './modulars/Index.js'
import {Actions} from 'react-native-router-flux'
import {observer, inject} from 'mobx-react';
import {Drawer as DrawerAnt, DatePicker, List, Provider} from '@ant-design/react-native';
import AsyncStorage from '@react-native-community/async-storage';
import SplashScreen from 'react-native-splash-screen'

const {StatusBarManager} = NativeModules;

@inject("homeStore")
@observer
export default class Home extends Component {
    constructor(props) {
        super(props);
        this.state = {
            travelType: 1,
            datetime: '',
            destination: '',//终点
            destinationLocation: '',
            departure: '', //起始地址
            departureLocation: '',//起点地址经纬度
            localDate: new Date().toLocaleString().replace(/\//g, "-").replace('上午').replace('下午', ''),
            tabType: [
                {
                    name: '普通服务',
                    icon: 'torso-business',
                    url: require('../images/service/one.png')
                },
                {
                    name: '残疾人服务',
                    icon: 'torso-business',
                    url: require('../images/service/two.png')
                },
                {
                    name: '女性服务',
                    icon: 'torso-business',
                    url: require('../images/service/three.png')
                },
                {
                    name: '儿童服务',
                    icon: 'torso-business',
                    url: require('../images/service/four.png')
                },
                {
                    name: '商务服务',
                    icon: 'torso-business',
                    url: require('../images/service/five.png')
                },
                {
                    name: '购物服务',
                    icon: 'torso-business',
                    url: require('../images/service/six.png')
                },
                {
                    name: '主题服务',
                    icon: 'torso-business',
                    url: require('../images/service/seven.png')
                },
                {
                    name: 'VIP服务',
                    icon: 'torso-business',
                    url: require('../images/service/eight.png')
                },
                {
                    name: '观光旅游服务',
                    icon: 'torso-business',
                    url: require('../images/service/nine.png')
                },
                {
                    name: '物流服务',
                    icon: 'torso-business',
                    url: require('../images/service/ten.png')
                },
                {
                    name: '国际服务',
                    icon: 'torso-business',
                    url: require('../images/service/eleven.png')
                },
                {
                    name: '敬请期待...',
                    icon: 'torso-business',
                }
            ],
            searchItem: '',
            searchName: '',
            searchData: [],
            locationType: 1, // 1为出发类型 2为目的地
            inputText: '',
            showHeader: true, // 调用菜单抽屉时 隐藏头部导航
            value: undefined,
            showBar:null
        };
    }

    async componentDidMount() {
        SplashScreen.hide()
        // this.handelGetamapData()
    }

    handleSetTab = (index) => {
        const {handleSaveTab, defineTab} = this.props.homeStore
        if (defineTab !== index) {
            handleSaveTab(index)
        }
        if (this.DrawerTop) {
            this.DrawerTop.close()
        }
    }
    // 跳转至套餐页面
    handleToMonthPack = () => {
        if (this.DrawerLeft) {
            this.DrawerLeft.close()
        }
        Actions.push('monthpackage')
    }
    // 取消搜索地址框
    cancelSearch = () => {
        this.drawerants.closeDrawer()
    }
    // 选择对应地址
    handleSelectItem = async (item) => {
        this.drawerants.closeDrawer()
        const {handleSaveDeparture, handleSaveDestination} = this.props.homeStore
        if (this.state.locationType === 1) {
            this.setState({
                departure: item.name,
                departureLocation: item.location
            })
            handleSaveDeparture(item.location, item.name)
        } else {
            this.setState({
                destination: item.name,
                destinationLocation: item.location
            })
            handleSaveDestination(item.location, item.name)
        }
        // 设置本地缓存 存储输入地址历史
        item.isSelected = true
        let storage = await this.getMyObject() !== null ? await this.getMyObject() : []
        // 倒序 数据长度最多5
        let HasInd = storage.findIndex((xx, dd) => item.name === xx.name && item.adname === xx.adname && item.address === xx.address)
        if (HasInd >= 0) {
            storage.splice(HasInd, 1)
        }
        storage.unshift(item)
        if (storage.length > 5) storage.length = 5
        await this.setObjectValue(storage)
    }
    // 打开位置搜索框
    handelSearchPlace = async (type) => {
        this.setState({
            searchData: [],
            showBar:1
        })
        if (+type === 1) {
            this.setState({
                locationType: 1,
                searchName: this.state.departure
            })
            if (this.state.departure === '') {
                const {defineDestination} = this.props.homeStore
                if (defineDestination && defineDestination.formatted_address) {
                    await this.handelGetamapData(defineDestination.formatted_address)
                } else {
                    await this.handelGetamapData()
                }
                this.drawerants.openDrawer()
            } else {
                await this.handelGetamapData()
                this.drawerants.openDrawer()
            }
        } else {
            this.setState({
                locationType: 2,
                searchName: this.state.destination
            })
            await this.handelGetamapData()
            this.drawerants.openDrawer()
        }
    }
    // 打开选择框
    handleOpenTab = (bole) => {
        this.setState({
            showHeader: false
        })
        let statusBarHeight;
        if (Platform.OS === "ios") {
            StatusBarManager.getHeight(height => {
                statusBarHeight = height;
            });
        } else {
            statusBarHeight = StatusBar.currentHeight;
        }
        const {defineDestination} = this.props.homeStore
        let view = (
            <SafeAreaView
                style={[{paddingTop: statusBarHeight, backgroundColor: 'rgba(0, 41, 84, 1.000)'}]}
            >
                <View style={[{backgroundColor: 'rgba(0, 41, 84, 1.000)'}]}>
                    <View style={styles.container}>
                        <TouchableWithoutFeedback onPress={this.openDrawers}>
                            <FontAwesome name="user" size={28} color="#FFFFFF" style={styles.person}/>
                        </TouchableWithoutFeedback>
                        {
                            defineDestination && defineDestination.addressComponent &&
                            <Text style={styles.city}>{defineDestination.addressComponent.province}</Text>
                        }
                        <TouchableWithoutFeedback onPress={() => {
                            NativeModules.RNManagerModule.RNActivity();
                        }}>
                            <Ionicons name='chatbubble-ellipses' size={28} color="#FFFFFF"
                                      style={styles.message}></Ionicons>
                        </TouchableWithoutFeedback>
                    </View>
                    <View style={styles.drawerBoxTitle}>
                        <Text style={styles.drawerBoxTitleText}>全部服务</Text>
                        <TouchableWithoutFeedback onPress={this.handleOpenTab.bind(this, false)}>
                            <AntDesign name='close' size={23} style={styles.drawerBoxClose}></AntDesign>
                        </TouchableWithoutFeedback>
                    </View>
                    <View style={styles.drawerBoxMoudal}>
                        {
                            this.state.tabType.map((item, index) => {
                                return (
                                    <TouchableWithoutFeedback onPress={this.handleSetTab.bind(this, index + 1)}>
                                        <View
                                            key={index}
                                            style={[styles.drawerBoxMoudalItem, {width: Dimensions.get('window').width / 3}]}>
                                            {
                                                item.url && <Image
                                                    style={styles.drawerBoxMoudalItemImg}
                                                    source={item.url}
                                                />
                                            }
                                            <Text style={styles.drawerBoxText}>{item.name}</Text>
                                        </View>
                                    </TouchableWithoutFeedback>
                                )
                            })
                        }
                    </View>
                </View>
            </SafeAreaView>
        )
        if (bole) {
            this.DrawerTop = DrawerTest.open(view, 'top');
        } else {
            this.DrawerTop.close()
        }
    }
    openDrawers = (bole) => {
        this.setState({
            showBar:2
        })
        this.drawerants.openDrawer()
    }
    // 设置出行类型
    handleType = (type) => {
        this.setState({
            travelType: type
        })
    }
    // 记录input的值
    onChangeText = (text) => {
        this.setState({
            searchName: text
        })
        this.DEBOUNCE(this.handelGetamapData(), 1000)
    }
    // 输入地址搜索时 防抖
    DEBOUNCE = (fn, wait) => {
        let timeout = null;
        return function () {
            if (timeout !== null) clearTimeout(timeout);
            timeout = setTimeout(fn, wait);
        }
    }
    // 读取缓存数据
    getMyObject = async () => {
        try {
            const jsonValue = await AsyncStorage.getItem('InputAddressStorage')
            return jsonValue != null ? JSON.parse(jsonValue) : null
        } catch (e) {
            // read error
        }
    }
    // 保存缓存数据
    setObjectValue = async (value) => {
        try {
            const jsonValue = JSON.stringify(value)
            await AsyncStorage.setItem('InputAddressStorage', jsonValue)
        } catch (e) {
            // save error
        }
    }
    // 获取地址信息以供选择
    handelGetamapData = async (msg) => {
        const {amapDataUrl, amapkey} = this.props.homeStore
        // 获取之前本地存储的历史记录
        let storage = await this.getMyObject() !== null ? await this.getMyObject() : []
        let data = [...storage]
        let searchname = msg ? msg : this.state.searchName
        fetch(`${amapDataUrl}?keywords=${searchname}&offset=20&key=${amapkey}&extensions=all&page=1`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).then((response) => response.json())
            .then((json) => {
                data.push(...json.pois)
                this.setState({
                    searchData: data
                })
            }).catch((err) => console.log(err)).finally(() => console.log('finally'))
    }
    // 跳转app
    handleLinkapp = () => {
        if (this.state.departureLocation && this.state.destinationLocation) {
            Actions.push('routeplan')
            //唤起手机自带地图代码（并传递起始地址）
            // const {departureLocation,destinationLocation} = this.props.homeStore
            // let one = departureLocation.split(',')
            // let two = destinationLocation.split(',')
            // MapLinking.planRoute({lat: one[1], lng: one[0], title: '起点'}, {
            //     lat: two[1],
            //     lng: two[0],
            //     title: '终点'
            // }, 'walk');
        }
    }
    // 获取两点间的距离
    handelGetamapDistance = async () => {
        await fetch('https://restapi.amap.com/v3/direction/walking', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'origin=116.434307,39.90909&destination=116.434446,39.90816&key=7ca1e96fcbc6e4c4467518e956d5242e'
        }).then((response) => response.json())
            .then((json) => {
                this.setState({
                    searchDistance: json
                })
            }).catch((err) => console.log(err)).finally(() => console.log('finally'))
    }
    onChange = value => {
        this.setState({value});
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
        const {defineTab, defineDestination} = this.props.homeStore
        const sidebar = (
            <View style={[styles.searchplace, {paddingTop: statusBarHeight}]}>
                <StatusBar
                    animated={true} //指定状态栏的变化是否应以动画形式呈现。目前支持这几种样式：backgroundColor, barStyle和hidden 
                    hidden={false}  //是否隐藏状态栏。 
                    backgroundColor={'rgba(0, 41, 84, 1.000)'} //状态栏的背景色 
                    translucent={true}//指定状态栏是否透明。设置为true时，应用会在状态栏之下绘制（即所谓“沉浸式”——被状态栏遮住一部分）。常和带有半透明背景色的状态栏搭配使用。 
                    barStyle={'light-content'}/>
                <View style={styles.searchviewTitle}>
                    <TextInput
                        style={[styles.searchviewsearch]}
                        onChangeText={text => this.onChangeText(text)}
                        placeholder={+this.state.locationType === 1 ? '请输入起点' : '请输入终点'}
                        defaultValue={this.state.searchName}
                        allowFontScaling={false}
                        multiline={false}
                    />
                    <TouchableWithoutFeedback onPress={this.cancelSearch}>
                        <Text style={styles.searchviewsearchtext}>取消</Text>
                    </TouchableWithoutFeedback>
                </View>
                {
                    <ScrollView
                        style={styles.searchItemList}
                        showsVerticalScrollIndicator = {false}
                    >
                        {
                            this.state.searchData.map((item, index) => {
                                return (
                                    <TouchableWithoutFeedback onPress={this.handleSelectItem.bind(this, item)}>
                                        <View style={styles.searchItem} key={index}>
                                            <View style={styles.searchItemLeft}>
                                                {
                                                    item.isSelected &&
                                                    <Fontisto name='history' size={10} color='#fff'></Fontisto>
                                                }
                                                {
                                                    !item.isSelected &&
                                                    <Ionicons name='ios-location' size={10} color='#fff'></Ionicons>

                                                }
                                            </View>
                                            <View style={styles.searchItemRight}>
                                                <Text style={styles.searchItemname}>
                                                    {item.name}
                                                </Text>
                                                <Text style={styles.searchItemaddress}>
                                                    {item.adname} {item.address}
                                                </Text>
                                            </View>
                                        </View>
                                    </TouchableWithoutFeedback>
                                )
                            })
                        }
                    </ScrollView>
                }
            </View>
        );
        const sidebartwo = (
            <View style={[styles.drawerBox]}>
                <View style={styles.drawerBoxContent}>
                    <FontAwesome name="user-circle" size={30} style={styles.drawerBoxIconFirst}></FontAwesome>
                    <Text style={styles.drawerBoxTextFirst}>某某某</Text>
                </View>
                <View style={{backgroundColor: 'rgba(0, 41, 84, 1.000)'}}>
                    <View style={styles.drawerBoxContent} marginTop={10}>
                        <Fontisto name="person" size={20} style={styles.drawerBoxIcon}></Fontisto>
                        <Text style={styles.drawerBoxText}>个人信息</Text>
                    </View>
                    <View style={styles.drawerBoxContent}>
                        <FontAwesome5 name="tasks" size={20} style={styles.drawerBoxIcon}></FontAwesome5>
                        <Text style={styles.drawerBoxText}>我的订单</Text>
                    </View>
                    <View style={styles.drawerBoxContent}>
                        <Entypo name="wallet" size={20} style={styles.drawerBoxIcon}></Entypo>
                        <Text style={styles.drawerBoxText}>我的钱包</Text>
                    </View>
                    <TouchableWithoutFeedback onPress={this.handleToMonthPack}>
                        <View style={styles.drawerBoxContent}>
                            <FontAwesome name="envelope-square" size={20} style={styles.drawerBoxIcon}></FontAwesome>
                            <Text style={styles.drawerBoxText}>月租套餐</Text>
                        </View>
                    </TouchableWithoutFeedback>
                    <View style={styles.drawerBoxContent}>
                        <AntDesign name="Safety" size={20} style={styles.drawerBoxIcon}></AntDesign>
                        <Text style={styles.drawerBoxText}>安全</Text>
                    </View>
                    <View style={styles.drawerBoxContent}>
                        <Fontisto name="player-settings" size={20} style={styles.drawerBoxIcon}></Fontisto>
                        <Text style={styles.drawerBoxText}>设置</Text>
                    </View>
                </View>
            </View>
        )
        return (
            // 对安卓IOS刘海屏、异形屏 进行适配
            <DrawerAnt
                sidebar={this.state.showBar === 1 ? sidebar: sidebartwo}
                position="enum{'left'"
                open={false}
                drawerRef={el => (this.drawerants = el)}
                drawerBackgroundColor="#fff"
                drawerWidth={Dimensions.get('window').width / 5 * 4}
            >
                <SafeAreaView
                    style={[{paddingTop: statusBarHeight, flex: 1, backgroundColor: 'rgba(0, 41, 84, 1.000)'}]}
                >
                    <View style={{flex: 1}}>
                        <StatusBar
                            animated={true} //指定状态栏的变化是否应以动画形式呈现。目前支持这几种样式：backgroundColor, barStyle和hidden 
                            hidden={false}  //是否隐藏状态栏。 
                            backgroundColor={'rgba(0, 41, 84, 1.000)'} //状态栏的背景色 
                            translucent={true}//指定状态栏是否透明。设置为true时，应用会在状态栏之下绘制（即所谓“沉浸式”——被状态栏遮住一部分）。常和带有半透明背景色的状态栏搭配使用。 
                            barStyle={'light-content'}/>
                        <View style={styles.container}>
                            <TouchableWithoutFeedback onPress={this.openDrawers.bind(this, true)}>
                                <FontAwesome name="user" size={28} color="#FFFFFF" style={styles.person}/>
                            </TouchableWithoutFeedback>
                            {
                                defineDestination && defineDestination.addressComponent &&
                                <Text style={styles.city}>{defineDestination.addressComponent.province}</Text>
                            }
                            <TouchableWithoutFeedback onPress={() => {
                                NativeModules.RNManagerModule.RNActivity();
                            }}>
                                <Ionicons name='chatbubble-ellipses' size={28} color="#FFFFFF"
                                          style={styles.message}></Ionicons>
                            </TouchableWithoutFeedback>
                        </View>
                        <View style={styles.menu}>
                            <ScrollView
                                horizontal={true} // 横向
                                showsHorizontalScrollIndicator={false} >
                                <View style={styles.menuLeft}>
                                    {
                                        this.state.tabType.map((item, index) => {
                                            return (
                                                // index < 4 &&
                                                <TouchableWithoutFeedback onPress={this.handleSetTab.bind(this, index + 1)}>
                                                    <Text
                                                        key={index}
                                                        style={[styles.scrooltab, {color: defineTab === index + 1 ? 'rgb(255, 198, 69)' : '#ECECEC'}]}>{item.name}</Text>
                                                </TouchableWithoutFeedback>
                                                // </ScrollView>
                                            )
                                        })
                                    }
                                </View>
                            </ScrollView>
                            <View style={styles.menuRight}>
                                <TouchableWithoutFeedback onPress={this.handleOpenTab.bind(this, true)}>
                                    <Text style={styles.modals}>
                                        <Entypo name='grid' size={32} color="#FFFFFF" style={styles.modals}></Entypo>
                                    </Text>
                                </TouchableWithoutFeedback>
                            </View>
                        </View>
                        {/*<AllModules selectTab={defineTab}></AllModules>*/}
                        <AllModules selectTab={1}></AllModules>
                        <View style={[styles.InputAddress]}>
                            <View style={styles.InputAddressHead}>
                                <TouchableWithoutFeedback onPress={this.handleType.bind(this, 1)}>
                                    <Text
                                        style={[styles.InputAddressText, {color: this.state.travelType === 1 ? 'rgb(255, 198, 69)' : 'rgba(53, 54, 55, 1.000)'}]}>现在</Text>
                                </TouchableWithoutFeedback>
                                <TouchableWithoutFeedback onPress={this.handleType.bind(this, 2)}>
                                    <Text
                                        style={[styles.InputAddressText, {color: this.state.travelType === 2 ? 'rgb(255, 198, 69)' : 'rgba(53, 54, 55, 1.000)'}]}>预约</Text>
                                </TouchableWithoutFeedback>
                            </View>
                            {
                                this.state.travelType === 1 &&
                                <View style={styles.InputAddressBody}>
                                    <View style={styles.InputAddressBodyLeft}>
                                        <View style={styles.textInputBox}>
                                            <View
                                                style={[styles.textInputSpot, {backgroundColor: 'rgba(11, 155, 116, 1.000)'}]}></View>
                                            <TouchableWithoutFeedback onPress={this.handelSearchPlace.bind(this, 1)}>
                                                <Text
                                                    style={[styles.textInput, {color: this.state.departure.length === 0 ? '#ddd' : 'rgba(53, 54, 55, 1.000)'}]}>
                                                    {this.state.departure || '请输入出发地'}
                                                </Text>
                                            </TouchableWithoutFeedback>
                                        </View>
                                        <View style={styles.textInputBox}>
                                            <View
                                                style={[styles.textInputSpot, {backgroundColor: 'rgba(233,194,51,1.000)'}]}></View>
                                            <TouchableWithoutFeedback onPress={this.handelSearchPlace.bind(this, 2)}>
                                                <Text
                                                    style={[styles.textInput, {color: this.state.destination.length === 0 ? '#ddd' : 'rgba(53, 54, 55, 1.000)'}]}>
                                                    {this.state.destination || '请输入目的地'}
                                                </Text>
                                            </TouchableWithoutFeedback>
                                        </View>
                                    </View>
                                    <View style={styles.InputAddressBodyRight}>
                                        <View
                                            style={[styles.InputAddressBodyRightBox, {backgroundColor: this.state.destination === '' || this.state.departure === '' ? '#eee' : 'rgba(30, 143, 245, 1.000)'}]}>
                                            <TouchableWithoutFeedback onPress={this.handleLinkapp}>
                                                <MaterialCommunityIcons name="navigation" size={20} color='#fff'
                                                ></MaterialCommunityIcons>
                                            </TouchableWithoutFeedback>
                                        </View>
                                    </View>
                                </View>
                            }
                            {/*{*/}
                            {/*    this.state.travelType === 2 &&*/}
                            {/*    <Provider>*/}
                            {/*        <View>*/}
                            {/*            <List>*/}
                            {/*                <DatePicker*/}
                            {/*                    value={this.state.value}*/}
                            {/*                    mode="datetime"*/}
                            {/*                    defaultDate={new Date()}*/}
                            {/*                    minDate={new Date()}*/}
                            {/*                    maxDate={new Date(2026, 11, 3)}*/}
                            {/*                    onChange={this.onChange}*/}
                            {/*                    format="YYYY-MM-DD HH:mm"*/}
                            {/*                >*/}
                            {/*                    <List.Item arrow="horizontal">出发时间</List.Item>*/}
                            {/*                </DatePicker>*/}
                            {/*            </List>*/}
                            {/*        </View>*/}
                            {/*    </Provider>*/}
                            {/*}*/}
                        </View>
                    </View>
                </SafeAreaView>
            </DrawerAnt>
        )
    }
}
const styles = StyleSheet.create({
    content: {
        position: 'relative'
    },
    container: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: 50,
        backgroundColor: 'rgba(0, 41, 84, 1.000)'
    },
    person: {
        left: 15,
        flex: 1,
    },
    message: {
        flex: 1,
        textAlign: 'right',
        right: 15
    },
    city: {
        flex: 1,
        textAlign: 'center',
        color: '#FFFFFF',
        fontSize: 15
    },
    menu: {
        flexDirection: 'row',
        backgroundColor: 'rgba(0, 41, 84, 1.000)',
        height: 35
    },
    menuLeft:{
        flex:5,
        flexDirection: 'row'
    },
    // menuRight:{
    //     flex:1
    // },
    modals: {
        flex: .9,
        textAlign: 'center',
        paddingTop: 0,
        marginTop: 0,
        lineHeight: 30
    },
    scrooltab: {
        // flex: 1,
        textAlign: 'center',
        marginRight:15,
        marginLeft:15,
        lineHeight: 28,
        fontSize: 12
    },
    drawerBox: {
        flex: 1,
        alignItems: 'center',
        paddingTop: 50,
        backgroundColor: 'rgba(0, 41, 84, 1.000)'
    },
    drawerBoxContent: {
        width: 200,
        flexDirection: 'row',
        alignItems: 'center',
        textAlign: 'center',
        paddingTop: 5,
        backgroundColor: 'rgba(0, 41, 84, 1.000)',
        fontSize: 10
    },
    drawerBoxIcon: {
        marginRight: 10,
        marginLeft: 20,
        color: '#fff'
    },
    drawerBoxText: {
        // marginLeft: 10,
        color: 'rgba(212, 232, 254, 1.000)',
        height: 40,
        lineHeight: 40
    },
    drawerBoxIconFirst: {
        marginRight: 10,
        marginLeft: 20,
        color: '#fff'
    },
    drawerBoxTextFirst: {
        marginLeft: 10,
        fontSize: 20,
        color: 'rgba(212, 232, 254, 1.000)',
        height: 40,
        lineHeight: 40
    },
    needHelp: {
        position: 'absolute',
        right: 30,
        bottom: 0,
        top: 150,
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
    InputAddress: {
        backgroundColor: '#fff',
        position: 'absolute',
        right: 40,
        left: 40,
        bottom: 40,
        height: 180, //窗口高度
        borderRadius: 20
    },
    InputAddressHead: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 20
    },
    InputAddressText: {
        flex: 1,
        textAlign: 'center',
        marginBottom: 20
    },
    textInput: {
        flex: 8,
        marginLeft: 20,
        marginRight: 20,
        height: 40,
        lineHeight: 40,
        padding: 0,
        borderWidth: 0
    },
    dateTime: {
        flex: 8,
        marginLeft: 10,
        marginRight: 20,
        height: 40,
        padding: 0,
        borderWidth: 0,
        textAlign: 'left'
    },
    textInputBox: {
        flexDirection: 'row',
        alignItems: 'center',
        marginLeft: 30,
        marginRight: 30
    },
    textInputSpot: {
        height: 3,
        width: 3,
        padding: 3,
        borderRadius: 3,
        backgroundColor: '#333'
    },
    drawerBoxTitle: {
        marginTop: 10,
        fontSize: 22,
        justifyContent: 'center',
        alignItems: 'center',
        position: 'relative'
    },
    drawerBoxClose: {
        position: 'absolute',
        right: 15,
        color: '#FFFFFF'
    },
    drawerBoxMoudal: {
        marginTop: 20,
        flexDirection: 'row',
        justifyContent: 'space-around',
        flexWrap: 'wrap'
    },
    drawerBoxMoudalItem: {
        height: 120,
        flexDirection: 'column',
        textAlign: 'center',
        justifyContent: 'center',
        alignItems: 'center',
        borderWidth: 1,
        borderColor: 'rgba(29, 66, 106, 1.000)',
        color: 'rgba(212, 232, 254, 1.000)'
    },
    drawerBoxMoudalItemImg: {
        width: 30,
        height: 30
    },
    InputAddressBody: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    InputAddressBodyLeft: {
        flex: 6
    },
    InputAddressBodyRight: {
        flex: 1
    },
    InputAddressBodyRightBox: {
        width: 30,
        height: 30,
        borderRadius: 15,
        backgroundColor: 'rgba(30, 143, 245, 1.000)',
        justifyContent: 'center',
        alignItems: 'center',
        borderWidth: 5,
        borderColor: 'rgba(211,234,254,1.000)'
    },
    searchplace: {
        flex:1,
        paddingLeft: 20,
        paddingRight: 20,
        backgroundColor: 'rgba(0, 41, 84, 1.000)',
        paddingBottom:0
    },
    searchviewTitle: {
        paddingTop: 30,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        height: 65
    },
    searchviewsearch: {
        textAlign: 'left',
        backgroundColor: '#EEE',
        flex: 5.5,
        paddingLeft: 15,
        borderRadius: 5,
        fontSize: 14,
        paddingTop: 6,
        paddingBottom: 6
    },
    searchviewsearchtext: {
        flexDirection: 'row',
        flex: 1,
        alignItems: 'flex-end',
        height: 35,
        lineHeight: 35,
        textAlign: 'center',
        color: '#fff'
    },
    searchItem: {
        flexDirection: 'row',
        // height:50,
        minHeight: 50,
        alignItems: 'center',
        borderBottomWidth: 1,
        borderColor: 'rgba(0, 41, 84, 1.000)',
        paddingTop: 5,
        paddingBottom: 5
    },
    searchItemList: {
        marginTop: 20,
        paddingBottom: 30,
        backgroundColor: 'rgba(0, 41, 84, 1.000)'
    },
    searchItemLeft: {
        flex: 1,
        textAlign: 'center'
    },
    searchItemRight: {
        flex: 7,
        flexDirection: 'column'
    },
    searchItemaddress: {
        paddingTop: 5,
        color: '#fff',
        fontSize: 12,
    },
    searchItemname: {
        color: '#fff'
    },
    drawerBoxTitleText: {
        color: '#FFFFFF',
        fontSize: 15
    },

});
