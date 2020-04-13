import React, {Component} from 'react';
import {
  SafeAreaView,
  StyleSheet,
  Text,
} from 'react-native';

import ContactTracing from '../'

export default class App extends Component {
  render() {
    return (
      <SafeAreaView style={styles.container}>
        <Text>Supported: {JSON.stringify(ContactTracing.getConstants()["supported"])}</Text>
      </SafeAreaView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5FCFF',
    alignItems: 'center',
    justifyContent: 'center'
  },
});
