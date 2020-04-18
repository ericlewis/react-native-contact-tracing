// @ts-check

import React, {useEffect, useState} from 'react';
import {
  SafeAreaView,
  StyleSheet,
  Text,
} from 'react-native';

import ContactTracing, { ContactTracingStatus } from '../'

export default () => {
  const [state, setState] = useState(ContactTracingStatus.UNKNOWN);

  useEffect(() => {
    ContactTracing.start();
  }, []);

  useEffect(() => {
    async function getState() {
      const status = await ContactTracing.currentStatus();
      setState(status);
    }

    getState();
  }, [state]);

  return (
    <SafeAreaView style={styles.container}>
      <Text>Supported: {String(ContactTracing.getConstants()["supported"])}</Text>
      <Text>Status: {state}</Text>
    </SafeAreaView>
  )
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5FCFF',
    alignItems: 'center',
    justifyContent: 'center'
  },
});
