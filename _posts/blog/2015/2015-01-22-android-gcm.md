---
layout: post
title: "Android 로컬에서 GCM Push 전송하기"
date: 2015-01-22 16:17:00
tag: [Android, GCM]
categories:
- blog
- Android
---

안드로이드 개발시 GCM으로 Push 처리를 위하여 테스트용으로 만든것을 공유합니다.

추가적인 자세한 내용들은 GCM 관련 페이지를 하단에 기술하였으므로 참고하시길바랍니다.

<!--more-->

사전준비

1. Android SDK Manager Open
2. 하단 Obsolete 항목 선택
3. Extras - Google Cloud Messaging for Android Library (Obsolete) 다운로드

GCM 전송으로 위한 기본적인 필요한 Library 파일

```
- gcm-server.jar
- json_simple-1.1.jar
```

해당 파일은 `[Android SDK Folder]\extras\google\gcm\samples\gcm-demo-server\WebContent\WEB-INF\lib` 에 있습니다.

- - -

**GCM 전송할 데이터**

{msg:{message:"ABCD"}}

- - -

## 단일 단말 전송


```java 
public class Main {
   private final static String API_KEY = "API_KEY";
   private final static String REGISTER_DEVICE_ID = "DEVICE_GCM_ID";

   public static void main(String[] args) {
      JSONObject obj = new JSONObject();
      obj.put("message", "ABCD");

      System.out.println(obj.toString());
      sendPush(obj.toString(), REGISTER_DEVICE_ID);
   }

   /**
    * Push 전달
    * @param message Message
    * @param registerId Text
    */
   private static void sendPush(String message, String registerId) {
      Sender sender = new Sender(API_KEY);

      Message.Builder messageBuilder = new Message.Builder();
      messageBuilder.delayWhileIdle(false);
      messageBuilder.timeToLive(1800);
      messageBuilder.addData("aps", message);

      try {
         Result result = sender.send(messageBuilder.build(), registerId, 5);
         printResult(result);
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   /**
	* Print Push Result
    * @param result Result
    */
   private static void printResult(Result result) {
      System.out.println(result.getCanonicalRegistrationId());

      String messageId = result.getMessageId();
      if (messageId != null) {
         System.out.println("MessageId = " + messageId);
      } else {
         System.out.println(result.getErrorCodeName());
      }
   }
}
```

- - -

## 복수 단말 전송

단일 단말 전송 코드와 Sender 객체의 send함수에 전달하는 파라매터만 다른정도일뿐 기본적인 코드는 동일합니다.


```java 
public class Main {
   private final static String API_KEY = "API_KEY";

   public static void main(String[] args) {
      JSONObject obj = new JSONObject();
      obj.put("message", "ABCD");

      System.out.println(obj.toString());

      List<String> devicesList = new ArrayList<>();
      devicesList.add("DEVICE_1_Register_ID");
      devicesList.add("DEVICE_2_Register_ID");
      devicesList.add("DEVICE_3_Register_ID");

      sendPush(obj.toString(), devicesList);
   }

   /**
    * Push 전달
    * @param message Message
	* @param text Text
	* @param list Register Id Lists
	*/
   private static void sendPush(String text, List<String> list)
      Sender sender = new Sender(API_KEY);

      Message.Builder messageBuilder = new Message.Builder();
      messageBuilder.delayWhileIdle(false);
      messageBuilder.timeToLive(1800);
      messageBuilder.addData("aps", message);

      try {
         MulticastResult result = sender.send(messageBuilder.build(), list, 5);
         for (Result r : result.getResults()) {
            printResult(r);
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   /**
	* Print Push Result
    * @param result Result
    */
   private static void printResult(Result result) {
      System.out.println(result.getCanonicalRegistrationId());

      String messageId = result.getMessageId();
      if (messageId != null) {
         System.out.println("MessageId = " + messageId);
      } else {
         System.out.println(result.getErrorCodeName());
      }
   }
}
```

- - -

Sender Class의 함수에는 다음과 같이 정의되어 있기때문에 단일과 다중 단말 Push 전송이 큰 차이가 없습니다

| Public Methods | |
| :-- | :-- |
| MulticastResult |	send(Message message, List<String> regIds, int retries) |
| Result | send(Message message, String registrationId, int retries) |
| Result | sendNoRetry(Message message, String registrationId) |
| MulticastResult | sendNoRetry(Message message, List<String> registrationIds) |

- - -

참고 사이트

1. http://developer.android.com/reference/com/google/android/gcm/server/Sender.html
