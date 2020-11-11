/**
 * @name: index
 * @author: LIULIU
 * @date: 2020-07-20 13:38
 * @description：index
 * @update: 2020-07-20 13:38
 */
/**
 * 网络请求相关
 * */
import {Toast} from '@ant-design/react-native';

export const BaseUrl = 'http://example.net/';

export default class Request {
  static get(url) {
    return new Promise((resolve, reject) => {
      fetch(BaseUrl + url)
        .then((response) => {
          if (response.ok) {
            return response.text();
          } else {
            throw new Error('网络请求失败！');
          }
        })
        .then((responseText) => {
          const responseJSObj = JSON.parse(responseText);
          resolve(responseJSObj);
        })
        .catch((error) => {
          Toast.fail('访问异常');
          reject(error);
        });
    });
  }

  /**
   * RN提供的fetch方法，是异步的，它本身就会返回一个Promise对象。但因为这里我们对它进行了封装，所以外面又包了一层Promise，来给fetch这个异步任务提供回调，这样外界才能拿到fetch的结果。
   *
   * @param url
   * @param params
   * @returns {Promise<any> | Promise}
   */
  static async post(url, params) {
    return new Promise(async (resolve, reject) => {
      fetch(BaseUrl + url, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(params),
      })
        .then((response) => {
          if (response.ok) {
            // 请求到的response其实是一个Response对象，它是一个很原始的数据格式，我们不能直接使用，先获取它的JSON字符串文本格式
            return response.text();
          } else {
            throw new Error('网络请求失败！');
          }
        })
        .then((responseText) => {
          // 然后把JSON字符串序列化为JS对象
          const responseJSObj = JSON.parse(responseText);
          // 把请求成功的数据传递出去
          resolve(responseJSObj);
        })
        .catch((error) => {
          // 把请求失败的信息传递出去
          Toast.fail('访问异常');
          reject(error);
        });
    });
  }
}
