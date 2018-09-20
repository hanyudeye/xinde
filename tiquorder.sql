订单类型  生产订单:  work,样品订单: sample ,其他 :other
-- 样品生产列表

SELECT PP_WorkSampleOrder.ID,PP_WorkSampleOrder.DocDate,PP_WorkSampleOrder.YBatchNo,MS_OrderWorkLocation.WorkLocation,PT_RecipeInfoMain.RecipeCode,
	PT_RecipeInfoMain.RecipeVer,PT_RecipeTypeInfo.RecipeTypeName,MS_SampleOrderInfo.DocNum,MS_Customer.CardName,
	PT_ProductSpec.ProductSpecName,PT_ProductType.ProductTypeName,MS_SampleOrderInfo.IsNoWashing,MS_SampleOrderInfo.Qty,
	MS_SampleOrderInfo.DeliverDate,MS_SampleOrderInfo.AskForReason,PP_WorkSampleOrder.Remark,PP_WorkSampleOrder.Status,
	MS_SampleOrderInfo.ISGH
FROM PP_WorkSampleOrderSubMSOrder
	INNER JOIN PP_WorkSampleOrder ON PP_WorkSampleOrderSubMSOrder.PP_WorkSampleOrder_ID=PP_WorkSampleOrder.ID
	INNER JOIN MS_OrderWorkLocation ON PP_WorkSampleOrder.MS_OrderWorkLocation_ID=MS_OrderWorkLocation.ID
	INNER JOIN PT_RecipeInfoMain ON PP_WorkSampleOrder.PT_RecipeInfoMain_ID=PT_RecipeInfoMain.ID
	INNER JOIN PT_RecipeTypeInfo ON PT_RecipeInfoMain.PT_RecipeTypeInfo_ID=PT_RecipeTypeInfo.ID
	LEFT JOIN MS_SampleOrderInfo ON PP_WorkSampleOrderSubMSOrder.MS_SampleOrderInfo_ID=MS_SampleOrderInfo.ID
	INNER JOIN MS_Customer ON MS_SampleOrderInfo.MS_Customer_ID=MS_Customer.ID
	INNER JOIN PT_ProductSpec ON MS_SampleOrderInfo.PT_ProductSpec_ID=PT_ProductSpec.ID
	INNER JOIN PT_ProductType ON PT_ProductSpec.PT_ProductType_ID=PT_ProductType.ID

-- 字段含义
ID	ID
生产日期	DocDate
样品批号	YBatchNo
生产基地	WorkLocation
配方号	RecipeCode
配方版本	RecipeVer
配方类别	RecipeTypeName
订单编号	DocNum
客户	CardName
规格型号	ProductSpecName
产品分类	ProductTypeName
免洗	IsNoWashing
固化	ISGH
数量(万只)	Qty
交货日期	DeliverDate
申请理由	AskForReason
备注	Remark
单据状态	Status

--- 生产计划列表
SELECT PP_WorkOrder.ID,PP_WorkOrder.DocDate,PP_WorkOrder.BatchNo,PT_RecipeInfoMain.RecipeCode,PT_RecipeInfoMain.RecipeVer,PT_RecipeTypeInfo.RecipeTypeName,
	MS_Customer.CardName,MS_OrderInfoMain.DeliveryDate,MS_OrderInfoSub.Qty,MS_OrderInfoSub.AdjustQty,MS_OrderInfoSub.WorkPlanQty,
	PP_WorkShop.WorkShop,PP_WorkOrderSubMSOrder.WorkEndDate,PP_WorkOrderSubMSOrder.FeedingTheoryQty,PP_WorkOrderSubMSOrder.WorkQty,
	PP_WorkOrderSubMSOrder.HoleNo,PT_RecipePerWeight.PerWeight,PT_ProductType.ProductTypeName,MS_OrderWorkLocation.WorkLocation,
	PT_ProductSpec.ProductSpecName,ProductSpecCode,PT_ProductSpec.DrawingNo,MS_OrderInfoSub.IsnoWashing,CP_ProductPackage.ProductPackageName,
	MS_OrderInfoSub.DemandDetail,MS_OrderInfoSub.DocNum,PP_WorkOrderSubMSOrder.Remark,PT_ProductStanderd.ProductStanderdName,
	case PP_WorkOrder.Status when '10' then '开单' when '20' then '正在生产' else '生产已完成' end as Status,
	MS_OrderInfoSub.ISGH,PP_WorkOrderSubMSOrder.SubBatchNo,PP_WorkOrderSubMSOrder.IsFirst,PP_WorkOrderSubMSOrder.IsSecond,
	MS_OrderInfoSub.ISCT,MS_CustomerSaler.SalerName
FROM PP_WorkOrderSubMSOrder INNER JOIN
	PP_WorkOrder ON PP_WorkOrderSubMSOrder.PP_WorkOrder_ID=PP_WorkOrder.ID INNER JOIN
	PT_RecipeInfoMain ON PP_WorkOrderSubMSOrder.PT_RecipeInfoMain_ID=PT_RecipeInfoMain.ID INNER JOIN
	MS_OrderInfoSub ON PP_WorkOrderSubMSOrder.MS_OrderInfoSub_ID=MS_OrderInfoSub.ID LEFT OUTER JOIN
	PT_RecipePerWeight ON PP_WorkOrderSubMSOrder.PT_RecipePerWeight_ID=PT_RecipePerWeight.ID LEFT OUTER JOIN
	MS_OrderWorkLocation ON PP_WorkOrder.MS_OrderWorkLocation_ID=MS_OrderWorkLocation.ID LEFT OUTER JOIN
	PP_WorkShop ON PT_RecipePerWeight.PP_WorkShop_ID=PP_WorkShop.ID INNER JOIN
	PT_RecipeTypeInfo ON PT_RecipeInfoMain.PT_RecipeTypeInfo_ID=PT_RecipeTypeInfo.ID INNER JOIN
	MS_OrderInfoMain ON MS_OrderInfoSub.MS_OrderInfoMain_ID=MS_OrderInfoMain.ID INNER JOIN
	MS_Customer ON MS_OrderInfoMain.MS_Customer_ID=MS_Customer.ID INNER JOIN
	PT_ProductSpec ON MS_OrderInfoSub.PT_ProductSpec_ID=PT_ProductSpec.ID INNER JOIN
	PT_ProductType ON PT_ProductSpec.PT_ProductType_ID=PT_ProductType.ID INNER JOIN
	CP_ProductPackage ON MS_OrderInfoSub.CP_ProductPackage_ID=CP_ProductPackage.ID
	LEFT OUTER JOIN PT_ProductStanderd ON MS_OrderInfoSub.PT_ProductStanderd_ID=PT_ProductStanderd.ID
	LEFT OUTER JOIN MS_CustomerSaler ON MS_Customer.Saler=MS_CustomerSaler.ID

-- 字段含义
下达日期	DocDate
生产公司	WorkLocation
生产车间	WorkShop
生产批号	BatchNo
配方号	RecipeCode
配方版本	RecipeVer
配方类别	RecipeTypeName
标准名称	ProductStanderdName
产品分类	ProductTypeName
规格型号	ProductSpecName
规格编码	ProductSpecCode
图纸编号	DrawingNo
固化	
免洗	IsnoWashing
抽提	
包装	ProductPackageName
销售员	
客户	CardName
交货日期	DeliveryDate
生产交期	WorkEndDate
订单数量	Qty
调整数量	AdjustQty
销售下达数量	WorkPlanQty
理论投料数(辊)	FeedingTheoryQty
需生产数量	WorkQty
孔位数	HoleNo
炼胶单重KG	PerWeight
订单要求	DemandDetail
子订单编号	DocNum
备注	Remark
状态	Status
入库数量（万只）	
生产批号	
一次	
二次	




turquoise


-- 提取订单


如客户、图纸编号、规格型号名称、产品分类、配方编号、配方版本、配方类别、标准名称。


SELECT a.Remark,a.PT_RecipePerWeight_ID,a.Status,a.SubBatchNo,b.RecipeCode,b.RecipeVer,b.PT_RecipeTypeInfo_ID,c.RecipeTypeName,e.DrawingNo,e.ProductSpecName,e.PT_ProductTypeHS_ID,e.PT_ProductType_ID,g.ProductTypeName,e.ProductSpecCode,f.ProductTypeName as pinming,d.PT_ProductSpec_ID,a.PT_RecipeInfoMain_ID
FROM PP_WorkOrderSubMSOrder a
INNER JOIN	PP_WorkOrder ON a.PP_WorkOrder_ID=PP_WorkOrder.ID 
inner join PT_RecipeInfoMain b on a.PT_RecipeInfoMain_ID=b.ID
inner join PT_RecipeTypeInfo c on b.PT_RecipeTypeInfo_ID=c.ID
inner join MS_OrderInfoSub d on a.MS_OrderInfoSub_ID=d.ID
inner join PT_ProductSpec e on d.PT_ProductSpec_ID=e.ID
inner join PT_ProductTypeHS f on e.PT_ProductTypeHS_ID=f.ID
inner join PT_ProductType  g on e.PT_ProductType_ID=g.ID

ID	BatchNo	RecipeCode	RecipeVer	RecipeTypeName	CardName	ProductTypeName	ProductSpecName	ProductSpecCode	DrawingNo	ProductStanderdName	SubBatchNo

--生产订单
SELECT  PP_WorkOrderSubMSOrder.ID,PP_WorkOrder.DocDate,PP_WorkOrder.BatchNo,PT_RecipeInfoMain.RecipeCode,PT_RecipeInfoMain.RecipeVer,PT_RecipeTypeInfo.RecipeTypeName,
	MS_Customer.CardName,PT_ProductType.ProductTypeName,
	PT_ProductSpec.ProductSpecName,ProductSpecCode,PT_ProductSpec.DrawingNo,PT_ProductStanderd.ProductStanderdName,
	PP_WorkOrderSubMSOrder.SubBatchNo
FROM PP_WorkOrderSubMSOrder INNER JOIN
	PP_WorkOrder ON PP_WorkOrderSubMSOrder.PP_WorkOrder_ID=PP_WorkOrder.ID INNER JOIN
	PT_RecipeInfoMain ON PP_WorkOrderSubMSOrder.PT_RecipeInfoMain_ID=PT_RecipeInfoMain.ID INNER JOIN
	MS_OrderInfoSub ON PP_WorkOrderSubMSOrder.MS_OrderInfoSub_ID=MS_OrderInfoSub.ID LEFT OUTER JOIN
	PT_RecipeTypeInfo ON PT_RecipeInfoMain.PT_RecipeTypeInfo_ID=PT_RecipeTypeInfo.ID INNER JOIN
	MS_OrderInfoMain ON MS_OrderInfoSub.MS_OrderInfoMain_ID=MS_OrderInfoMain.ID INNER JOIN
	MS_Customer ON MS_OrderInfoMain.MS_Customer_ID=MS_Customer.ID INNER JOIN
	PT_ProductSpec ON MS_OrderInfoSub.PT_ProductSpec_ID=PT_ProductSpec.ID INNER JOIN
	PT_ProductType ON PT_ProductSpec.PT_ProductType_ID=PT_ProductType.ID INNER JOIN
	PT_ProductStanderd ON MS_OrderInfoSub.PT_ProductStanderd_ID=PT_ProductStanderd.ID
	
	select * from PP_WorkOrder
--ID	DocDate BatchNo	RecipeCode	RecipeVer	RecipeTypeName	CardName	ProductTypeName	ProductSpecName	ProductSpecCode	DrawingNo	ProductStanderdName	SubBatchNo

-- 销售订单
SELECT PP_WorkSampleOrderSubMSOrder.ID,PP_WorkSampleOrder.DocDate,PP_WorkSampleOrder.YBatchNo as BatchNo,PT_RecipeInfoMain.RecipeCode,
	PT_RecipeInfoMain.RecipeVer,PT_RecipeTypeInfo.RecipeTypeName,MS_Customer.CardName,
	PT_ProductType.ProductTypeName,PT_ProductSpec.ProductSpecName,PT_ProductSpec.ProductSpecCode,PT_ProductSpec.DrawingNo,PT_ProductStanderd.ProductStanderdName,PP_WorkSampleOrder.YBatchNo as SubBatchNo
FROM PP_WorkSampleOrderSubMSOrder
	INNER JOIN PP_WorkSampleOrder ON PP_WorkSampleOrderSubMSOrder.PP_WorkSampleOrder_ID=PP_WorkSampleOrder.ID
	INNER JOIN MS_OrderWorkLocation ON PP_WorkSampleOrder.MS_OrderWorkLocation_ID=MS_OrderWorkLocation.ID
	INNER JOIN PT_RecipeInfoMain ON PP_WorkSampleOrder.PT_RecipeInfoMain_ID=PT_RecipeInfoMain.ID
	INNER JOIN PT_RecipeTypeInfo ON PT_RecipeInfoMain.PT_RecipeTypeInfo_ID=PT_RecipeTypeInfo.ID
	LEFT JOIN MS_SampleOrderInfo ON PP_WorkSampleOrderSubMSOrder.MS_SampleOrderInfo_ID=MS_SampleOrderInfo.ID
	INNER JOIN MS_Customer ON MS_SampleOrderInfo.MS_Customer_ID=MS_Customer.ID
	INNER JOIN PT_ProductSpec ON MS_SampleOrderInfo.PT_ProductSpec_ID=PT_ProductSpec.ID
	INNER JOIN PT_ProductType ON PT_ProductSpec.PT_ProductType_ID=PT_ProductType.ID
	left JOIN PT_ProductStanderd ON MS_SampleOrderInfo.PT_ProductStanderd_ID=PT_ProductStanderd.ID

