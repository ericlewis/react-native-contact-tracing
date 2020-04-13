# react-native-contact-tracing

A react-native native module for for Apple & Google's
[Contact Tracing Framework][privacy-preserving contact tracing].
<br>This work is based on @mattt's [Theoretical ContactTracingManager][ContactTracingManager] & Apple's `ContactTracing` [API Documentation][API Docs].

## Getting started

`$ npm install react-native-contact-tracing --save`

### Mostly automatic installation

`$ react-native link react-native-contact-tracing`

## Usage
```javascript
import ContactTracing from 'react-native-contact-tracing';
```

## License

This project has no affiliation with Apple or Google.

Information subject to copyright.
All rights reserved.

[privacy-preserving contact tracing]: https://www.apple.com/covid19/contacttracing
[ContactTracingManager]: https://gist.github.com/mattt/17c880d64c362b923e13c765f5b1c75a
[API Docs]: https://covid19-static.cdn-apple.com/applications/covid19/current/static/contact-tracing/pdf/ContactTracing-FrameworkDocumentation.pdf