USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[Dwm_SA_SystemMessageAlertsPlan]    Script Date: 2018/5/24 7:28:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[Dwm_SA_SystemMessageAlertsPlan]
AS
-------系统任务执行计划脚本-----------------
DECLARE  @TmpMessageTable TABLE(ID INT IDENTITY(1,1),MessageID NVARCHAR(50),DataString NVARCHAR(MAX))
DECLARE  @TmpMessageDetail TABLE(MsgData NVARCHAR(500),FormID NVARCHAR(50)
,FormKey NVARCHAR(50),UserID NVARCHAR(50),DItem NVARCHAR(50),MessageID NVARCHAR(50),SortSN INT)
DECLARE @TmpUserTable TABLE(ID INT,UserID NVARCHAR(50),DItem NVARCHAR(50),XXYH BIT,XXGS BIT)
DECLARE @TmpRowCount INT
DECLARE @TmpRowIndex INT
INSERT INTO @TmpMessageTable(MessageID,DataString)
SELECT ID,DataString FROM SA_SystemMessageAlerts(nolock)
WHERE  ISNULL(IsEnabled,0) = 1 AND DATEDIFF(SS,LastExecuteTime,GETDATE())>=IntervalSecond 

SELECT  @TmpRowCount = COUNT(1) FROM @TmpMessageTable
DECLARE @TmpDataString NVARCHAR(MAX)
DECLARE @TmpMesssageID NVARCHAR(50)
SET @TmpRowIndex = 1
DECLARE @TmpRowIndexDetail INT
DECLARE @TmpRowCountDetail INT
DECLARE @TmpXXYH BIT
DECLARE @TmpXXGS BIT
DECLARE @TmpUserID NVARCHAR(50)
DECLARE @TmpDItem NVARCHAR(50)
WHILE @TmpRowIndex<=@TmpRowCount
	BEGIN
		BEGIN TRY
		SELECT @TmpDataString =DataString,@TmpMesssageID = MessageID FROM @TmpMessageTable WHERE ID =@TmpRowIndex 
		
	    UPDATE SA_SystemMessageAlerts SET LastExecuteTime =GETDATE() WHERE ID = @TmpMesssageID
	    
	    DELETE FROM SA_SystemMessageAlertsDetail where MessageID = @TmpMesssageID
	    
		DELETE FROM @TmpMessageDetail
		
		INSERT INTO @TmpMessageDetail(MsgData,FormID,FormKey,UserID,DItem,SortSN) EXEC(@TmpDataString)
		
		UPDATE @TmpMessageDetail SET MessageID = @TmpMesssageID
		
		
		DELETE FROM @TmpUserTable
		INSERT INTO @TmpUserTable (ID,DItem,UserID,XXYH,XXGS)
		SELECT ROW_NUMBER() OVER(ORDER BY EmployeeID),MAX(DItem),
		EmployeeID,CAST(MAX(XXYH) AS BIT),CAST(MAX(XXGS) AS BIT) FROM 
		(
		SELECT T2.DItem,T1.EmployeeID,CASE WHEN ISNULL(T1.XXYH,0) = 1 THEN 1 ELSE 0 END AS XXYH,
		CASE WHEN ISNULL(T1.XXGS,0)=1 THEN 1 ELSE 0 END AS XXGS FROM SA_SystemMessageAlertsUser AS T1
		LEFT JOIN PM_Employee AS T2 ON T1.EmployeeID = T2.ID WHERE T1.SA_SystemMessageAlerts_ID = @TmpMesssageID
		UNION ALL
		SELECT T4.DItem,T3.EmployeeID,CASE WHEN ISNULL(T1.XXYH,0) = 1 THEN 1 ELSE 0 END AS XXYH,
		CASE WHEN ISNULL(T1.XXGS,0)=1 THEN 1 ELSE 0 END AS XXGS FROM SA_SystemMessageAlertsRole AS T1
		LEFT JOIN PM_Role AS T2 ON T1.RoleID = T2.ID
		INNER JOIN PM_Employee_Role AS T3 ON T1.RoleID = T3.RoleID 
		INNER JOIN PM_Employee AS T4 ON T3.EmployeeID = T4.ID
		WHERE T1.SA_SystemMessageAlerts_ID = @TmpMesssageID 
		) AS DefaultTable GROUP BY DefaultTable.EmployeeID
		
		SET @TmpRowIndexDetail = 1
		SELECT @TmpRowCountDetail = COUNT(1) FROM @TmpUserTable
		WHILE @TmpRowIndexDetail<=@TmpRowCountDetail
			BEGIN
				SELECT @TmpUserID = UserID,@TmpXXYH = XXYH,@TmpXXGS = XXGS,@TmpDItem = DItem FROM @TmpUserTable WHERE ID = @TmpRowIndexDetail
				----不限制用户和公司
				IF ISNULL(@TmpXXYH,0) = 0 AND ISNULL(@TmpXXGS,0) = 0
					BEGIN
						INSERT INTO SA_SystemMessageAlertsDetail(ID,MessageID,MsgDate,MsgType,MsgContent,
						FormID,FormKey,UserID,SortSN)
						SELECT NEWID(),MessageID,GETDATE(),'1',MsgData,FormID,FormKey,@TmpUserID,SortSN
						FROM @TmpMessageDetail 
					END
				ELSE
					BEGIN
						IF ISNULL(@TmpXXYH,0) =1 AND ISNULL(@TmpXXGS,0) = 1
							BEGIN
								INSERT INTO SA_SystemMessageAlertsDetail(ID,MessageID,MsgDate,MsgType,MsgContent,
								FormID,FormKey,UserID,SortSN)
								SELECT NEWID(),MessageID,GETDATE(),'1',MsgData,FormID,FormKey,@TmpUserID,
								SortSN
								FROM @TmpMessageDetail WHERE  UserID = @TmpUserID AND DItem = @TmpDItem
							END
						ELSE IF ISNULL(@TmpXXYH,0) =1
							BEGIN
								INSERT INTO SA_SystemMessageAlertsDetail(ID,MessageID,MsgDate,MsgType,MsgContent,
								FormID,FormKey,UserID,SortSN)
								SELECT NEWID(),MessageID,GETDATE(),'1',MsgData,FormID,FormKey,@TmpUserID,
								SortSN
								FROM @TmpMessageDetail WHERE  UserID = @TmpUserID 
							END
						ELSE
							BEGIN
								INSERT INTO SA_SystemMessageAlertsDetail(ID,MessageID,MsgDate,MsgType,MsgContent,
								FormID,FormKey,UserID,SortSN)
								SELECT NEWID(),MessageID,GETDATE(),'1',MsgData,FormID,FormKey,@TmpUserID,
								SortSN
								FROM @TmpMessageDetail WHERE  DItem = @TmpDItem
							END
					END
				
				SET @TmpRowIndexDetail = @TmpRowIndexDetail + 1
			END
		END TRY
		BEGIN CATCH
		END CATCH
		SET @TmpRowIndex = @TmpRowIndex+1
	END
	
