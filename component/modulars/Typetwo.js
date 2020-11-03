import React, { Component } from "react";
import { FlatList, StyleSheet, Text, View, PermissionsAndroid, Platform, Dimensions} from "react-native";
import { MapView} from "react-native-amap3d";
import AntDesign from "react-native-vector-icons/AntDesign"
import { Toast } from "teaset"
const deviceHeight = Dimensions.get("window").height-65;
const deviceWidth = Dimensions.get("window").width;
import {observer, inject} from 'mobx-react';
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
            }
        }
    }
    async componentDidMount() {
        await PermissionsAndroid.requestMultiple([
            PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
            PermissionsAndroid.PERMISSIONS.ACCESS_COARSE_LOCATION,
        ]);
    }

    handelGetamapData = async () =>{
        await fetch('https://restapi.amap.com/v3/place/text?keywords=北京大学&offset=20&page=1&key=&extensions=all&page=1',{
            method: 'GET',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body:''
        }).then((response) => response.json())
            .then((json) =>{
                this.setState({
                    searchData:json.pois
                })
            }).catch((err) =>console.log(err)).finally(()=>console.log('finally'))
    }
    _log = async(event, data) =>{
        const {handleSavedefineDesti} = this.props.homeStore
        await this.DEBOUNCE(handleSavedefineDesti(data),5000)
        this.setState({
            coordinate:{
                latitude:data.latitude,
                longitude:data.longitude
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
        this.forceUpdate()
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

    _renderItem = ({ item }) => (
        <Text style={styles.logText}>
            {item.time} {item.event}: {item.data}
        </Text>
    );

    render() {
        const {coordinate} = this.state
        return (
            <View>
                <MapView
                    style={styles.absoluteFill}
                    locationEnabled
                    // 定位间隔(ms)
                    locationInterval={3000}
                    //  定位的最小更新距离
                    distanceFilter={10}
                    //
                    showsTraffic = {true}
                    zoomLevel = {14}
                    onLocation={this._logLocationEvent}
                    // 设置地图中心
                    center={{
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude,
                    }}
                    coordinate={{
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude,
                    }}
                />
            </View>
        );
    }
}
const styles = StyleSheet.create({
    absoluteFill:{
        height:deviceHeight,
        width:deviceWidth
    }
})
