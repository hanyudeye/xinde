USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[DWM_Loading_CommonSetMenu]    Script Date: 2018/5/24 7:25:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[DWM_Loading_CommonSetMenu]
@EmployeeID NVARCHAR(50),
@Language NVARCHAR(50),
@CommonDataBase NVARCHAR(50)
AS
--EXEC DWM_Loading_CommonSetMenu '','lan1_','DowayEMSCommon'
DECLARE @TmpSql NVARCHAR(4000)
SET @TmpSql = 'SELECT T1.EmployeeID,T2.'+@Language+'Caption AS MenuCaption,T1.MenuID,T2.Img32 FROM PM_EmployeeMenu_Common AS T1
INNER JOIN '+@CommonDataBase+'..UI_Menus AS T2 ON T1.MenuID = T2.ID
WHERE T1.EmployeeID = '''+@EmployeeID+'''ORDER BY T1.Sort'
EXEC(@TmpSql)




