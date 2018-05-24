USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[BI_MS_OrderWorkInInfo]    Script Date: 2018/5/24 7:19:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----功能：订单入库分析
----作者：白兵
----日期：2018-5-18
----exec BI_MS_OrderWorkInInfo '2017-1-1 00:00:00'
ALTER Proc [dbo].[BI_MS_OrderWorkInInfo]
@docdate datetime
as
--declare @docdate datetime
--set @docdate='2017-1-1 00:00:00'

select   CASE WHEN LEN(MONTH(DocDate))<2 THEN RIGHT(CAST(YEAR(DocDate) AS NVARCHAR),2)
+'0'+CAST(MONTH(DocDate) AS NVARCHAR)   
ELSE RIGHT(CAST(YEAR(DocDate) AS NVARCHAR),2)
+CAST(MONTH(DocDate) AS NVARCHAR) END as MonthInfo ,SUM(Qty) as OrderQty,SUM(Money) as OrderMoney
into #a
from MS_OrderInfoSub
where DocDate>=@docdate
group by YEAR(DocDate),MONTH(DocDate)
order by YEAR(DocDate),MONTH(DocDate)

select a.MonthInfo,a.WorkQty,b.Amount as InQty ,b.InPut
into #b from (
select  CASE WHEN LEN(MONTH(PP_WorkOrder.DocDate))<2 THEN RIGHT(CAST(YEAR(PP_WorkOrder.DocDate) AS NVARCHAR),2)
+'0'+CAST(MONTH(PP_WorkOrder.DocDate) AS NVARCHAR)   
ELSE RIGHT(CAST(YEAR(PP_WorkOrder.DocDate) AS NVARCHAR),2)
+CAST(MONTH(PP_WorkOrder.DocDate) AS NVARCHAR) END as MonthInfo ,
SUM(WorkQty) as WorkQty
 from PP_WorkOrderSubMSOrder
inner join PP_WorkOrder on PP_WorkOrder.ID=PP_WorkOrderSubMSOrder.PP_WorkOrder_ID
where PP_WorkOrder.DocDate>=@docdate
and PP_WorkOrderSubMSOrder.WorkQty>0
and RIGHT(SubBatchNo,1)<>'J'
group by YEAR(DocDate),MONTH(DocDate))a 

left outer join 
(select  CASE WHEN LEN(MONTH(CP_ProductInMain.DocDate))<2 THEN RIGHT(CAST(YEAR(CP_ProductInMain.DocDate) AS NVARCHAR),2)
+'0'+CAST(MONTH(CP_ProductInMain.DocDate) AS NVARCHAR)   
ELSE RIGHT(CAST(YEAR(CP_ProductInMain.DocDate) AS NVARCHAR),2)
+CAST(MONTH(CP_ProductInMain.DocDate) AS NVARCHAR) END as MonthInfo ,
SUM(CP_ProductInSub.SAmount) as Amount,SUM(SAmount*isnull(PT_ProductTypeHS.OutPutUnitPrice,0)) as InPut
from CP_ProductInSub
inner join CP_ProductInMain on CP_ProductInMain.ID=CP_ProductInSub.CP_ProductInMain_ID
inner join PT_ProductSpec on PT_ProductSpec.ID=CP_ProductInSub.PT_ProductSpec_ID
left outer join PT_ProductTypeHS on PT_ProductTypeHS.ID=PT_ProductSpec.PT_ProductTypeHS_ID
where CP_ProductInSub.status<>'10'
and CP_ProductInMain.DocDate>=@docdate
and CP_ProductInMain.DF_CP_ProductOutMain_ID is null
and BatchNum in (select distinct SubBatchNo from PP_WorkOrderSubMSOrder
inner join PP_WorkOrder on PP_WorkOrder.ID=PP_WorkOrderSubMSOrder.PP_WorkOrder_ID
where PP_WorkOrder.DocDate>=@docdate
and PP_WorkOrderSubMSOrder.WorkQty>0
and RIGHT(SubBatchNo,1)<>'J')

group by YEAR(CP_ProductInMain.DocDate),MONTH(CP_ProductInMain.DocDate)
)b 
on a.MonthInfo=b.MonthInfo


select  CASE WHEN LEN(MONTH(CP_ProductInMain.DocDate))<2 THEN RIGHT(CAST(YEAR(CP_ProductInMain.DocDate) AS NVARCHAR),2)
+'0'+CAST(MONTH(CP_ProductInMain.DocDate) AS NVARCHAR)   
ELSE RIGHT(CAST(YEAR(CP_ProductInMain.DocDate) AS NVARCHAR),2)
+CAST(MONTH(CP_ProductInMain.DocDate) AS NVARCHAR) END as MonthInfo ,
SUM(CP_ProductInSub.SAmount) as SAmount,SUM(SAmount*isnull(PT_ProductTypeHS.OutPutUnitPrice,0)) as InPut
INTO #C
from CP_ProductInSub
inner join CP_ProductInMain on CP_ProductInMain.ID=CP_ProductInSub.CP_ProductInMain_ID
left outer join MS_OrderInfoSub on MS_OrderInfoSub.ID=CP_ProductInSub.MS_OrderInfoSub_ID
inner join PT_ProductSpec on PT_ProductSpec.ID=CP_ProductInSub.PT_ProductSpec_ID
left outer join PT_ProductTypeHS on PT_ProductTypeHS.ID=PT_ProductSpec.PT_ProductTypeHS_ID
where CP_ProductInSub.status<>'10'
and CP_ProductInMain.DocDate>=@docdate
and CP_ProductInMain.DF_CP_ProductOutMain_ID is null
and MS_OrderInfoSub_ID in (
select ID  from MS_OrderInfoSub
where DocDate>=@docdate
)
and YEAR(CP_ProductInMain.DocDate)=YEAR(ms_orderinfosub.DocDate)
and month(CP_ProductInMain.DocDate)=month(ms_orderinfosub.DocDate)
group by YEAR(CP_ProductInMain.DocDate),MONTH(CP_ProductInMain.DocDate)

select #a.MonthInfo,cast(#a.OrderQty as int) as OrderQty ,
cast(#b.WorkQty as int) as WorkQty,cast(#b.InQty as int) as WorkInQty,cast(#b.InPut/10000 as int) as WorkInPut,
cast(#C.SAmount as int) AS SInQty,cast(#C.InPut/10000 as int) AS OrderInPut
from #a inner join #b 
on #a.MonthInfo=#b.MonthInfo
inner join #C
on #a.MonthInfo=#C.MonthInfo
order by #a.MonthInfo


drop table #a
drop table #b
drop table #c


