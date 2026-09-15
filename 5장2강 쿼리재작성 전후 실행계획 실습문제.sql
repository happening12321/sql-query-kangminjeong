/*
============================================================
[5장 2강] 실습문제: 쿼리 재작성 전후 실행계획 비교와 개선 효과 분석
============================================================

[실습 목표]
- 튜닝 전 실행계획과 실행 시간을 기준값으로 기록할 수 있다.
- 인덱스 추가 전후의 실행계획 변화를 비교할 수 있다.
- 쿼리 재작성 전후의 실행계획 변화를 비교할 수 있다.
- cost, 스캔 방식, Execution Time을 근거로 개선 효과를 판단할 수 있다.
- 개선이 항상 발생하는 것은 아니라는 점을 실행계획으로 설명할 수 있다.

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
- order_items
- orders

[주의사항]
- 실행계획의 cost와 Execution Time은 PostgreSQL 버전, 서버 환경,
  캐시 상태, 통계정보 등에 따라 달라질 수 있습니다.
- 개선 전후에는 비교 대상 SQL의 조건을 동일하게 유지해야 합니다.
- 한 번에 여러 요소를 변경하지 않고 한 가지 변경만 적용하여
  무엇 때문에 실행계획이 달라졌는지 확인합니다.
*/


/*
============================================================
과제. JOIN 쿼리의 날짜 인덱스 적용 전후 개선 효과 분석
============================================================

[문제 3-1] 고객 도시 정보를 포함한 특정 기간 주문 조회 튜닝 결과 보고

[문제 설명]
운영 리포트에서 2023년 12월 주문과 고객 도시 정보를 함께 조회하고,
최근 주문부터 확인하는 쿼리를 반복적으로 사용한다고 가정합니다.

orders와 customers를 customer_id 기준으로 JOIN한 상태에서
먼저 현재 실행계획을 기준값으로 기록한 뒤,
orders.order_date 인덱스를 추가하여 동일한 JOIN 쿼리를 다시 측정하세요.

마지막에는 Scan → Join → Sort 흐름과 실행계획 변화,
실행시간 개선 효과와 한계를 간단한 비교 보고서 형태로 정리하세요.

※ 과제는 필수 문제와 동일한 수준입니다.

[요구사항]
1. 기존 idx_orders_order_date 인덱스가 있다면 삭제하세요.
2. orders와 customers를 customer_id 기준으로 JOIN하세요.
3. 다음 기간의 주문만 조회하세요.

   orders.order_date >= DATE '2023-12-01'
   orders.order_date <  DATE '2024-01-01'

4. 다음 컬럼을 출력하세요.
   - orders.order_id
   - orders.order_date
   - customers.customer_id
   - customers.city
5. 결과를 orders.order_date DESC로 정렬하세요.
6. 인덱스 생성 전 EXPLAIN ANALYZE 결과에서 다음 항목을 기록하세요.
   - orders 스캔 방식
   - customers 스캔 방식
   - Join 방식
   - JOIN 조건
   - Sort 여부
   - total cost
   - actual rows
   - Execution Time
7. orders.order_date에 idx_orders_order_date 인덱스를 생성하세요.
8. 동일한 JOIN 쿼리에 다시 EXPLAIN ANALYZE를 적용하세요.
9. 개선 후 동일한 항목을 기록하세요.
10. Join 노드가 개선 전후에 어떻게 달라졌는지 확인하세요.
    - Join 방식이 변경되었는지
    - Join 입력 행 수가 달라졌는지
    - Join 노드의 cost 또는 actual time이 달라졌는지
11. 실행시간 감소율을 다음 식으로 계산하세요.

   (개선 전 Execution Time - 개선 후 Execution Time)
   / 개선 전 Execution Time * 100

12. 다음 형식으로 비교 결과를 정리하세요.

   항목                  개선 전        개선 후
   ----------------------------------------------------
   orders 스캔 방식
   customers 스캔 방식
   Join 방식
   JOIN 조건
   Sort 여부
   Join 노드 변화
   total cost
   actual rows
   Execution Time
   실행시간 감소율

13. 다음 질문에 답하세요.
    Q1. 인덱스 추가 후에도 Sort가 남을 수 있나요?
    Q2. 인덱스를 추가했는데 옵티마이저가 Seq Scan을 계속 선택한다면 어떤 의미인가요?
    Q3. Join 방식이 변경되었다고 해서 반드시 성능이 개선되었다고 말할 수 있나요?
    Q4. 이번 결과만으로 모든 날짜 JOIN 조회에 order_date 인덱스가 항상 효과적이라고 결론 내릴 수 있나요?
14. 실습 종료 후 idx_orders_order_date 인덱스를 삭제하세요.

[제출 결과]
- 전체 JOIN SQL
- 개선 전 EXPLAIN ANALYZE
- CREATE INDEX 문
- 개선 후 EXPLAIN ANALYZE
- Scan / Join / Sort 비교표
- JOIN 조건 확인
- Join 노드 전후 변화 해석
- 실행시간 감소율
- Q1~Q4 답변
- DROP INDEX 문
*/

-- [코드 작성란]



/*
============================================================
실습 마무리
============================================================

아래 내용을 한 문단으로 정리하세요.

1. 튜닝 전에 기준 실행계획을 먼저 기록해야 하는 이유는 무엇인가요?
2. 인덱스 추가와 쿼리 재작성 후 무엇을 다시 측정해야 하나요?
3. 튜닝 효과를 설명할 때 어떤 지표를 함께 비교해야 하나요?
4. 실행계획이 바뀌었다는 사실만으로 성능 개선을 확정할 수 없는 이유는 무엇인가요?
*/
