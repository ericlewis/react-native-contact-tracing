# react-native-contact-tracing

:warning: I do not own the `react-native-contact-tracing` package on npm. My package will remain unpublished until the official frameworks are released. The current owner of `react-native-contact-tracing` has a boilerplate project published to it and is in no way related to this repository. Until I can contact the owner of the package or find a better name: **do not install this package from the directions below, they are placeholders only.**

A native module for Apple & Google's
[Contact Tracing Framework][privacy-preserving contact tracing].
<br><br>This work is based on [mattt's](https://github.com/mattt) theoretical [ContactTracingManager][ContactTracingManager], Apple's `ContactTracing` [API Documentation][API Docs] & Google's [Android API Docs][Android API Docs].

**Help welcome for Android! see issue #1**

## Getting started

`$ npm install react-native-contact-tracing --save`

### Mostly automatic installation

`$ react-native link react-native-contact-tracing`

## Usage

### Example

```javascript
import ContactTracing from 'react-native-contact-tracing';

contactTracing.start();
```

## Methods

### Summary

* [`start`](#start)
* [`stop`](#stop)
* [`requestExposureSummary`](#requestexposuresummary)

---

### Details

#### `start()`

```javascript
await contactTracing.start();
```

Begin contact tracing, asking for permissions if need be. This returns a promise that resolves if tracing began successfully.

---

#### `stop()`

```javascript
await contactTracing.stop();
```

Stops contact tracing, this also returns a promise that resolves if tracing ended successfully.

---

#### `requestExposureSummary()`

```javascript
const { matchedKeyCount, contactInformation } = await contactTracing.requestExposureSummary();
```

Provides a summary on exposures. This returns a promise that resolves to an object containing the matchedKeyCount & an array of CTContactInfo objects.

---


## License

This project has no affiliation with Apple or Google.

Information subject to copyright.
All rights reserved.

[privacy-preserving contact tracing]: https://www.apple.com/covid19/contacttracing
[ContactTracingManager]: https://gist.github.com/mattt/17c880d64c362b923e13c765f5b1c75a
[API Docs]: https://covid19-static.cdn-apple.com/applications/covid19/current/static/contact-tracing/pdf/ContactTracing-FrameworkDocumentation.pdf
[Android API Docs]: https://www.blog.google/documents/55/Android_Contact_Tracing_API.pdf
