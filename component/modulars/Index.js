/**
 * @name: Index
 * @author: LIULIU
 * @date: 2020-07-14 13:54
 * @description：Index
 * @update: 2020-07-14 13:54
 */
import React, {Component} from 'react';
import {View, StyleSheet} from 'react-native';
import Typeone from './Typeone';
import Typetwo from './Typetwo.js';
import Typethree from './Typethree.js';
import Typefour from './Typefour';

export default class Index extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <View style={styles.modalBody}>
        {+this.props.selectTab === 1 && <Typeone />}
        {+this.props.selectTab === 2 && <Typetwo />}
        {+this.props.selectTab === 3 && <Typethree />}
        {+this.props.selectTab === 4 && <Typefour />}
      </View>
    );
  }
}
const styles = StyleSheet.create({
  modalBody: {
    alignItems: 'center',
    justifyContent: 'center',
  },
});
