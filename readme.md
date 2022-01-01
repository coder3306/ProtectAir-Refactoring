# ProtectAir
라즈베리파이로 미세먼지 센서값을 측정하여 서버로 올린 후 사용자에게 iOS 어플리케이션으로 표시해 주는 어플리케이션

## Preview
![스크린샷 2021-12-31 오후 2 59 56-side](https://user-images.githubusercontent.com/84212041/147806860-19a89758-7762-4b6e-9ee1-a761f517625b.png)

## 어플 사용 설명서
CurrentWeatherView : 사용자의 위치를 받으면, 그 위치를 기반으로 현재 날씨와 미세먼지 데이터 출력합니다.<br>
WeatherRadarView : 웹뷰를 구현하여 미세먼지의 유해성 및 기상레이더센터, 에어코리아 미세먼지 레이더센터에 접근하여 현재 날씨를 알 수 있습니다.<br>
SensorView : 라즈베리파이의 데이터를 가져와서 테이블 뷰에 각 자리에 맞게 데이터를 전송합니다.<br>
ControlView : 라즈베리파이의 모터의 출력을 가져와서 사용자에게 표기해주는 뷰입니다.<br>

## 개발기간
2021.9.2 ~ 2021.11.14<br>
2021.12.26 ~ 2021.12.31(Refactoring)

## 개발 환경
**Server**<br>
Apache<br>

**Database**<br>
MariaDB<br>

**Client**<br>
Xcode<br>

## 기여도
Server(100%)
Database(100%)
Application(100%)
Case(50%)

## 개요
**이 작품은 CapstoneDesign-Raspi-to-iOS를 리팩토링한 작품입니다.<br>**
당시 아이디어 회의 중 미세먼지 농도가 높다는 기사를 보게되었습니다.<br>
그러나 실내 미세먼지 환경은 알 수 없어 환기를 해야 하는지에 대한 판단이 불가능 하였습니다.<br>
미세먼지 측정 시스템을 구축하고 사용자에게 실내 미세먼지 농도의 환경을 알려주고, 모터가 자동으로 동작하게 하여 환기를 해주는 시스템을 개발하기로 하였습니다.<br>

## 로직
RaspberryPi - MariaDB/Firebase(DB) - Apache/Google(Server) - iOS

## Stack
1. MVVM/MVC
2. ARC
3. GCD Queue(Rx Refactoring 과정으로 삭제)
4. MariaDB
5. RxSwift/RxAlamofire/RxCoreLocation/RxWebKit
6. PHP

## 라즈베리파이 사용 모듈
1. LED
2. PMS7003
3. l298n Motor

## 히스토리
**라즈베리파이의 데이터 다운로드 시 멈춤 발생**<br>
간헐적으로 멈춤이 발생하고, 다시 실행되어서 사용자가 사용하기에는 부적절 하다 생각하였습니다.<br>
해결 방법을 찾던 중 Swift에서 지원해 주는 스레드 처리 방법인 GCD를 알게 되어 네트워킹 단계에서 GCD 처리를 하여 멈춤이 없게 하였습니다.<br>

**웹 데이터 파싱 시 JSON 파일을 일일이 분해**<br>
JSON파일을 일일이 분해해서 각 객체에 분배하여 사용해도 이상은 없습니다.<br>
하지만 추 후 파일의 리팩토링 과정에서 문제가 발생하였고, 스파게티 코드가 되어 해결이 불가능하게 되었습니다.<br>
그래서, Codable을 이용하여 JSON파일에 맞게 구조체를 선언하여 데이터를 처리하였습니다.<br>

**웹 데이터 파싱 시 nil값 발생으로 프로그램 크러쉬 발생**<br>
JSON 파싱시 오류가 발생했을 때도 그대로 파싱과정에 들어가고, nil값이 객체에 할당되어 프로그램의 크러쉬가 발생하였습니다.<br>
네트워킹 과정에서 통신 오류가 발생할 시 리턴하는 과정을 추가하고, 옵셔널의 Force Unwrapping 대신 Optional Binding을 사용하였습니다.<br>

**코드 리팩토링을 하면서 배운점**<br>
리팩토링 과정을 거치면서, 전체적으로 코드가 RxSwift 기반으로 변경되었습니다. <br>
제가 해보고 싶은 RxCoreLocation, RxAlamofire, RxWebKit 등 우선 써보면서, 프레임워크의 설명서를 보고 데이터 흐름을 파악하며 사용했습니다!!<br>
사용자의 반응 및 데이터를 처리하려먼 Delegate 패턴을 사용해서 값을 전달해주거나,JSON 값이 2초 사이로 변하는 과정을 무한루프로 처리하며 자원을 낭비하면서 Observer 패턴을 어거지로 구현했습니다.<br> 
Rx를 이용하게 되면서 앱개발 시 객체 상태 변화에 대응하는 Observer 패턴에 대해 제대로 알게 되었습니다.<br>
또한, RxSwift에서는 클로저가 주로 사용되며, 그로 인한 데이터 흐름을 확실하게 파악해야 하고 또한 메모리 순환참조 오류도 빈번하게 발생하여 어플의 메모리 누수를 발생시킵니다.<br>
물론, Dispose 될 시 자동으로 옵저버블에 할당된 메모리가 dealloc 되며 순환참조 문제도 해결되지만, 저는 조금 번거롭더라도 오류의 여지를 남기지 않는게 중요하다 판단되어 [weak self]구문을 붙여서 사용하였습니다.<br> 
RxAlamoFire<br>
RxCoreLocation<br>
RxWebKit<br>
