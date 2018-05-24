USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[BI_MS_OrderBillInfo]    Script Date: 2018/5/24 7:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----功能：订单发货开票分析
----作者：白兵
----日期：2018-5-18
ALTER Proc [dbo].[BI_MS_OrderBillInfo]
@DocDate datetime
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


select  CASE WHEN LEN(MONTH(CP_ProductOutMain.DocDate))<2 THEN RIGHT(CAST(YEAR(CP_ProductOutMain.DocDate) AS NVARCHAR),2)
+'0'+CAST(MONTH(CP_ProductOutMain.DocDate) AS NVARCHAR)   
ELSE RIGHT(CAST(YEAR(CP_ProductOutMain.DocDate) AS NVARCHAR),2)
+CAST(MONTH(CP_ProductOutMain.DocDate) AS NVARCHAR) END as MonthInfo ,
SUM(CP_ProductOutsub.Amount) as OutQty,SUM(MS_OrderInfoSub.UnitPrice*CP_ProductOutsub.Amount) as OutMonty
into #b
 from CP_ProductOutSub
inner join CP_ProductOutMain on CP_ProductOutMain.ID=CP_ProductOutSub.CP_ProductOutMain_ID
inner join MS_OrderInfoSub on MS_OrderInfoSub.ID=CP_ProductOutSub.MS_OrderInfoSub_ID
where CP_ProductOutSub.MS_OrderInfoSub_ID is not null
and CP_ProductOutMain.DF_CP_ProductOutMain_ID is null
and CP_ProductOutMain.DocDate>=@docdate
group by YEAR(CP_ProductOutMain.DocDate),MONTH(CP_ProductOutMain.DocDate)
order by YEAR(CP_ProductOutMain.DocDate),MONTH(CP_ProductOutMain.DocDate)


select  CASE WHEN LEN(MONTH(BillDate))<2 THEN RIGHT(CAST(YEAR(BillDate) AS NVARCHAR),2)
+'0'+CAST(MONTH(BillDate) AS NVARCHAR)   
ELSE RIGHT(CAST(YEAR(BillDate) AS NVARCHAR),2)
+CAST(MONTH(BillDate) AS NVARCHAR) END as MonthInfo ,SUM(BillAmount) as BillQty,
SUM(BillTotalMoney) as BillMoney
into #d
 from (
-----正常出库的产品信息
SELECT FI_CPBillMain.BillDate,CP_ProductOutMain.DocNum, CP_ProductOutMain.HandNum, 
      CP_ProductBatchQuanlity.IBatchNum, CP_ProductOutSub.Number, FI_CPBillMain.BillNum,
      CP_ProductOutSub.Amount,  CP_ProductBatchQuanlity.IsNoWashing,
      MS_CustomerSaler.SalerName,MS_CustomerSaleArea.Area,
      PT_ProductSpec.ProductSpecName, PT_ProductType.ProductTypeName, 
      CP_ProductOutMain.DocDate, FI_CPBillMain.ID as ID,MS_Customer.CardName AS FICardName,
      dbo.CP_GetCPCustomer(CP_ProductOutMain.ID) AS CardName,
      CP_ProductOutSub.FIBillAmount,CP_ProductOutSub.FIBillLackAmount,FI_CPBillSub.BillAmount,
      FI_CPBillSub.BillUnitPrice,FI_CPBillSub.BillTotalMoney,FI_CPBillMain.DocNum as FIDocNum,
      FI_CPBillSub.ID as FIID,
      case FI_CPBillMain.CP_ProductInCompany when 'B11FA14F-0B9B-4E7B-8FD6-10ECAAD6C3C9' then '三海兰陵' 
      when '0975D294-96AA-4CC0-82B1-1ADA4AACF8E3' then '华兰股份' else '暂存江阴仓库(三海兰陵包装产品)' end as ProductInCompany,
      DBO.CP_GetTopProductTypeName(PT_ProductType.ID) as TopProductTypeName,PT_ProductTypeXSSecond.TypeName,
        DBO.CP_GetKHProductTypeName(PT_ProductType.ID) AS ProductKHTypeName,
      CP_ProductOutMain.ISDF AS ISDF,FI_CPBillMain.Remark,FI_CPBillMain.IsReceipt,FI_CPBillMain.TrackingNo,
       case FI_CPBillMain.status when '10' then '开单' else '已审核'  end as Status,
       CP_ProductBatchQuanlity.packgetype as PackgeType,
       CP_ProductBatchQuanlity.BatchNum,Orderinfo.DocNum as MSOrderDoc,
        isnull(MS_OrderAgreementMain.DocNum,'无订单合同') as AgreeNum,
        case  when MS_Customer.IsForeign=1 then FI_CPBillSub.BillTotalMoney
      else cast(FI_CPBillSub.BillTotalMoney/(1+FI_CPBillMain.FaxRate) as decimal(18,4)) end as LackTaxBillTotalMoney,
      CP_DeliverType.DeliverType as DeliverType,FI_CPBillSub.ISAdjust,
       PT_ProductTypeHS.ProductTypeName as ProductTypeNameHS
FROM CP_ProductOutSub INNER JOIN
      CP_ProductOutMain ON 
      CP_ProductOutSub.CP_ProductOutMain_ID = CP_ProductOutMain.ID INNER JOIN
      CP_ProductBatchQuanlity ON 
      CP_ProductOutSub.BatchNum = CP_ProductBatchQuanlity.ID INNER JOIN
      PT_ProductSpec INNER JOIN
      PT_ProductType ON PT_ProductSpec.PT_ProductType_ID = PT_ProductType.ID ON 
      CP_ProductBatchQuanlity.PT_Productspec_ID = PT_ProductSpec.ID 
      LEFT OUTER JOIN PT_ProductTypeXSSecond ON  PT_ProductType.PT_ProductTypeXSSecond_ID=PT_ProductTypeXSSecond.ID
      INNER JOIN FI_CPBillSub ON FI_CPBillSub.CP_ProductOutSub_ID=CP_ProductOutSub.ID
      INNER JOIN FI_CPBillMain ON FI_CPBillMain.ID=FI_CPBillSub.FI_CPBillMain_ID
      LEFT JOIN MS_Customer ON FI_CPBillMain.FI_MS_Customer_ID = MS_Customer.ID
      LEFT OUTER JOIN MS_CustomerSaler ON MS_Customer.Saler=MS_CustomerSaler.ID
      LEFT OUTER JOIN MS_CustomerSaleArea ON MS_CustomerSaleArea.ID=MS_Customer.SaleArea
     left outer join (select ID,DocNum,MS_OrderInfoMain_ID from MS_OrderInfoSub
      union select ID,DocNum,ID as MS_OrderInfoMain_ID from MS_SampleOrderInfo) Orderinfo
             on Orderinfo.ID=CP_ProductOutSub.MS_OrderInfoSub_ID
      left outer join MS_OrderInfoMain
      on MS_OrderInfoMain.ID=Orderinfo.MS_OrderInfoMain_ID
      left outer join MS_OrderAgreementMain 
      on MS_OrderAgreementMain.MS_OrderInfoMain_ID=MS_OrderInfoMain.ID
      left outer join CP_DeliverType on CP_DeliverType.ID=CP_ProductOutSub.CP_DeliverType_ID
         left outer join PT_ProductTypeHS on PT_ProductTypeHS.ID=PT_ProductSpec.PT_ProductTypeHS_ID
WHERE (CP_ProductOutMain.Status IN ('20','30')) 
AND (FI_CPBillMain.BillDate >=@docdate)
AND (FI_CPBillMain.FI_MS_Customer_ID NOT IN ('1731','249'))


union
-----补录2011-1-1之前的出库单
SELECT FI_CPBillMain.BillDate,CP_ProductOutMainB.DocNum, CP_ProductOutMainB.HandNum, 
      CP_ProductOutSubB.IBatchNum, CP_ProductOutSubB.Number, FI_CPBillMain.BillNum,
      CP_ProductOutSubB.Amount,  CP_ProductOutSubB.IsNoWashing,
       MS_CustomerSaler.SalerName,MS_CustomerSaleArea.Area,
      PT_ProductSpec.ProductSpecName, PT_ProductType.ProductTypeName, 
      CP_ProductOutMainb.DocDate, FI_CPBillMain.ID as ID,MS_Customer.CardName AS FICardName,
      dbo.CP_GetCPBCustomer(CP_ProductOutMainB.ID) AS CardName,
      CP_ProductOutSubB.FIBillAmount,CP_ProductOutSubB.FIBillLackAmount,FI_CPBillSub.BillAmount,
      FI_CPBillSub.BillUnitPrice,FI_CPBillSub.BillTotalMoney,FI_CPBillMain.DocNum as FIDocNum,
      FI_CPBillSub.ID as FIID,
      case FI_CPBillMain.CP_ProductInCompany when 'B11FA14F-0B9B-4E7B-8FD6-10ECAAD6C3C9' then '三海兰陵' 
      when '0975D294-96AA-4CC0-82B1-1ADA4AACF8E3' then '华兰股份' else '暂存江阴仓库(三海兰陵包装产品)' end as ProductInCompany,
      DBO.CP_GetTopProductTypeName(PT_ProductType.ID) as TopProductTypeName,PT_ProductTypeXSSecond.TypeName,
        DBO.CP_GetKHProductTypeName(PT_ProductType.ID) AS ProductKHTypeName,
      '0' AS ISDF,FI_CPBillMain.Remark,FI_CPBillMain.IsReceipt,FI_CPBillMain.TrackingNo,
       case FI_CPBillMain.status when '10' then '开单' else '已审核'  end as Status,
       cp_productoutsubb.PackageType,
       CP_ProductOutSubB.BatchNum,'补录出库无匹配订单' as MSOrderDoc,'无订单合同' as AgreeNum,
       case  when MS_Customer.IsForeign=1 then FI_CPBillSub.BillTotalMoney
      else cast(FI_CPBillSub.BillTotalMoney/(1+FI_CPBillMain.FaxRate) as decimal(18,4)) end as LackTaxBillTotalMoney,
      '无' as DeliverType,FI_CPBillSub.ISAdjust,
       PT_ProductTypeHS.ProductTypeName as ProductTypeNameHS
FROM CP_ProductOutSubB INNER JOIN
      CP_ProductOutMainB ON 
      CP_ProductOutSubB.CP_ProductOutMainB_ID = CP_ProductOutMainB.ID  INNER JOIN
      PT_ProductSpec INNER JOIN
      PT_ProductType ON PT_ProductSpec.PT_ProductType_ID = PT_ProductType.ID ON 
      CP_ProductOutSubB.PT_Productspec_ID = PT_ProductSpec.ID 
      LEFT OUTER JOIN PT_ProductTypeXSSecond ON  PT_ProductType.PT_ProductTypeXSSecond_ID=PT_ProductTypeXSSecond.ID
      INNER JOIN FI_CPBillSub ON FI_CPBillSub.CP_ProductOutSub_ID=CP_ProductOutSubB.ID
      INNER JOIN FI_CPBillMain ON FI_CPBillMain.ID=FI_CPBillSub.FI_CPBillMain_ID
      LEFT JOIN MS_Customer ON FI_CPBillMain.FI_MS_Customer_ID = MS_Customer.ID
      LEFT OUTER JOIN MS_CustomerSaler ON MS_Customer.Saler=MS_CustomerSaler.ID
      LEFT OUTER JOIN MS_CustomerSaleArea ON MS_CustomerSaleArea.ID=MS_Customer.SaleArea
         left outer join PT_ProductTypeHS on PT_ProductTypeHS.ID=PT_ProductSpec.PT_ProductTypeHS_ID
WHERE (CP_ProductOutMainB.Status IN ('20','30')) 
AND (FI_CPBillMain.BillDate >=@docdate)
AND (FI_CPBillMain.FI_MS_Customer_ID NOT IN ('1731','249'))


union
-----退客单
SELECT  FI_CPBillMain.BillDate,CP_ProductBack.docnum, '' as HandNum, CP_ProductBack.IbatchNum, (-1)*CP_ProductBack.Amount as number,FI_CPBillMain.BillNum,
(-1)*CP_ProductBack.Quantity as amount,CP_ProductBack.IsnoWashing,
MS_CustomerSaler.SalerName,MS_CustomerSaleArea.Area,
PT_ProductSpec.ProductSpecName,PT_ProductType.ProductTypeName, 
 CP_ProductBack.docdate, FI_CPBillMain.ID as ID,MS_Customer.CardName as FICardName,
 dbo.CP_GetCPTCustomer(CP_ProductBack.ID) AS CardName,
 (-1)*CP_ProductBack.FIBillAmount,CP_ProductBack.FIBillLackAmount,
 FI_CPBillSub.BillAmount,
      FI_CPBillSub.BillUnitPrice,FI_CPBillSub.BillTotalMoney,FI_CPBillMain.DocNum as FIDocNum,
      FI_CPBillSub.ID as FIID,
      case FI_CPBillMain.CP_ProductInCompany when 'B11FA14F-0B9B-4E7B-8FD6-10ECAAD6C3C9' then '三海兰陵' 
      when '0975D294-96AA-4CC0-82B1-1ADA4AACF8E3' then '华兰股份' else '暂存江阴仓库(三海兰陵包装产品)' end as ProductInCompany,
      DBO.CP_GetTopProductTypeName(PT_ProductType.ID) as TopProductTypeName,PT_ProductTypeXSSecond.TypeName,
        DBO.CP_GetKHProductTypeName(PT_ProductType.ID) AS ProductKHTypeName,
      '0' AS ISDF,FI_CPBillMain.Remark,FI_CPBillMain.IsReceipt,FI_CPBillMain.TrackingNo,
       case FI_CPBillMain.status when '10' then '开单' else '已审核'  end as Status,
       CP_ProductBack.PackgeType,
       CP_ProductBack.IBatchNum as BatchNum,'退货无匹配订单' as MSOrderDoc,'无订单合同' as AgreeNum,
       case  when MS_Customer.IsForeign=1 then FI_CPBillSub.BillTotalMoney
      else cast(FI_CPBillSub.BillTotalMoney/(1+FI_CPBillMain.FaxRate) as decimal(18,4)) end as LackTaxBillTotalMoney,
      '无' as DeliverType,FI_CPBillSub.ISAdjust,
       PT_ProductTypeHS.ProductTypeName as ProductTypeNameHS
FROM CP_ProductBack INNER JOIN PT_ProductSpec ON CP_ProductBack.PT_ProductSpec_ID=PT_ProductSpec.ID
INNER JOIN PT_ProductType ON PT_ProductSpec.PT_ProductType_ID=PT_ProductType.ID
LEFT OUTER JOIN PT_ProductTypeXSSecond ON  PT_ProductType.PT_ProductTypeXSSecond_ID=PT_ProductTypeXSSecond.ID
INNER JOIN FI_CPBillSub ON FI_CPBillSub.CP_ProductOutSub_ID=CP_ProductBack.id
INNER JOIN FI_CPBillMain ON FI_CPBillMain.ID=FI_CPBillSub.FI_CPBillMain_ID
LEFT JOIN MS_Customer ON FI_CPBillMain.FI_MS_Customer_ID = MS_Customer.ID
LEFT OUTER JOIN MS_CustomerSaler ON MS_Customer.Saler=MS_CustomerSaler.ID
      LEFT OUTER JOIN MS_CustomerSaleArea ON MS_CustomerSaleArea.ID=MS_Customer.SaleArea
        left outer join PT_ProductTypeHS on PT_ProductTypeHS.ID=PT_ProductSpec.PT_ProductTypeHS_ID
where CP_ProductBack.status<>'10'
AND (FI_CPBillMain.BillDate>=@docdate)
AND (FI_CPBillMain.FI_MS_Customer_ID NOT IN ('1731','249'))

union
-----客退销售出库单
SELECT  FI_CPBillMain.BillDate,CP_ProductBackOut.docnum, '' as HandNum, CP_ProductBack.IbatchNum, 
CP_ProductBackOut.Amount as number,FI_CPBillMain.BillNum,
CP_ProductBackOut.Quantity as amount,CP_ProductBack.IsnoWashing,
MS_CustomerSaler.SalerName,MS_CustomerSaleArea.Area,
PT_ProductSpec.ProductSpecName,PT_ProductType.ProductTypeName, 
 CP_ProductBackOut.docdate, FI_CPBillMain.ID as ID,MS_Customer.CardName as FICardName,
 dbo.CP_GetCPTCustomer(CP_ProductBack.ID) AS CardName,
 CP_ProductBackOut.FIBillAmount,CP_ProductBackOut.FIBillLackAmount,
 FI_CPBillSub.BillAmount,
      FI_CPBillSub.BillUnitPrice,FI_CPBillSub.BillTotalMoney,FI_CPBillMain.DocNum as FIDocNum,
      FI_CPBillSub.ID as FIID,
      case FI_CPBillMain.CP_ProductInCompany when 'B11FA14F-0B9B-4E7B-8FD6-10ECAAD6C3C9' then '三海兰陵' 
      when '0975D294-96AA-4CC0-82B1-1ADA4AACF8E3' then '华兰股份' else '暂存江阴仓库(三海兰陵包装产品)' end as ProductInCompany,
      DBO.CP_GetTopProductTypeName(PT_ProductType.ID) as TopProductTypeName,PT_ProductTypeXSSecond.TypeName,
        DBO.CP_GetKHProductTypeName(PT_ProductType.ID) AS ProductKHTypeName,
      '0' AS ISDF,FI_CPBillMain.Remark,FI_CPBillMain.IsReceipt,FI_CPBillMain.TrackingNo,
       case FI_CPBillMain.status when '10' then '开单' else '已审核'  end as Status,
       CP_ProductBack.PackgeType,CP_ProductBack.IBatchNum as BatchNum,isnull(ms_backorderinfomain.docnum,'退货无匹配订单') as MSOrderDoc,
       '无订单合同' as AgreeNum,
       case  when MS_Customer.IsForeign=1 then FI_CPBillSub.BillTotalMoney
      else cast(FI_CPBillSub.BillTotalMoney/(1+FI_CPBillMain.FaxRate) as decimal(18,4)) end as LackTaxBillTotalMoney,
      '无' as DeliverType,FI_CPBillSub.ISAdjust,
       PT_ProductTypeHS.ProductTypeName as ProductTypeNameHS
FROM CP_ProductBackOut
inner join CP_ProductBack on CP_ProductBack.ID=CP_ProductBackOut.IBatchNum
 INNER JOIN PT_ProductSpec ON CP_ProductBack.PT_ProductSpec_ID=PT_ProductSpec.ID
INNER JOIN PT_ProductType ON PT_ProductSpec.PT_ProductType_ID=PT_ProductType.ID
LEFT OUTER JOIN PT_ProductTypeXSSecond ON  PT_ProductType.PT_ProductTypeXSSecond_ID=PT_ProductTypeXSSecond.ID
INNER JOIN FI_CPBillSub ON FI_CPBillSub.CP_ProductOutSub_ID=CP_ProductBackOut.id
INNER JOIN FI_CPBillMain ON FI_CPBillMain.ID=FI_CPBillSub.FI_CPBillMain_ID
LEFT JOIN MS_Customer ON FI_CPBillMain.FI_MS_Customer_ID = MS_Customer.ID
LEFT OUTER JOIN MS_CustomerSaler ON MS_Customer.Saler=MS_CustomerSaler.ID
      LEFT OUTER JOIN MS_CustomerSaleArea ON MS_CustomerSaleArea.ID=MS_Customer.SaleArea
       left outer join PT_ProductTypeHS on PT_ProductTypeHS.ID=PT_ProductSpec.PT_ProductTypeHS_ID
 left outer join MS_BackOrderInfoMain on MS_BackOrderInfoMain.ID=CP_ProductBack.MS_BackOrderInfoMain_ID
where CP_ProductBackOut.status<>'10'
AND (FI_CPBillMain.BillDate>=@docdate)
AND (FI_CPBillMain.FI_MS_Customer_ID NOT IN ('1731','249'))
union
-----外购物料销售
SELECT   FI_CPBillMain.BillDate,FI_MaterialOrderInfoMain.docnum, '' as HandNum, '' AS IbatchNum, 0 as number,
FI_CPBillMain.BillNum,
FI_MaterialOrderInfoSub.Qty as amount,'' as IsNoWashing,
MS_CustomerSaler.SalerName,MS_CustomerSaleArea.Area,
FI_MaterialBasicInfo.MaterialName as  ProductSpecName,'' as ProductTypeName, 
 FI_MaterialOrderInfoMain.docdate, FI_CPBillMain.ID as ID,MS_Customer.CardName as FICardName,
customerb.CardName AS CardName,
 (FI_MaterialOrderInfoSub.Qty-FI_MaterialOrderInfoSub.filackqty) as FIBillAmount,
 FI_MaterialOrderInfoSub.filackqty  as FIBillLackAmount,
 FI_CPBillSub.BillAmount,
      FI_CPBillSub.BillUnitPrice,FI_CPBillSub.BillTotalMoney,FI_CPBillMain.DocNum as FIDocNum,
      FI_CPBillSub.ID as FIID,
 case (CASE FI_MaterialOrderInfoMain.MS_CustomerGetCompanyInfo_ID 
WHEN '1eeb85db-8fa4-4bb8-8a0b-f66e8914a3c2' THEN 'B11FA14F-0B9B-4E7B-8FD6-10ECAAD6C3C9' ELSE '0975D294-96AA-4CC0-82B1-1ADA4AACF8E3' END) when 'B11FA14F-0B9B-4E7B-8FD6-10ECAAD6C3C9' then '三海兰陵' 
      when '0975D294-96AA-4CC0-82B1-1ADA4AACF8E3' then '华兰股份' else '暂存江阴仓库(三海兰陵包装产品)' end as ProductInCompany
,
'' as TopProductTypeName,'' as TypeName,'' AS ProductKHTypeName,
      '0' AS ISDF,FI_CPBillMain.Remark,FI_CPBillMain.IsReceipt,FI_CPBillMain.TrackingNo,
       case FI_CPBillMain.status when '10' then '开单' else '已审核'  end as Status,
       '' as PackgeType,'' as BatchNum,isnull(FI_MaterialOrderInfoMain.docnum,'物料销售无匹配订单') as MSOrderDoc,
       '无订单合同' as AgreeNum,
       case  when MS_Customer.IsForeign=1 then FI_CPBillSub.BillTotalMoney
      else cast(FI_CPBillSub.BillTotalMoney/(1+FI_CPBillMain.FaxRate) as decimal(18,4)) end as LackTaxBillTotalMoney,
      '无' as DeliverType,FI_CPBillSub.ISAdjust,
       '' as ProductTypeNameHS
FROM FI_CPBillSub inner join FI_CPBillMain
on FI_CPBillSub.FI_CPBillMain_ID=FI_CPBillMain.ID
inner join FI_MaterialOrderInfoSub 
on FI_CPBillSub.CP_ProductOutSub_ID=FI_MaterialOrderInfoSub.ID
INNER JOIN FI_MaterialBasicInfo ON FI_MaterialOrderInfoSub.FI_MaterialBasicInfo_ID=FI_MaterialBasicInfo.ID
inner join FI_MaterialOrderInfoMain on FI_MaterialOrderInfoMain.ID=FI_MaterialOrderInfoSub.FI_MaterialOrderInfoMain_ID
inner join FI_MaterialCustomerInfo on FI_MaterialCustomerInfo.ID=FI_MaterialOrderInfoMain.FI_MaterialCustomerInfo_ID
INNER JOIN MS_Customer ON FI_CPBillMain.FI_MS_Customer_ID=MS_Customer.ID
inner join MS_CustomerGetCompany on FI_MaterialOrderInfoMain.MS_CustomerGetCompanyInfo_ID=MS_CustomerGetCompany.ID
LEFT OUTER JOIN MS_CustomerSaler ON MS_Customer.Saler=MS_CustomerSaler.ID
      LEFT OUTER JOIN MS_CustomerSaleArea ON MS_CustomerSaleArea.ID=MS_Customer.SaleArea
left outer join MS_Customer customerb on customerb.ID=FI_MaterialCustomerInfo.ID
where FI_MaterialOrderInfoMain.status<>'10'
and FI_MaterialOrderInfoSub.ISJS=1
AND (FI_CPBillMain.BillDate>=@docdate)
AND (FI_CPBillMain.FI_MS_Customer_ID NOT IN ('1731','249'))
)d
group by YEAR(BillDate),MONTH(BillDate)

select #a.MonthInfo,
cast(#a.OrderQty as int) as OrderQty,cast(#a.OrderMoney/10000 as int ) as OrderMoney,
cast(#b.OutQty as int) as OutQty, cast(#b.OutMonty/10000 as int) as OutMoney,
cast(#d.BillQty as int) as BillQty,cast(#d.BillMoney/10000 as int ) as BillMoney
from #a
inner join #b on #a.MonthInfo=#b.MonthInfo
inner join #d on #a.MonthInfo=#d.MonthInfo
order by #a.MonthInfo


drop table #a
drop table #b
drop table #d
