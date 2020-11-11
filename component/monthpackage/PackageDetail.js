/**
 * @name: PackageDetail
 * @author: LIULIU
 * @date: 2020-10-12 09:30
 * @description：PackageDetail
 * @update: 2020-10-12 09:30
 */
import React, {Component} from 'react';
import {
  Dimensions,
  NativeModules,
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableWithoutFeedback,
  View,
  Platform,
} from 'react-native';
import Feather from 'react-native-vector-icons/Feather';
import {Actions} from 'react-native-router-flux';

const {StatusBarManager} = NativeModules;
const deviceWidth = Dimensions.get('window').width;
const deviceHeight = Dimensions.get('window').height;
export default class PackageDetail extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }
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
        <View style={styles.Content}>
          <View style={styles.ContentIcon}>
            <Feather name="check" size={45} color="#FFFFFF" />
          </View>
          <Text style={styles.BuySuccessText}>购买成功</Text>
          <TouchableWithoutFeedback
            onPress={this.handleToOtherPath.bind(this, 'launch')}>
            <View style={styles.BtnOne}>
              <Text style={styles.BtnOneText}>返回主页面</Text>
            </View>
          </TouchableWithoutFeedback>
          <TouchableWithoutFeedback
            onPress={this.handleToOtherPath.bind(this, 'launch')}>
            <View style={styles.BtnTwo}>
              <Text style={styles.BtnTwoText}>查看订单</Text>
            </View>
          </TouchableWithoutFeedback>
        </View>
      </SafeAreaView>
    );
  }

  handleToOtherPath = (path) => {
    Actions.push(path);
  };
}
const styles = StyleSheet.create({
  Content: {
    marginTop: deviceHeight * 0.08,
    flex: 1,
    alignItems: 'center',
  },
  ContentIcon: {
    width: 75,
    height: 75,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(0, 157, 250, 1.000)',
    borderRadius: 50,
  },
  BuySuccessText: {
    color: '#fff',
    fontSize: 20,
    fontWeight: '400',
    marginTop: 20,
  },
  BtnOne: {
    width: deviceWidth * 0.4,
    height: deviceWidth * 0.12,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(0, 157, 250, 1.000)',
    borderRadius: deviceWidth * 0.03,
    marginTop: deviceWidth * 0.08,
  },
  BtnOneText: {
    color: '#fff',
    fontSize: 18,
  },
  BtnTwo: {
    width: deviceWidth * 0.4,
    height: deviceWidth * 0.12,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: deviceWidth * 0.03,
    borderColor: 'rgba(1, 122, 198, 1.000)',
    borderWidth: 1,
    marginTop: deviceWidth * 0.03,
  },
  BtnTwoText: {
    color: '#fff',
    fontSize: 18,
  },
});
