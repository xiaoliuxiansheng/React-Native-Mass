import React, {Component} from "react";
import {
    FlatList,
    StyleSheet,
    Text,
    View,
    PermissionsAndroid,
    Platform,
    Dimensions,
    BackHandler,
    Alert
} from "react-native";
import {Toast, Provider} from "@ant-design/react-native"
import {MapView} from "react-native-amap3d";

const deviceHeight = Dimensions.get("window").height - 65;
const deviceWidth = Dimensions.get("window").width;
import {observer, inject} from 'mobx-react';
import {Actions} from 'react-native-router-flux'
@inject("homeStore")
@observer
export default class EventsExample extends Component {
    constructor(props) {
        super(props);
        this.state = {
            logs: [],
            coordinate: {
                latitude: 39.91095,
                longitude: 116.37296
            },
            mapType: "standard",
            lastBackPressed: 0
        }
    }

    async componentDidMount() {
        await PermissionsAndroid.requestMultiple([
            PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
            PermissionsAndroid.PERMISSIONS.ACCESS_COARSE_LOCATION,
        ]);
        if (Platform.OS === 'android') {
            BackHandler.addEventListener('hardwareBackPress', this.backAction);
        }
    }

    componentWillUnmount() {
        if (Platform.OS === 'android') {
            BackHandler.removeEventListener('hardwareBackPress', this.backAction);
        }
    }

    backAction = () => {
        if (Actions.prevScene === 'launch'||Actions.prevScene === null) {
            if (this.state.lastBackPressed && this.state.lastBackPressed + 2000 >= Date.now()) {
                //最近2秒内按过back键，可以退出应用。
                // return false;
                BackHandler.exitApp();//直接退出APP
            } else {
                this.state.lastBackPressed = Date.now();
                Toast.info('再按一次退出应用', 7);//提示
                return true;
            }
        }
    };

    handelGetamapData = async () => {
        await fetch('https://restapi.amap.com/v3/place/text?keywords=北京大学&offset=20&page=1&key=&extensions=all&page=1', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: ''
        }).then((response) => response.json())
            .then((json) => {
                this.setState({
                    searchData: json.pois
                })
            }).catch((err) => console.log(err)).finally(() => console.log('finally'))
    }
    _log = async (event, data) => {
        if (data.latitude > 0 && data.longitude > 0) {
            const {handleSavedefineDesti} = this.props.homeStore
            await this.DEBOUNCE(handleSavedefineDesti(data), 5000)
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
        } else {
            Toast.loading('正在获取当前位置', 1);
        }

    }
    // 输入地址搜索时 防抖
    DEBOUNCE = (fn, wait) => {
        let timeout = null;
        return function () {
            if (timeout !== null) clearTimeout(timeout);
            timeout = setTimeout(fn, wait);
        }
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

    render() {
        const {coordinate} = this.state
        return (
            <View>
                <Provider>
                    <MapView
                        style={styles.absoluteFill}
                        locationEnabled
                        // 定位间隔(ms)
                        locationInterval={10000}
                        //  定位的最小更新距离
                        distanceFilter={10}
                        //
                        showsTraffic={true}
                        zoomLevel={14}
                        onLocation={this._logLocationEvent}
                        // 设置地图中心 这个地图插件有时候设置center可以 有时候设置coordinate可以
                        center={{
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude,
                        }}
                        coordinate={{
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude,
                        }}
                    />
                </Provider>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    absoluteFill: {
        height: deviceHeight,
        width: deviceWidth
    }
})
