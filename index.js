import { NativeModules } from 'react-native';

const { ContactTracing } = NativeModules;

export const ContactTracingStatus = {
    UNKNOWN: 0,
    ON: 1,
    OFF: 2,
};

export default ContactTracing;
