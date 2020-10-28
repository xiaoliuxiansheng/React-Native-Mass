/**
 * @name: index.js
 * @author: LIULIU
 * @date: 2020-10-09 15:34
 * @description：index.js
 * @update: 2020-10-09 15:34
 */
import React, {Component} from 'react';
import {
    View,
    Text,
    StyleSheet,
    NativeModules,
    StatusBar,
    SafeAreaView,
    Dimensions,
    ImageBackground,
    ScrollView,
    TouchableWithoutFeedback
} from 'react-native';
import Feather from 'react-native-vector-icons/Feather'
import {Actions} from "react-native-router-flux";

const {StatusBarManager} = NativeModules;
const deviceWidth = Dimensions.get("window").width;
export default class Index extends Component {
    constructor(props) {
        super(props);
        this.state = {
            PackageType: [{
                name: 'Urban-个人',
                price: 500,
                type: '仅公共交通免费'
            }, {
                name: 'Urban-个人',
                price: 500,
                type: '仅公共交通免费'
            }, {
                name: 'Urban-个人',
                price: 500,
                type: '仅公共交通免费'
            }, {
                name: 'Urban-个人',
                price: 500,
                type: '仅公共交通免费'
            }, {
                name: 'Urban-个人',
                price: 500,
                type: '仅公共交通免费'
            }, {
                name: 'Urban-个人',
                price: 500,
                type: '仅公共交通免费'
            }, {
                name: 'Urban-个人',
                price: 500,
                type: '仅公共交通免费'
            }],
            BackgroundUnselected: require('../../images/monthpackage/packageunselect.png'),
            BackgroundSelected: require('../../images/monthpackage/packageselected.png'),
            SelectPackNum: 0 // 被选中的套餐
        };
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
            // 对安卓IOS刘海屏、异形屏 进行适配
            <SafeAreaView
                style={[{paddingTop: statusBarHeight, flex: 1, backgroundColor: 'rgba(0, 41, 84, 1.000)'}]}
            >
                <ScrollView>
                    <View style={styles.container}>
                        {
                            this.state.PackageType.map((item, index) => {
                                return (
                                    <ImageBackground style={styles.imagesStyle}
                                                     source={this.state.SelectPackNum === index ? this.state.BackgroundSelected : this.state.BackgroundUnselected}>
                                        <TouchableWithoutFeedback
                                            onPress={this.handleSelectItem.bind(this, item, index)}>
                                            <View style={styles.packageItem}>
                                                <View style={styles.packageItemLeft}>
                                                    <View style={styles.packageItemLeftBox}>
                                                        {
                                                            this.state.SelectPackNum === index ? (
                                                                <Feather name='check' size={20}
                                                                         color="#FFFFFF"></Feather>
                                                            ) : null
                                                        }
                                                        <Text
                                                            style={this.state.SelectPackNum !== index ? styles.packageItemLeftOne : styles.packageItemLeftThree}>{item.type}</Text>
                                                    </View>
                                                    <Text style={styles.packageItemLeftTwo}>{item.name}</Text>
                                                </View>
                                                <View style={styles.packageItemRight}>
                                                    <Text style={styles.packageItemRightOne}>¥{item.price}</Text>
                                                </View>
                                            </View>
                                        </TouchableWithoutFeedback>
                                    </ImageBackground>
                                )
                            })
                        }
                    </View>
                </ScrollView>
                <TouchableWithoutFeedback onPress={this.handleBuyPack}>
                    <View style={styles.btn}>
                        <Text style={styles.btntext}>购买</Text>
                    </View>
                </TouchableWithoutFeedback>
            </SafeAreaView>
        )
    }
    // 购买跳转
    handleBuyPack = () => {
        Actions.push('package_detail')
    }
    //选择对于的套餐
    handleSelectItem = (item, index) => {
        // if (this.state.SelectPackNum === index) {
        //     this.setState({
        //         SelectPackNum:null
        //     })
        // } else {
        this.setState({
            SelectPackNum: index
        })
        // }
    }
}
const styles = StyleSheet.create(
    {
        container: {
            marginTop: 50,
            flex: 1,
            alignItems: 'center',
            paddingBottom: 50 + deviceWidth * 0.4 * 0.2
        },
        packageItem: {
            height: deviceWidth * 0.85 * 0.38,
            width: deviceWidth * 0.85,
            flexDirection: 'row',
            alignItems: 'center',
            justifyContent: 'center'
        },
        imagesStyle: {
            height: deviceWidth * 0.85 * 0.38,
            width: deviceWidth * 0.85,
            marginTop: 20
        },
        packageItemLeft: {
            flex: 1,
            alignItems: 'center',
            justifyContent: 'center'
        },
        packageItemLeftBox: {
            flexDirection: "row",
            alignItems: 'center',
            height: 15,
            marginBottom: deviceWidth * 0.85 * 0.14,
        },
        packageItemRight: {
            flex: 1,
            alignItems: 'center',
            justifyContent: 'center'
        },
        packageItemLeftOne: {
            color: '#999999',
            fontSize: 15
        },
        packageItemLeftThree: {
            color: '#FFFFFF',
            fontSize: 15,
            marginLeft: 8
        },
        packageItemLeftTwo: {
            marginBottom: deviceWidth * 0.85 * 0.02,
            color: '#666666',
            fontSize: 18
        },
        packageItemRightOne: {
            color: '#666666',
            fontSize: 28,
            fontWeight: "bold"
        },
        btn: {
            flex: 1,
            position: "absolute",
            bottom: 50,
            right: "50%",
            marginRight: -(deviceWidth * 0.2),
            width: deviceWidth * 0.4,
            borderRadius: 10,
            justifyContent: 'center',
            alignItems: 'center',
            height: deviceWidth * 0.4 * 0.3,
            backgroundColor: 'rgba(0, 157, 250, 1.000)'
        },
        btntext: {
            color: 'white',
            fontSize: 15
        }
    });
