# language: ko 
기능: hello

   
    시나리오: 내 쇼핑 리스트를 출력해보자
    그 리스트는 뭄폭 이름의 사전 순으로 정렬되어 출력되어야 한다.

    조건 쇼핑 리스트가 주어졌음
      | name  | count |
      | Milk  |     2 |
      | Cocoa |     1 |
      | Soap  |     5 |
    만일 그 리스트를 출력하면
    그러면 다음과 같은 결과가 나와야 함
      """
      1 Cocoa
      2 Milk
      5 Soap

      """