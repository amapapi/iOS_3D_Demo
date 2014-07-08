iOS_3D_Demo
===========

高德 iOS 3D SDK 官方Demo

### 前述

- [高德官方网站申请key](http://id.amap.com/?ref=http%3A%2F%2Fapi.amap.com%2Fkey%2F).
- 阅读[参考手册](http://api.amap.com/Public/reference/iOS%20API%20v2_3D/).
- 如果有任何疑问也可以发问题到[官方论坛](http://bbs.amap.com/forum.php?gid=1).

### 架构

#### Controllers
- `<UIViewController>`
  * `MainViewController`
  * `BaseMapViewController`
    - `MapTypeViewController`
    - `TrafficViewController`
    - `GestureAttributesViewController`
    - `AddGestureViewController`
    - `OverlayViewController`
    - `CustomOverlayViewController`
    - `GeodesicViewController`
    - `GroundOverlayViewController`
    - `TileOverlayViewController`
    - `AnnotationViewController`
    - `CustomAnnotationViewController`
    - `AnimatedAnnotationViewController`
    - `UserLocationViewController`
    - `ScreenShotViewController`
    - `OfflineViewController`
    - `TouchPoiViewController`
    - `CoreAnimationViewController`
    - `CustomUserLocationViewController`

#### Models

* `Conform to <MAAnnotation>`
  - `AnimatedAnnotation`
  - `BusStopAnnotation`
  - `GeocodeAnnotation`
  - `POIAnnotation`
  - `ReGeocodeAnnotation`
  
* `Conform to <MAOverlay>`
  - `FaceOverlay`
  - `LineDashPolyline`

#### Views

* `MAAnnotationView`
  - `AnimatedAnnotationView`
  - `CusAnnotationView`

* `MAHeaderView`
* `CustomCalloutView`
