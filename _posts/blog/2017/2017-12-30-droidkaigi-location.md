---
layout: post
title: "[번역] DroidKaigi 2017 ~ 위치 정보를 정확하게 트래킹하는 기술"
date: 2017-12-30 18:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ 위치 정보를 정확하게 트래킹하는 기술](https://speakerdeck.com/mizutori/wei-zhi-qing-bao-wozheng-que-nitoratukingusuruji-shu) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, 위치 정보를 정확하게 트래킹하는 기술

水鳥敬満 (Takamitsu Mizutori)

@mizutory

## 2p, 자기소개

SonyEricsson 에서 휴대폰의 개발을 Xperia X10까지 했습니다. (DeviceDriver, BootCode, MemoryManager)

Goldrush Computing 회사를 시작

위치 정보를 사용한 Android / iOS 앱을 개발해왔습니다.

## 4p

위치 정보 취득 → 지도에 그리기 → 위치 정보 필터링 → 배터리 소모에 대해서

## 5p

위치 정보 취득

## 6p, 위치 정보 트래킹을 위한 아키텍처

| :--: | :--: | :--: |
|   | --start--> |   |
| MainActivity | --bind--> | LocationService |
|   | <--onServiceConnected-- |   |

## 7p, LocationManager

```
LocationManager locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
Criteria criteria = new Criteria();
criteria.setAccuracy(Criteria.ACCURACY_FINE);
criteria.setPowerRequirement(Criteria.POWER_HIGH);
criteria.setAltitudeRequired(false);
criteria.setSpeedRequired(true);
criteria.setCostAllowed(true);
criteria.setBearingRequired(false);

//API level 9 and up
criteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
criteria.setVerticalAccuracy(Criteria.ACCURACY_HIGH);

Integer gpsFreqInMillis = 1000;
Integer gpsFreqInDistance = 5; // in meters

locationManager.addGpsStatusListener(this);
locationManager.requestLocationUpdates(gpsFreqInMillis,
      gpsFreqInDistance,
      criteria, this, null);
```

## 8p, Criteria 작성

```
Criteria criteria = new Criteria();
criteria.setAccuracy(Criteria.ACCURACY_FINE);
criteria.setPowerRequirement(Criteria.POWER_HIGH);
criteria.setAltitudeRequired(false);
criteria.setSpeedRequired(true);
criteria.setCostAllowed(true);
criteria.setBearingRequired(false);

//API level 9 and up
criteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
criteria.setVerticalAccuracy(Criteria.ACCURACY_HIGH);
```

## 9p, 위치 정보 취득시의 콜백 - onLocationChanged

```
public void onLocationChanged(final Location newLocation) {
   if(isLogging) {
      //locationList.add(newLocation);
      filterAndAddLocation(newLocation);
   }

   Intent intent = new Intent("LocationUpdated");
   intent.putExtra("location", newLocation);
   LocalBroadcastManager.getInstance(this.getApplication()).sendBroadcast(intent);
}
```

여기서 Location 객체를 얻어 LocalBroadcastManager을 사용해 서비스의 외부에 알린다.

## 10p

지도에 그리기

## 11p, MapAPIKey 취득

```
<meta-data
   android:name="com.google.android.geo.API_KEY"
   android:value="YOUR_API_KEY"/>
```

## 12p, gradle

```
dependencies {
   compile fileTree(dir: 'libs', include: ['*.jar'])
   testCompile 'junit:junit:4.12'
   compile 'com.android.support:appcompat-v7:23.3.0'
   compile 'com.google.android.gms:play-services-maps:9.8.0'
   compile 'com.google.android.gms:play-services-appindexing:9.8.0'
}
```

## 13p, MapView

```
<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
   xmlns:tools="http://schemas.android.com/tools"
   android:layout_width="match_parent"
   android:layout_height="match_parent"
   tools:context="com.goldrushcomputing.androidlocationstarterkit.MainActivity">
   
   <com.google.android.gms.maps.MapView
      android:id="@+id/map"
      android:layout_width="match_parent"
      android:layout_height="match_parent" /> 
```

## 14p

```
mapView = (MapView) this.findViewById(R.id.map);
mapView.onCreate(savedInstanceState);
mapView.getMapAsync(new OnMapReadyCallback() {
   @Override
   public void onMapReady(GoogleMap googleMap) {
      map = googleMap;
      map.getUiSettings().setZoomControlsEnabled(false);
      map.setMyLocationEnabled(false);
      map.getUiSettings().setCompassEnabled(true);
      map.getUiSettings().setMyLocationButtonEnabled(true); 
```

- 줌 컨트롤을 숨긴다.
- 자신의 위치를 나타내는 인디게이터를 숨긴다. (나중에 자신이 그린다)
- 나침반 기능을 켠다
- 현재 위치로 이동하는 버튼을 표시한다

## 15p, 지도 위에 그리기

LocationService → Location → MainActivity

## 16p, 지도 위에 그리기

map.addCircle()

```
this.locationAccuracyCircle = map.addCircle(new CircleOptions()
         .center(latLng)
         .fillColor(Color.argb(64, 0, 0, 0))
         .strokeColor(Color.argb(64, 0, 0, 0))
         .strokeWidth(0.0f)
         .radius(location.getAccuracy())); // set radius to horizontal accuracy in method
```

## 17p, 지도 위에 그리기

map.addMarker() 

> (확대해도 동일한 크기)

```
userPositionMarker = map.addMarker(new MarkerOptions()
         .position(latLng)
         .flat(ture)
         .anchor(0.5f, 0.5f)
         .icon(this.userPositionMarkerBitmapDescriptor));
```

## 18p, 지도 위에 그리기

map.addPolyline()

```
this.runningPathPolyline = map.addPolyline(new PolylineOptions()
         .add(from, to)
         .width(polylineWidth)
         .color(Color.parseColor("#801B60FE"))
         .geodesic(true));
```

## 20p

필터링

## 21p

취득 시간으로 필터링하기

## 22p, 위치 정보 취득 타이밍에 영향을 주는 것

- GPS 위성의 위치 (머리 위에 많이 있는지)
- 위성 및 Android 기기 사이의 장애물 (건물, 나무, 구름 등)
- 휴대 전화 기지국 위치 (근처에 많이 있는지)
- 휴대 전화 기지국 및 Android 기기 사이의 장애물 상황

오래된 위치 정보 → 캐시된 위치 정보

## 23p, 위치 정보의 오래됨을 측정해서 필터링

```
long age = getLocationAge(location);

if(age > 5 * 1000){ //more than 5 seconds
   Log.d(TAG, "Location is old");
   oldLocationList.add(location);
   return false;
}
```

```
private long getLocationAge(Location newLocation){
   long locationAge;
   if(android.os.Build.VERSION.SDK_INT >= 17) {
      long currentTimeInMilli = (long)(SystemClock.elapsedRealtimeNanos() / 1000000);
      long locationTimeInMilli = (long)(newLocation.getElapsedRealtimeNanos() / 1000000);
      locationAge = currentTimeInMilli - locationTimeInMilli;
   } else{
      locationAge = System.currentTimeMillis() - newLocation.getTime();
   }
   return locationAge;
}
```

## 24p

수평 정밀도로 필터링

## 25p, 수평 정밀도가 얻어지지 않는 케이스를 무시

```
if(location.getAccuracy() <= 0) {
   Log.d(TAG, "Latitidue and longitude values are invalid.");
   noAccuracyLocationList.add(location);
   return false;
} 
```

Android - Location.getAccuracy() returns negative accuracy

I've had the following crash happen in my app, once to me, and once in the wild. It happens when I draw a radius circle around the map and the accuracy is negative. I can't reproduce the issue though other than hard coding a negative value.

Seen on a Moto G gen1 (4.4.4) and Samsung Galaxy S3 (4.4.2)

>  [https://stackoverflow.com/questions/34232835/android-location-getaccuracy-returns-negative-accuracy](https://stackoverflow.com/questions/34232835/android-location-getaccuracy-returns-negative-accuracy)

## 26p, 수평 정밀도로 필터링

```
float horizontalAccuracy = location.getAccuracy();
if(horizontalAccuracy > 10){ //10meter filter
   Log.d(TAG, "Accuracy is too low.");
   inaccurateLocationList.add(location);
   return false;
}
```

## 27p

필터한 사례

## 28p, getAccuracy()의 정밀도는 68%

```
getAccuracy

float getAccuracy ()

Get the estimated horizontal accuracy of this location, radial, in meters.

We define horizontal accuracy as the radius of 68% confidence. In other words, if you draw a circle centered at this location's latitude and longitude, and with a radius equal to the accuracy, then there is a 68% probability that the true location is inside the circle.

In statistical terms, it is assumed that location errors are random with a normal distribution, so the 68% confidence circle represents one standard deviation. Note that in practice, location errors do not always follow such a simple distribution.
```

## 29p, KalmanFilter으로 필터링

```
/* Kalman Filter */
float Qvalue;

long locationTimeInMillis = (long)(location.getElapsedRealtimeNanos() / 1000000);
long elapsedTimeInMillis = locationTimeInMillis - runStartTimeInMillis;

if(currentSpeed == 0.0f){
   Qvalue = 3.0f; //3 meters per second
}else{
   Qvalue = currentSpeed; // meters per second
}

kalmanFilter.Process(location.getLatitude(), location.getLongitude(), location.getAccuracy(), elapsedTimeInMillis, Qvalue);
double predictedLat = kalmanFilter.get_lat();
double predictedLng = kalmanFilter.get_lng();

Location predictedLocation = new Location("");//provider name is unecessary
predictedLocation.setLatitude(predictedLat);//your coords of course
predictedLocation.setLongitude(predictedLng);
float predictedDeltaInMeters = predictedLocation.distanceTo(location);

if(predictedDeltaInMeters > 60){
   Log.d(TAG, "Kalman Filter detects mal GPS, we should probably remove this from track");
   kalmanFilter.consecutiveRejectCount += 1;

   if(kalmanFilter.consecutiveRejectCount > 3){
      kalmanFilter = new KalmanLatLong(3); //reset Kalman Filter if it rejects more than 3 times in raw.
   }
   kalmanNGLocationList.add(location);
   return false;
}else{
   kalmanFilter.consecutiveRejectCount = 0;
}
```

## 30p ~ 34p

KalmanFilter으로 필터링

## 35p

배터리

## 36p, 30분、5-6km로 소비량

|   | 시간(초) | 거리(m) | GPS 갯수 | 배터리 (시작시) | 배터리 (종료) | 소비량 | 42km 달렸을 경우 | 5시간 달렸을 경우 |
| :-- | --: | --: | --: | --: | --: | --: | --: | --: |
| Nexus6 Low Battery (every 5m) | 1968 | 5710.0 | 790 | 16% | 12% | 4% | 29.6% | 36.6% |
| Nexus6p Mid Battery (every 1m) | 1785 | 5738.8 | 1349 | 50% | 48% | 2% | 14.7% | 20.1% |
| Nexus6 Low Battery (every 5m) | 1497 | 4583.8 | 581 | 22% | 20% | 2% | 18.4% | 24% |
| Nexus6p High Battery (every 5m) | 1684 | 5036.0 | 675 | 98% | 95% | 3% | 25.1% | 32% |

## 37p, 남은 배터리 취득

```
private BroadcastReceiver batteryInfoReceiver = new BroadcastReceiver(){

   @Override
   public void onReceive(Context ctxt, Intent intent) {
      int batteryLevel = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, 0);
      int scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
      
      float batteryLevelScaled = batteryLevel / (float)scale;
      
      batteryLevelArray.add(Integer.valueOf(batteryLevel));
      batteryLevelScaledArray.add(Float.valueOf(batteryLevelScaled));
      batteryScale = scale;
   }
}; 
```
↓
```
registerReceiver(this.batteryInfoReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
```

## 38p, 남은 배터리를 고려한 설계

1. 남은 배터리에 따라 Criteria를 바꾼다
2. Minimum Distance와 Minimum Time은 바꿔도 GPS 칩이 소비하는 에너지는 같다. 위치 정보를 받은 후 처리에 에너지를 사용하는 경우 (서버에 전송 등)은 Minimum Distance와 Minimum Time 값을 크게 한다.

```
LocationManager locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);

Criteria criteria = new Criteria();
criteria.setAccuracy(Criteria.ACCURACY_FINE);
criteria.setPowerRequirement(Criteria.POWER_HIGH);
criteria.setAltitudeRequired(false);
criteria.setSpeedRequired(true);
criteria.setCostAllowed(true);
criteria.setBearingRequired(false);

//API level 9 and up
criteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
criteria.setVerticalAccuracy(Criteria.ACCURACY_HIGH);

Integer gpsFreqInMillis = 1000;
Integer gpsFreqInDistance = 5; // in meters

locationManager.addGpsStatusListener(this);

locationManager.requestLocationUpdates(gpsFreqInMillis,
         gpsFreqInDistance,
         criteria, this, null); 
```

## 39p, Minimum Distance와 Minimum Time를 바꾼 경우의 배터리 소비량

|   | 시간(초) | 거리(m) | GPS 갯수 | 배터리 (시작시) | 배터리 (종료) | 소비량 | 42km 달렸을 경우 | 5시간 달렸을 경우 |
| :-- | --: | --: | --: | --: | --: | --: | --: | --: |
| Nexus6p Mid Battery (every 1m, 1sec) | 1785 | 5738.8 | 1349 | 50% | 48% | 2% | 14.7% | 20.1% |
| Nexus6p High Battery (every 5m, 1sec) | 1684% | 5036.0 | 675 | 98% | 95% | 3% | 25.1% | 32% |

## 40p

내구성에 대해

-> 다음은 After Party에서!

## 41p

- Code : github.com/mizutori/AndroidLocationStarterKit
- Blog: medium.com/@mizutory/
- Twitter : @mizutory

[www.goldrushcomputing.com](www.goldrushcomputing.com)

[mizutori@goldrushcomputing.com](mizutori@goldrushcomputing.com)