/*
============================================================
[5장 1강] 실습문제: EXPLAIN 결과 해석과 실행계획 요소 식별
============================================================

[실습 목표]
- 복합 쿼리의 EXPLAIN 결과를 아래에서 위로 읽을 수 있다.
- Scan, Join, Sort, Aggregate, WindowAgg 노드를 식별할 수 있다.
- cost, rows, actual rows, actual time의 의미를 구분할 수 있다.
- 실행계획에서 병목 후보 노드를 찾을 수 있다.
- 실행계획을 바탕으로 개선 방향 후보를 설명할 수 있다.

[사용 환경]
- PostgreSQL
- DBeaver

[사용 데이터]
이번 과정에서는 아래 12개 CSV로 구성된 동일한 Retail Data Warehouse 데이터셋을 계속 사용합니다.

- customers
- employees
- order_items
- orders
- payments
- products
- promotions
- returns
- shipments
- stores
- suppliers
- categories

[이번 강에서 주로 사용하는 테이블]
- orders
- order_items
- customers

[주요 관계]
- orders.order_id = order_items.order_id
- orders.customer_id = customers.customer_id

[주의사항]
- 실행계획의 cost와 actual time은 환경에 따라 달라질 수 있습니다.
- 특정 숫자를 외우는 것이 아니라, 어떤 노드가 어떤 작업을 하는지 해석하는 것이 핵심입니다.
*/


/*
============================================================
과제. JOIN + 정렬 실행계획 해석
============================================================

[문제 3-1] 고객 주문 조회 실행계획 분석

[문제 설명]
고객 주문 정보를 조회하면서
주문일 기준으로 정렬하는 쿼리의 실행계획을 분석하세요.

이번 문제에서는 실행계획에서
Scan → Join → Sort 흐름을 직접 확인하는 것이 핵심입니다.

※ 과제는 필수 문제와 동일한 수준입니다.

[요구사항]
1. orders와 customers를 customer_id 기준으로 JOIN하세요.
2. 2023년 주문만 조회하세요.
3. 다음 컬럼을 조회하세요.
   - orders.order_id
   - orders.order_date
   - customers.customer_id
   - customers.city
4. 결과를 order_date DESC로 정렬하세요.
5. EXPLAIN ANALYZE를 적용하세요.
6. 실행계획에서 다음 항목을 확인하세요.
   - orders Scan 방식
   - customers Scan 방식
   - Join 방식
   - Sort
   - estimated rows
   - actual rows
   - Execution Time
7. 실행계획을 아래에서 위로 읽으면서 실제 처리 흐름을 설명하세요.
8. 가장 먼저 확인할 병목 후보 노드를 하나 선택하고 이유를 작성하세요.
9. 다음 질문에 답하세요.
   Q1. Scan 노드에서는 무엇을 확인해야 하나요?
   Q2. Join 노드에서는 무엇을 확인해야 하나요?
   Q3. Sort 노드에서는 무엇을 확인해야 하나요?
   Q4. Seq Scan이 나타났다고 해서 무조건 잘못된 실행계획이라고 할 수 있나요?

[제출 결과]
- 전체 SQL
- EXPLAIN ANALYZE 결과
- 실행 흐름
- 병목 후보
- Q1~Q4 답변
*/

-- [코드 작성란]




/*
============================================================
실습 마무리
============================================================

아래 내용을 한 문단으로 정리하세요.

1. 실행계획은 왜 아래에서 위로 읽는 것이 좋은가요?
2. Scan, Join, Sort, WindowAgg는 각각 어떤 작업을 의미하나요?
3. cost와 actual time은 어떻게 다른가요?
4. 병목 노드를 찾을 때 어떤 정보를 함께 봐야 하나요?
*/
