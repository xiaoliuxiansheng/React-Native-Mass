/**
 * @name: Index
 * @author: LIULIU
 * @date: 2020-07-14 14:50
 * @description：Index
 * @update: 2020-07-14 14:50
 */
import React, {Component} from 'react';
import {
  View,
  Text,
  StyleSheet,
  Image,
  StatusBar,
  SafeAreaView,
  NativeModules,
  Platform,
  Animated,
  Easing,
  TouchableWithoutFeedback,
} from 'react-native';
import Sospng from '../../images/SOS.png';
import Voicepng from '../../images/voice.png';

const {StatusBarManager} = NativeModules;
export default class Index extends Component {
  constructor(props) {
    super(props);
    this.state = {
      offset: new Animated.Value(0),
      opacity: new Animated.Value(0),
      show: false,
    };
  }

  // 弹窗动画 弹出
  in() {
    // Animated.loop(
    //   // eslint-disable-next-line no-undef
    //   parallel([
    //     Animated.timing(this.state.offset, {
    //       easing: Easing.linear,
    //       duration: 500,
    //       toValue: 20,
    //     }),
    //     Animated.timing(this.state.opacity, {
    //       easing: Easing.linear,
    //       duration: 200,
    //       toValue: 1,
    //     }),
    //   ]),
    // ).start();
    const animationSlider = Animated.sequence([
      Animated.timing(this.state.offset, {
        easing: Easing.linear,
        duration: 500,
        toValue: 20,
      }),
      Animated.timing(this.state.opacity, {
        easing: Easing.bezier(.79,.01,.33,1.01),
        duration: 500,
        toValue: 1,
      }),
    ]);
    Animated.loop(animationSlider).start();
  }

  // 弹窗动画下拉
  out() {
    Animated.parallel([
      Animated.timing(this.state.offset, {
        easing: Easing.linear,
        duration: 500,
        toValue: 0,
      }),
      Animated.timing(this.state.opacity, {
        easing: Easing.linear,
        duration: 100,
        toValue: 0,
      }),
    ]).start();

    setTimeout(() => this.setState({show: false}), 1500);
  }

  show() {
    this.setState(
      {
        show: true,
      },
      this.in(),
    );
  }
  handleOpen = () => {
    this.show();
    setTimeout(() => {
      this.setState(
        {
          show: false,
        },
        this.out(),
      );
    }, 10000);
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
        <View style={styles.container}>
          <View style={styles.notice}>
            <Text style={styles.noticeText}>紧急求助通道</Text>
            <Text style={styles.noticeText}>请谨慎使用</Text>
          </View>
          <View style={styles.imagesButton}>
            <View style={styles.imagesButtonItem}>
              {this.state.show && (
                <Animated.View
                  style={[
                    {
                      opacity: this.state.opacity,
                      // transform: [
                      //   {
                      //     translateX: this.state.offset.interpolate({
                      //       inputRange: [0, 1],
                      //       outputRange: [1, 0],
                      //     }),
                      //   },
                      // ],
                    },
                  ]}>
                  <Image style={[styles.imgone]} source={Voicepng} />
                </Animated.View>
              )}
            </View>
            <View style={styles.imagesButtonItem}>
              <TouchableWithoutFeedback onPress={() => this.handleOpen()}>
                <Image style={styles.imgtwo} source={Sospng} />
              </TouchableWithoutFeedback>
            </View>
            <View style={styles.imagesButtonItem}>
              {this.state.show && (
                <Animated.View
                  style={[
                    {
                      opacity: this.state.opacity,
                    },
                  ]}>
                  <Image style={[styles.imgthree]} source={Voicepng} />
                </Animated.View>
              )}
            </View>
          </View>
        </View>
      </SafeAreaView>
    );
  }
}
const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  navbar: {
    paddingLeft: 15,
    paddingRight: 15,
    flexDirection: 'row',
    alignItems: 'center',
  },
  navbarText: {
    fontSize: 18,
    marginLeft: 5,
  },
  notice: {
    marginTop: 80,
    justifyContent: 'center',
    textAlign: 'center',
  },
  noticeText: {
    fontSize: 30,
    textAlign: 'center',
    lineHeight: 45,
    color: '#fff',
    fontWeight: '700',
  },
  imagesButton: {
    flexDirection: 'row',
    justifyContent: 'center',
    marginTop: 180,
  },
  imagesButtonItem: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
  },
  imgone: {
    width: 120,
    height: 120,
    transform: [{rotate: '180deg'}],
  },
  imgtwo: {
    width: 120,
    height: 120,
    // marginLeft: 10,
    // marginRight: 10,
    backgroundColor: '#fff',
    borderRadius: 60,
  },
  imgthree: {
    width: 120,
    height: 120,
  },
});
