SELECT * 
,(case when Clascnt=0 then 0 else new_paiduprmb/Clascnt end) Class_fee
,ROUND((case when clascnt=0 then 0 else Attended/Clascnt end),2) AttenRate
FROM(
select distinct
  T1.Contract_id
, T1.Center_id
, T1.Lead_id
, case when T1.new_contractstyle in ('退费中止','退定金中止') then 0
       when T1.new_contractstyle in ('已结业结束','已结束') then 1 
	   when T1.new_contractstyle='执行中' then 2 else 99 end
       Label
, T1.Tutor_name
, T1.CC_name
, T1.New_startlevelname
, T1.New_nowlevelname
, CASE WHEN T1.New_cardsex='女' then 0
       WHEN T1.New_cardsex='男' then 1
	   ELSE '2' END New_cardsex
, T2.New_amount
, T2.New_paiduprmb
, COUNT(distinct(T5.appointment_id)) Appointcnt
, SUM(CASE WHEN T6.new_interactiveplatform='官网' THEN 1 ELSE 0 END) A
, SUM(CASE WHEN T6.new_interactiveplatform='呼叫中心' THEN 1 ELSE 0 END) B
, SUM(CASE WHEN T6.new_interactiveplatform='离线' THEN 1 ELSE 0 END) C
, SUM(CASE WHEN T6.new_interactiveplatform='数据外采' THEN 1 ELSE 0 END) D
, SUM(CASE WHEN T6.new_interactiveplatform='旺旺' THEN 1 ELSE 0 END) E
, SUM(CASE WHEN T6.new_interactiveplatform='线下' THEN 1 ELSE 0 END) F
, SUM(CASE WHEN T6.new_interactiveplatform='主动到访' THEN 1 ELSE 0 END) G
, SUM(CASE WHEN T6.new_interactiveplatform='总部APP' THEN 1 ELSE 0 END) H
, SUM(CASE WHEN T6.new_interactiveplatform='livecom' THEN 1 ELSE 0 END) Livecom
, count(T7.classorder_ID) Clascnt
, min(T7.new_begintime) Classcnt
, DATEDIFF(Month,MIN(T7.new_begintime),MAX(T7.new_endtime)) Diffday 
, SUM(CASE WHEN T7.new_attended='Attended' THEN 1 ELSE 0 END) Attended 
FROM dim_contract T1
LEFT JOIN fct_contract T2 ON T1.Contract_ID=T2.Contract_ID
LEFT JOIN dim_lead T3 ON T1.Lead_id=T3.Lead_ID
LEFT JOIN Fct_visit T4 ON T1.Lead_id=T4.Lead_id
LEFT JOIN fct_appointment_record T5 ON T1.Lead_id=T5.lead_id
LEFT JOIN fct_channelinteractionrecord T6 ON T1.Lead_id=T6.lead_id
LEFT JOIN fct_classorder T7 ON T1.Contract_ID=T7.contract_id
WHERE
T1.statecode=0
and t3.statecode=0
and t4.statecode=0
and t7.statecode=0
GROUP BY
  T1.Contract_id
, T1.Center_id
, T1.Lead_id
, T1.new_contractstyle 
, T1.Tutor_name
, T1.CC_name
, T1.New_startlevelname
, T1.New_nowlevelname
, T1.New_cardsex
, T2.New_amount
, T2.New_paiduprmb
)TT 
