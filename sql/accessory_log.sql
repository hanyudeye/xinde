USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[BO_Accessory_Log_Insert]    Script Date: 2018/5/24 7:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[BO_Accessory_Log_Insert]
@ID NVARCHAR(50),
@BO_Accessory_ID NVARCHAR(50),
@AccOriName NVARCHAR(1000),
@UserID NVARCHAR(50)
AS
INSERT INTO BO_Accessory_Log_Insert(ID,BO_Accessory_ID,AccOriName,UserID,UserDateTime)
VALUES(@ID,@BO_Accessory_ID,@AccOriName,@UserID,GETDATE())
