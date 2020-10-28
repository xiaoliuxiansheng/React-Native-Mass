/**
 * @name: Index
 * @author: LIULIU
 * @date: 2020-07-14 14:50
 * @description：Index
 * @update: 2020-07-14 14:50
 */
import React, {Component} from 'react';
import {View, Text, StyleSheet, Image, StatusBar, SafeAreaView, NativeModules} from 'react-native';
import Sospng from '../../images/SOS.png'
import Voicepng from '../../images/voice.png'
const { StatusBarManager } = NativeModules;
export default class Index extends Component {
    constructor(props) {
        super(props);
        this.state = {};
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
                style={[{ paddingTop: statusBarHeight,flex:1,backgroundColor:'rgba(0, 41, 84, 1.000)' }]}
            >
            <View style={styles.container}>
                <View style={styles.notice}>
                    <Text style={styles.noticeText}>紧急求助通道</Text>
                    <Text style={styles.noticeText}>请谨慎使用</Text>
                </View>
                <View style={styles.imagesButton}>
                    <Image
                        style={styles.imgone}
                        source={Voicepng}
                    />
                    <Image
                        style={styles.imgtwo}
                        source={Sospng}
                    />
                    <Image
                        style={styles.imgthree}
                        source={Voicepng}
                    />
                </View>
            </View>
            </SafeAreaView>
        )
    }
}
const styles = StyleSheet.create(
    {
        container: {
            flex: 1,
        },
        navbar: {
            paddingLeft: 15,
            paddingRight: 15,
            flexDirection: 'row',
            alignItems: 'center'
        },
        navbarText: {
            fontSize: 18,
            marginLeft: 5
        },
        notice: {
            marginTop: 80,
            justifyContent:'center',
            textAlign:'center'
        },
        noticeText: {
            fontSize: 30,
            textAlign:'center',
            lineHeight: 45,
            color:'#fff',
            fontWeight:'700'
        },
        imagesButton: {
            flexDirection: 'row',
            justifyContent:'center',
            marginTop: 180
        },
        imgone: {
            // flex:1,
            width:120,
            height:120,
            transform:[{rotate: "180deg" }]
        },
        imgtwo: {
            // flex:1,
            width:120,
            height:120,
            marginLeft:10,
            marginRight:10,
            backgroundColor: "#fff",
            borderRadius:60
        },
        imgthree: {
            // flex:1,
            width:120,
            height:120,}
    });
