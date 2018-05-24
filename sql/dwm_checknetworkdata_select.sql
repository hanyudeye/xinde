USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[DWM_CheckNetWorkData_Select]    Script Date: 2018/5/24 7:25:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER proc  [dbo].[DWM_CheckNetWorkData_Select]
@GItem NVARCHAR(50),--集团代码
@DItem NVARCHAR(50),--渠道代码
@UserItem NVARCHAR(50),--当前用户名
@IsFirstLogin NCHAR(1),--是否登录(1:是登录,否则是更新)
@ManchineName NVARCHAR(100),
@UserHostAddress NVARCHAR(100),
@UserWebAddress NVARCHAR(100),
@ManchineMac  NVARCHAR(100),
@MachineCPU NVARCHAR(50),
@MachineBoard NVARCHAR(50),
@MachineDiskCard NVARCHAR(50),
@CurrentDeploymentVersion NVARCHAR(50)
as
------------------------更新登录信息-------------------------

DECLARE @TmpUserID NVARCHAR(50)
SELECT @TmpUserID = T1.ID FROM PM_Employee(NOLOCK) AS T1
WHERE T1.Code=  @UserItem AND 
T1.DItem = @DItem AND T1.GItem = @GItem


IF @IsFirstLogin='1'
	BEGIN
	
		UPDATE PM_Employee SET ManchineName=@ManchineName,UserHostAddress=@UserHostAddress,UserWebAddress = @UserWebAddress,
		ManchineMac = @ManchineMac,LastLoginTime = GETDATE(),LoginCount=ISNULL(LoginCount,0)+1,LastActiveTime=GETDATE(),
		MachineCPU = @MachineCPU,MachineBoard = @MachineBoard,MachineDiskCard = @MachineDiskCard,
		CurrentDeploymentVersion = @CurrentDeploymentVersion
		WHERE ID=@TmpUserID 
		 
		--INSERT INTO SA_SystemLog(LogGItem,LogDItem,LogLevelType,SystemUser,ManchineName,UserHostAddress,UserWebAddress,ManchineMac,
		--LogCreateTime) VALUES(@GItem,@DItem,'Login',@UserItem,@ManchineName,@UserHostAddress,@UserWebAddress,@ManchineMac,GETDATE())
	END
ELSE
	BEGIN
		UPDATE PM_Employee SET ManchineName=@ManchineName,UserHostAddress=@UserHostAddress,
		UserWebAddress = @UserWebAddress,ManchineMac = @ManchineMac,LastActiveTime=GETDATE(),
		MachineCPU = @MachineCPU,MachineBoard = @MachineBoard,MachineDiskCard = @MachineDiskCard,
		CurrentDeploymentVersion = @CurrentDeploymentVersion
		WHERE ID=@TmpUserID 
	END
---------------------获取在线人数--------------------------------
DECLARE @OnLineCount INT
SELECT @OnLineCount =  COUNT(1) FROM PM_Employee(NOLOCK) WHERE LastActiveTime>= DATEADD(SS,-30,GETDATE())

----------------------获取最后同步时间----------------------------
DECLARE @LastSyncTime NVARCHAR(50)
SELECT TOP 1 @LastSyncTime =T1.SysConfigValue FROM SA_SysConfig(NOLOCK) AS T1
 WHERE T1.GItem = @GItem AND T1.DItem = @DItem AND T1.SysConfigName = 'LastSyncTime'
----------------------获取当前服务器端版本信息
DECLARE @CurrentVersion NVARCHAR(50)
SELECT TOP 1 @CurrentVersion =SysConfigValue FROM SA_SysConfig(NOLOCK) AS T1
 WHERE  T1.GItem = @GItem AND T1.DItem = @DItem AND T1.SysConfigName = 'CurrentVersion'
------------------------联网状态获取相关数据信息--------------
SELECT @OnLineCount AS OnLineCount,0 AS IsNewMessage,@LastSyncTime AS LastSyncTime,
@CurrentVersion AS CurrentVersion
------------------------返回用户消息信息--------------------------
SELECT '标记已读' AS Operation, A.ID AS MessageUserID,B.MessageTitle, B.ID AS MessageID,B.MessageContent AS Content,
B.IsAccessory,B.SendTime,B.SendUser,T2.lan1_Name AS SendUserName,'' AS SendStoreName,'4DAD12B3-41F9-4CCF-829B-091C8C6CA6CE' AS FormID 
FROM SA_SystemMessageUser(NOLOCK) AS A 
LEFT JOIN SA_SystemMessage(NOLOCK) AS B ON A.SystemMessageID = B.ID 
LEFT JOIN PM_Employee AS T2 ON B.SendUser = T2.ID
WHERE A.ReceiveUser = @TmpUserID AND ISNULL(A.IsRead,0) = 0 AND B.Status='20'
-------------------------返回系统消息信息----------------------
SELECT '处理' AS Operation, T2.FormID,T2.FormKey,T2.MsgContent,T2.UserID FROM SA_SystemMessageAlerts(NOLOCK) AS T1
INNER JOIN SA_SystemMessageAlertsDetail(NOLOCK) AS T2 ON T1.ID= T2.MessageID
WHERE ISNULL(T1.IsEnabled,0)=1 AND T2.UserID = @TmpUserID
ORDER BY T2.MessageID,T2.SortSN



