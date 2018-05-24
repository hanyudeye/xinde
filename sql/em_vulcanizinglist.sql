USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[EM_TrimmingTransferSave]    Script Date: 2018/5/24 7:28:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--冲边模具调动界面，保存时自动更新模具相关信息
--高坤
--2012-05-29

ALTER PROC [dbo].[EM_TrimmingTransferSave]
@EM_TrimmingMainID NVARCHAR(50)

AS 

BEGIN

DECLARE @TransferID NVARCHAR(50)	--最新一条记录
DECLARE @NewSN NVARCHAR(50)
DECLARE @NewCode NVARCHAR(50)
DECLARE @NewWorkLocation NVARCHAR(50)


SET @TransferID=(SELECT TOP 1 ID FROM EM_TrimmingTransfer 
				WHERE EM_TrimmingMain_ID=@EM_TrimmingMainID
				ORDER BY DocDate DESC)
				
/*
IF ISNULL(@TransferID,'')=''
BEGIN
	SELECT 0 AS CheckResult,'没有记录不能保存，请退出！' AS CheckMsg
	RETURN
END
*/


SELECT @NewSN=NewSN,@NewCode=NewCode, @NewWorkLocation=NewWorkLocation 
FROM EM_TrimmingTransfer WHERE ID=@TransferID


IF EXISTS(SELECT 1
		FROM EM_TrimmingMain
		WHERE TriCode=@NewCode AND MS_OrderWorkLocation_ID=@NewWorkLocation AND ID<>@EM_TrimmingMainID)
BEGIN 
	SELECT 0 AS CheckResult,'新模具编码已被使用，请确认！' as CheckMsg
	RETURN
END


IF ISNULL(@NewCode,'')<>'' AND ISNULL(@NewWorkLocation,'')<>''
	BEGIN
		UPDATE EM_TrimmingMain
		SET TriSN=@NewSN,TriCode=@NewCode,MS_OrderWorkLocation_ID=@NewWorkLocation
		WHERE ID=@EM_TrimmingMainID
	END

IF @@ERROR<>0
	BEGIN
		ROLLBACK TRANSACTION 
		RAISERROR ('更新冲边模具信息出错！如有疑问，可联系信息部开发人员',16,1)
		RETURN
	END


END
