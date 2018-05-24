USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[CG_MaterialInDetail]    Script Date: 2018/5/24 7:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--编写者：白兵
--编写日期：2011-11-20
--主要功能：原材料五金仓库库存报表-入库明细
--2012-09-22高坤修改,将该表值函数改为存储过程

--EXEC CG_MaterialInDetail '2012-09-21','2012-09-22','','','','','','',1

ALTER PROC [dbo].[CG_MaterialInDetail]
@DocDate1 datetime,
@DocDate2 datetime,
@CG_CompanyInfo_ID NVARCHAR(50),
@CG_MaterialGroup_ID NVARCHAR(50),
@MaterialCode NVARCHAR(50),
@MaterialName NVARCHAR(50),
@Spec NVARCHAR(50),
@BatchNum NVARCHAR(50),
@TempValue INT

AS

IF @TempValue=1
BEGIN
SELECT CG_MaterialInSub.ID, CG_AgreementMain.AgreementNum, 
CG_AgreementMain.AgreementDate, CG_AgreementSub.Number, 
CG_AgreementSub.UnitPrice, CG_Material.MaterialCode, CG_Material.MaterialName, 
CG_Material.Spec, CG_Material.Unit, 
CG_MaterialGroup.MaterialGroupName, HR_Department.DepartmentName, 
HR_Employee.EmployeeName, CG_BusinessPartner.CardName, 
CG_CompanyInfo.CompanyName, CG_MaterialInSub.BatchNum, CG_MaterialInSub.InQuantity, 
CG_MaterialInSub.FIBillAmount,CG_MaterialInSub.FIBillLackAmount,
CG_AgreementSub.InQty,CG_AgreementSub.LackInQty,
CASE CG_MaterialInSub.Status WHEN '10' THEN '已收料待检' WHEN '20' THEN '已入库审核' ELSE '财务已月结' END AS Status, 
CG_MaterialInMain.InDate as DocDate,CG_MaterialInSub.CG_MaterialInMain_ID,CG_MaterialInMain.DocNum
FROM   CG_MaterialInSub INNER JOIN
CG_MaterialInMain ON CG_MaterialInSub.CG_MaterialInMain_ID = CG_MaterialInMain.ID INNER JOIN
CG_BusinessPartner INNER JOIN
CG_MaterialGroup INNER JOIN
CG_Material ON CG_MaterialGroup.ID = CG_Material.CG_MaterialGroup_ID 
--INNER JOIN CG_QuotationSub ON CG_Material.ID = CG_QuotationSub.CG_Material_ID 
INNER JOIN
CG_PurchaseSub ON CG_Material.ID = CG_PurchaseSub.CG_Material_ID INNER JOIN
CG_AgreementMain INNER JOIN
CG_AgreementSub ON CG_AgreementMain.ID = CG_AgreementSub.CG_AgreementMain_ID ON 
CG_PurchaseSub.ID = CG_AgreementSub.CG_PurchaseSub_ID --AND CG_QuotationSub.ID = CG_AgreementSub.CG_QuotationSub_ID
 ON 
CG_BusinessPartner.ID = CG_AgreementMain.CG_BusinessPartner_ID INNER JOIN
CG_CompanyInfo ON CG_AgreementMain.CG_CompanyInfo_ID = CG_CompanyInfo.ID ON 
CG_MaterialInSub.CG_AgreementSub_ID = CG_AgreementSub.ID LEFT OUTER JOIN
HR_Employee RIGHT OUTER JOIN
HR_Department ON HR_Employee.HR_Department_ID = HR_Department.ID ON CG_PurchaseSub.PurchaseEmpID = HR_Employee.ID
WHERE   (CG_MaterialInMain.InDate BETWEEN @DocDate1 AND @DocDate2)
and CG_MaterialInSub.Status not IN ('10','99')
AND (CG_MaterialInMain.CG_CompanyInfo_ID=@CG_CompanyInfo_ID OR ISNULL(@CG_CompanyInfo_ID,'')='')
AND (CG_Material.MaterialName LIKE '%'+@MaterialName+'%' OR ISNULL(@MaterialName,'')='')
AND (CG_MaterialGroup.ID=@CG_MaterialGroup_ID OR ISNULL(@CG_MaterialGroup_ID,'')='')
AND (CG_Material.MaterialCode LIKE '%'+@MaterialCode+'%' OR ISNULL(@MaterialCode,'')='')
AND (CG_Material.Spec LIKE '%'+@Spec+'%' OR ISNULL(@Spec,'')='')
AND (CG_MaterialInSub.BatchNum LIKE '%'+@BatchNum+'%' OR ISNULL(@BatchNum,'')='')
ORDER BY CG_MaterialInMain.InDate DESC
END

ELSE BEGIN
SELECT '' AS ID, '' AS AgreementNum,'' AS AgreementDate, '' AS Number, 
	'' AS UnitPrice,'' AS MaterialCode,'' AS MaterialName,'' AS Spec,'' AS Unit, 
	'' AS MaterialGroupName,'' AS DepartmentName,'' AS EmployeeName,'' AS CardName, 
	'' AS CompanyName,'' AS BatchNum, '' AS InQuantity, '' AS FIBillAmount,
	'' AS FIBillLackAmount,'' AS InQty,'' AS LackInQty,'' AS Status, 
	'' AS DocDate,'' AS CG_MaterialInMain_ID,'' AS DocNum

END



















