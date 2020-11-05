/**
 * @name: index
 * @author: LIULIU
 * @date: 2020-10-15 16:46
 * @description：index
 * @update: 2020-10-15 16:46
 */
import React, {Component} from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableWithoutFeedback,
  SafeAreaView,
  StatusBar,
  NativeModules,
  Dimensions,
} from 'react-native';
import FontAwesome5 from 'react-native-vector-icons/FontAwesome5';
import FontAwesome from 'react-native-vector-icons/FontAwesome';
import {Actions} from 'react-native-router-flux';
import {Toast, Provider} from '@ant-design/react-native';

const deviceHeight = Dimensions.get('window').height;
const deviceWidth = Dimensions.get('window').width;
const {StatusBarManager} = NativeModules;
export default class index extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    console.log(this.props.RouteMsg);
  }

  //支付
  handlePayMoney = () => {
    Toast.loading('正在支付', 3);
    setTimeout(() => Actions.push('route-pay-evaluate'), 3000);
  };

  render() {
    let statusBarHeight;
    if (Platform.OS === 'ios') {
      StatusBarManager.getHeight((height) => {
        statusBarHeight = height;
      });
    } else {
      statusBarHeight = StatusBar.currentHeight;
    }
    return (
      // 对安卓IOS刘海屏、异形屏 进行适配
      <SafeAreaView
        style={[
          {
            paddingTop: statusBarHeight,
            flex: 1,
            backgroundColor: 'rgba(0, 41, 84, 1.000)',
          },
        ]}>
        <Provider>
          <View style={styles.RoutePay}>
            <View style={styles.RoutePayHead}>
              <View style={styles.RoutePayHeadLeft}>
                <FontAwesome5
                  name="walking"
                  size={22}
                  color="#fff"
                  style={styles.RoutePayHeadLeftIcon}
                />
                <FontAwesome
                  name="subway"
                  size={22}
                  color="#fff"
                  style={styles.RoutePayHeadLeftIcon}
                />
              </View>
              <View style={styles.RoutePayHeadCenter}>
                <View style={styles.RoutePayHeadCenterCircle} />
                {['', '', ''].map((item, index) => {
                  return (
                    <View
                      style={[
                        styles.RoutePayHeadCenterCircleItem,
                        {marginTop: index === 0 ? 14 : null},
                      ]}
                    />
                  );
                })}
                <View style={styles.RoutePayHeadCenterCircle} />
                {['', '', ''].map((item, index) => {
                  return (
                    <View
                      style={[
                        styles.RoutePayHeadCenterCircleItem,
                        {marginTop: index === 0 ? 14 : null},
                      ]}
                    />
                  );
                })}
                <View style={styles.RoutePayHeadCenterCircle} />
                {false &&
                  ['', '', ''].map((item, index) => {
                    return (
                      <View
                        style={[
                          styles.RoutePayHeadCenterCircleItem,
                          {marginTop: index === 0 ? 14 : null},
                        ]}
                      />
                    );
                  })}
              </View>
              <View style={styles.RoutePayHeadRight}>
                <View style={styles.RoutePayHeadRightContent}>
                  <Text style={styles.RoutePayHeadRightText}>
                    中国评剧艺术中心
                  </Text>
                </View>
                <View style={styles.RoutePayHeadRightContent}>
                  <Text style={styles.RoutePayHeadRightText}>
                    北京南站 地铁站-D西南口
                  </Text>
                  <Text style={styles.RoutePayHeadRightPrice}>0元</Text>
                </View>
                <View style={styles.RoutePayHeadRightContent}>
                  <Text style={styles.RoutePayHeadRightText}>
                    建国门 地铁站
                  </Text>
                  <Text style={styles.RoutePayHeadRightPrice}>5元</Text>
                </View>
              </View>
            </View>
            <View style={styles.RoutePayPayMsg}>
              <Text style={styles.RoutePayPayMsgText}>共支付</Text>
              <Text style={styles.RoutePayPayMsgNum}>5.00 元</Text>
            </View>
            <View style={styles.RoutePayBtn}>
              <TouchableWithoutFeedback onPress={this.handlePayMoney}>
                <View style={styles.RoutePayBtnBox}>
                  <Text style={styles.RoutePayBtnText}>点击支付</Text>
                </View>
              </TouchableWithoutFeedback>
            </View>
          </View>
        </Provider>
      </SafeAreaView>
    );
  }
}
const styles = StyleSheet.create({
  RoutePay: {
    height: deviceHeight,
    width: deviceWidth,
  },
  RoutePayHead: {
    marginTop: deviceWidth * 0.2,
    flexDirection: 'row',
    justifyContent: 'center',
    // paddingTop:100
  },
  RoutePayHeadLeft: {
    flex: 2,
    alignItems: 'center',
    textAlign: 'center',
    justifyContent: 'space-around',
  },
  RoutePayHeadCenter: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  RoutePayHeadRight: {
    flex: 10,
    justifyContent: 'space-between',
  },
  RoutePayHeadCenterCircle: {
    width: 12,
    height: 12,
    borderRadius: 6,
    backgroundColor: '#FFF',
  },
  RoutePayHeadCenterCircleItem: {
    width: 4,
    height: 4,
    borderRadius: 2,
    backgroundColor: '#ccc',
    marginBottom: 7,
  },
  RoutePayHeadRightText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '500',
    flex: 4,
  },
  RoutePayHeadRightContent: {
    flexDirection: 'row',
    justifyContent: 'center',
  },
  RoutePayHeadRightPrice: {
    flex: 1,
    fontSize: 16,
    color: '#fff',
    fontWeight: '500',
  },
  RoutePayPayMsg: {
    marginTop: deviceWidth * 0.2,
    alignItems: 'center',
    justifyContent: 'center',
  },
  RoutePayPayMsgText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: '500',
  },
  RoutePayPayMsgNum: {
    color: '#fff',
    fontSize: 22,
    fontWeight: '500',
    marginTop: 14,
  },
  RoutePayBtn: {
    marginTop: deviceWidth * 0.1,
    alignItems: 'center',
  },
  RoutePayBtnBox: {
    width: deviceWidth * 0.3,
    backgroundColor: 'rgba(0, 157, 250, 1.000)',
    textAlign: 'center',
    height: deviceWidth * 0.1,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: deviceWidth * 0.04,
  },
  RoutePayBtnText: {
    color: '#fff',
    fontSize: 14,
    fontWeight: '500',
  },
});
