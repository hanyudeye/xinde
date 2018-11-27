USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[DWM_Loading_RolePower]    Script Date: 2018/5/24 7:25:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

hh


ALTER PROC [dbo].[DWM_Loading_RolePower]
@EMSCommon NVARCHAR(100),
@Language NVARCHAR(50)
AS
--EXEC [DWM_Loading_RolePower] 'DowayEMSCommon'
SELECT ID,Memo,AllowLogin,lan1_RoleName,lan3_RoleName,'' AS RoleName FROM PM_Role
DECLARE @TmpSql NVARCHAR(4000)
--加载菜单
SET @TmpSql = 'SELECT ID AS MenuID,'''' AS RoleID,CASE WHEN ISNULL(ParentID,'''')='''' THEN ''3A4829E7-47D0-424E-8A87-3AE3894BBA1E'' ELSE ParentID END AS ParentID,
NEWID() AS PowerID,lan1_Caption,
lan3_Caption,
 '''' AS MenuCaption,CAST(0 AS BIT) AS View_Allow,
 CAST(0 AS BIT) AS View_NotAllow,CAST(0 AS BIT) AS View_Forbid,CAST(0 AS BIT) AS Edit_Allow,
CAST(0 AS BIT) AS Edit_NotAllow,CAST(0 AS BIT) AS Edit_Forbid,IsFunction FROM '+@EMSCommon+'..UI_Menus 
WHERE ISNULL(IsFunction,0) = 0 ORDER BY Sort'
EXEC(@TmpSql)
--加载功能
SET @TmpSql = 'WITH TmpTable
AS
(
--子项
SELECT ID AS MenuID,ParentID,lan1_Caption,
lan3_Caption,IsFunction,Sort FROM '+@EMSCommon+'..UI_Menus 
WHERE ISNULL(IsFunction,0) = 1
UNION ALL
--递归结果集中的下级
SELECT T1.ID AS MenuID,T1.ParentID AS ParentID,
T1.lan1_Caption,T1.lan3_Caption,CAST(0 AS BIT) AS IsFunction,T1.Sort
FROM '+@EMSCommon+'..UI_Menus AS T1
INNER JOIN TmpTable AS T2 ON T1.ID = T2.ParentID
)
SELECT  MenuID,'''' AS RoleID,
CASE WHEN ISNULL(MAX(ParentID),'''')='''' THEN ''3A4829E7-47D0-424E-8A87-3AE3894BBA1E'' ELSE MAX(ParentID) END AS ParentID
,NEWID() AS PowerID,
MAX(lan1_Caption) AS lan1_Caption,
MAX(lan3_Caption) AS lan3_Caption,'''' AS MenuCaption,CAST(0 AS BIT) AS View_Allow,
 CAST(0 AS BIT) AS View_NotAllow,CAST(0 AS BIT) AS View_Forbid,CAST(0 AS BIT) AS Edit_Allow,
CAST(0 AS BIT) AS Edit_NotAllow,CAST(0 AS BIT) AS Edit_Forbid,
CAST(MAX(CAST(ISNULL(IsFunction,0) AS INT)) AS BIT) AS IsFunction,
MAX(Sort) AS Sort  FROM TmpTable GROUP BY MenuID 
ORDER BY Sort'
EXEC(@TmpSql)
SET @TmpSql ='SELECT '''' AS RoleID,T1.ID AS DataID, T1.lan1_Caption,T1.lan3_Caption,CAST(0 AS BIT) AS View_Allow,
 CAST(0 AS BIT) AS View_NotAllow,CAST(0 AS BIT) AS View_Forbid,CAST(0 AS BIT) AS Edit_Allow,
CAST(0 AS BIT) AS Edit_NotAllow,CAST(0 AS BIT) AS Edit_Forbid,'''' AS WebPartCaption FROM '+@EMSCommon+'..UI_Datas AS T1
 WHERE T1.FormID=''WebPartFormID'' ORDER BY SN' 
--加载门户权限
EXEC(@TmpSql)






