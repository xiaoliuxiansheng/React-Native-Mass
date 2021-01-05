/**
 * @name: App
 * @author: LIULIU
 * @date: 2021-01-04 11:17
 * @description：App
 * @update: 2021-01-04 11:17
 */
import React from 'react';
import {NativeModules, Platform, StatusBar, StyleSheet} from 'react-native';
import {
  Scene,
  Router,
  ActionConst,
  Overlay,
  Modal,
  Stack,
  Lightbox,
} from 'react-native-router-flux';
import Home from './component/Home';
import Sos from './component/NeedHelp/Index.js';
import MonthPackages from './component/monthpackage/index.js';
import PackageDetail from './component/monthpackage/PackageDetail';
import RoutePlan from './component/RoutePlan/index.js';
import RoutePlanDetail from './component/RoutePlan/detail';
import RoutePay from './component/RoutePay/index.js';
import RoutePayEvaluate from './component/RoutePay/evaluate';
import Undevelopment from './component/undevelopment';
import {Provider} from 'mobx-react';
import store from './store/index.js';

const {StatusBarManager} = NativeModules;
let statusBarHeight;
if (Platform.OS === 'ios') {
  StatusBarManager.getHeight((height) => {
    statusBarHeight = height;
  });
} else {
  statusBarHeight = StatusBar.currentHeight;
}
const styles = StyleSheet.create({
  scene: {
    flex: 1,
    backgroundColor: 'rgba(0, 41, 84, 1.000)',
    shadowOpacity: 1,
    shadowRadius: 3,
    paddingTop: 2,
  },
});

const stateHandler = (prevState, newState, action) => {
  console.log('onStateChange: ACTION:', action);
};
// on Android, the URI prefix typically contains a host in addition to scheme
const prefix = Platform.OS === 'android' ? 'mychat://mychat/' : 'mychat://';

const Example = () => (
  <Provider {...store}>
    <Router
      onStateChange={stateHandler}
      sceneStyle={styles.scene}
      uriPrefix={prefix}>
      <Overlay key="overlay">
        <Modal key="modal" hideNavBar>
          <Lightbox key="lightbox">
            <Stack key="root" titleStyle={{alignSelf: 'center'}} hideNavBar>
              <Scene
                key="launch"
                component={Home}
                title="Launch"
                initial
                type={ActionConst.RESET}
              />
              <Stack
                back
                backTitle="Back"
                backButtonTintColor="#fff"
                key="undevelopment"
                titleStyle={{color: '#fff'}}
                duration={0}
                navTransparent>
                <Scene key="undevelopment" component={Undevelopment} />
              </Stack>
              <Stack
                back
                backTitle="Back"
                backButtonTintColor="#fff"
                key="monthpackage"
                title="月租套餐"
                titleStyle={{color: '#fff'}}
                duration={0}
                navTransparent>
                <Scene key="monthpackage" component={MonthPackages} />
              </Stack>
              <Stack
                back
                backTitle="Back"
                backButtonTintColor="#fff"
                key="package_detail"
                titleStyle={{color: '#fff'}}
                duration={0}
                navTransparent>
                <Scene key="package_detail" component={PackageDetail} />
              </Stack>
              <Stack
                back
                backTitle="Back"
                key="needhelp"
                backButtonTintColor="#fff"
                titleStyle={{color: '#fff'}}
                duration={0}
                navTransparent>
                <Scene key="needhelp" component={Sos} />
              </Stack>
              <Stack
                back
                backTitle="Back"
                key="routeplan"
                backButtonTintColor="#fff"
                titleStyle={{color: '#fff'}}
                duration={0}
                navTransparent>
                <Scene key="routeplan" component={RoutePlan} />
              </Stack>
              <Stack
                back
                backTitle="Back"
                key="route_plan_detail"
                backButtonTintColor="#fff"
                titleStyle={{color: '#fff'}}
                duration={0}
                navTransparent>
                <Scene key="route_plan_detail" component={RoutePlanDetail} />
              </Stack>
              <Stack
                back
                backTitle="Back"
                backButtonTintColor="#fff"
                key="routePay"
                title="行程支付"
                titleStyle={{color: '#fff'}}
                duration={0}
                navTransparent>
                <Scene key="routePay" component={RoutePay} />
              </Stack>
              <Stack
                back
                backTitle="Back"
                backButtonTintColor="#fff"
                key="route-pay-evaluate"
                title="行程评价"
                titleStyle={{color: '#fff'}}
                duration={0}
                navTransparent>
                <Scene key="route-pay-evaluate" component={RoutePayEvaluate} />
              </Stack>
            </Stack>
          </Lightbox>
        </Modal>
      </Overlay>
    </Router>
  </Provider>
);

export default Example;
