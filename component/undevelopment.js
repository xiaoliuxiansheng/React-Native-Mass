/**
 * @name: Undevelopment
 * @author: LIULIU
 * @date: 2020-07-13 09:52
 * @description：Undevelopment
 * @update: 2020-07-13 09:52
 */
import React, {Component} from 'react';
import {View, Text, StyleSheet} from 'react-native';
import Ionicons from 'react-native-vector-icons/Ionicons';

export default class Undevelopment extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <View style={styles.Undevelopmentbox}>
        <Text style={styles.UndevelopmentboxText}>该模块暂未开放</Text>
        <Ionicons name="lock-closed-sharp" color="#fff" size={50} />
      </View>
    );
  }
}
const styles = StyleSheet.create({
  Undevelopmentbox: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(0, 41, 84, 1.000)',
  },
  UndevelopmentboxText: {
    color: '#fff',
    fontSize: 24,
    paddingBottom: 15,
  },
});
