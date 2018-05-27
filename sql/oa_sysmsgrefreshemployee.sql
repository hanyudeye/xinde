USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[OA_SysMsgRefreshEmployee]    Script Date: 2018/5/24 7:29:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/*Michael 设置谁有Message*/
ALTER  Proc [dbo].[OA_SysMsgRefreshEmployee]
As

UPDATE PM_Employee
SET HaveMessage = 0
FROM PM_Employee LEFT OUTER JOIN
(SELECT DISTINCT UserID
FROM OA_SysMsgUser
WHERE (ActiveRecord > 0)) MsgUser ON 
PM_Employee.ID = MsgUser.UserID
WHERE (MsgUser.UserID IS NULL) AND (PM_Employee.HaveMessage = 1)

UPDATE PM_Employee
SET HaveMessage = 1
FROM PM_Employee LEFT OUTER JOIN
(SELECT DISTINCT UserID
FROM OA_SysMsgUser
WHERE (ActiveRecord > 0)) MsgUser ON 
PM_Employee.ID = MsgUser.UserID
WHERE (MsgUser.UserID IS Not NULL) AND (PM_Employee.HaveMessage = 0)
