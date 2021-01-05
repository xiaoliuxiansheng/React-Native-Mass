/**
 * @name: home
 * @author: LIULIU
 * @date: 2020-07-15 09:39
 * @description：home
 * @update: 2020-07-15 09:39
 */
import {observable, action} from 'mobx';
import Request from '../server/index.js';

class homeStore {
  @observable defineTab = 1; //首页默认tab
  @observable amapDataUrl = 'https://restapi.amap.com/v3/place/text';
  @observable amapkey = 'd207dad876b4fcf23c1addfc4cebbf74';
  @observable defineDestination = {}; //默认起点信息 为定位点
  @observable departureLocation = null; //起点经纬度
  @observable departure = null; // 起点名称
  @observable destination = null; // 终点名称
  @observable destinationLocation = null; // 终点经纬度
  /**
   * 保存起点位置
   * */
  @action
  handleSaveDeparture = (tab, name) => {
    this.departureLocation = tab;
    this.departure = name;
  };
  /**
   * 保存终点位置
   * */
  @action
  handleSaveDestination = (tab, name) => {
    this.destinationLocation = tab;
    this.destination = name;
  };
  /**
   * 设置tab
   * */
  @action
  handleSaveTab = (tab) => {
    this.defineTab = tab;
  };
  /**
   * 设置默认起点信息
   * */
  @action
  handleSavedefineDesti = async (msg) => {
    fetch(
      `https://restapi.amap.com/v3/geocode/regeo?location=${msg.longitude},${msg.latitude}&key=${this.amapkey}`,
      {
        method: 'GET',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: '',
      },
    )
      .then((response) => response.json())
      .then((json) => {
        // if (json.regeocode) {
        this.defineDestination = json.regeocode;
        // }
      })
      .catch((err) => console.log(err))
      .finally(() => console.log('finally'));
  };
}

export default new homeStore();
