USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[CG_AgreementMainAuditCancle]    Script Date: 2018/5/24 7:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--编写者：白兵
--编写日期：2011-07-20
--主要功能：合同单据弃审更新状态

---


ALTER        PROC   [dbo].[CG_AgreementMainAuditCancle]
@DocID NVARCHAR(50)

AS 
BEGIN 

DECLARE @Curline CURSOR
DECLARE @SubID NVARCHAR(50)             ----子表ID
DECLARE @CG_PurchaseSub_ID NVARCHAR(50)  ----子表中请购单子表ID
DECLARE @CG_QuotationSub_ID NVARCHAR(50)  ----子表中报价单子表ID





SET @Curline = CURSOR for
SELECT ID
FROM CG_AgreementSub
WHERE (CG_AgreementMain_ID = @DocID and Status='20')

OPEN @Curline

---while @@FETCH_STATUS <> 0
WHILE (1 = 1)
BEGIN
	FETCH NEXT FROM  @Curline INTO @SubID

	IF (@@FETCH_STATUS<>0) BREAK
----判断弃审时是否该物料已经入库，如已发生入库，则不允许弃审
	IF EXISTS(SELECT 1 FROM CG_AgreementSub
			  WHERE InQty>0
			  AND ID=@SubID)
	BEGIN
		RAISERROR('该合同中物料已存在入库记录，请先弃审对应入库单后方可弃审合同记录，如有疑问，请联系信息部开发人员!',16,1) WITH SETERROR
		RETURN
	END
----更新合同子表记录状态
	BEGIN
		UPDATE CG_AgreementSub
		SET Status='10'
		WHERE ID=@SubID
		IF @@ROWCOUNT<>1 OR @@error<>0
				BEGIN
					ROLLBACK TRAN
					RAISERROR('更新合同单据子表状态出错!',16,1) WITH SETERROR
					RETURN
				END
	END
----更新请购单子表记录状态	
	SET @CG_PurchaseSub_ID=(SELECT CG_PurchaseSub_ID FROM CG_AgreementSub WHERE ID=@SubID)
	IF EXISTS(SELECT 1 FROM CG_PurchaseSub WHERE ID=@CG_PurchaseSub_ID AND Status='30')
	BEGIN
		UPDATE CG_PurchaseSub
		SET Status='20'
		WHERE ID=@CG_PurchaseSub_ID AND Status='30'
		IF @@ROWCOUNT<>1 OR @@error<>0
				BEGIN
					ROLLBACK TRAN
					RAISERROR('更新请购单据子表状态出错!',16,1) WITH SETERROR
					RETURN
				END
	
	END
----更新请购单主表记录状态	

	IF  EXISTS(SELECT 1 FROM CG_PurchaseSub 
				WHERE CG_PurchaseMain_ID=(SELECT CG_PurchaseMain_ID FROM CG_PurchaseSub where ID=@CG_PurchaseSub_ID) 
				AND Status IN ('20','10'))
	BEGIN
		UPDATE CG_PurchaseMain
		SET Status='20'
		WHERE ID=(SELECT CG_PurchaseMain_ID FROM CG_PurchaseSub where ID=@CG_PurchaseSub_ID)  
		--AND Status='30'
		IF @@ROWCOUNT<>1 OR @@error<>0
				BEGIN
					ROLLBACK TRAN
					RAISERROR('更新请购单据主表状态出错!',16,1) WITH SETERROR
					RETURN
				END
		
	END	
	
----更新报价单子表记录状态	
	SET @CG_QuotationSub_ID=(SELECT CG_QuotationSub_ID FROM CG_AgreementSub WHERE ID=@SubID)
	IF EXISTS(SELECT 1 FROM CG_QuotationSub WHERE ID=@CG_QuotationSub_ID AND Status='30')
	BEGIN
		UPDATE CG_QuotationSub
		SET Status='20'
		WHERE ID=@CG_QuotationSub_ID 
		IF @@ROWCOUNT<>1 OR @@error<>0
				BEGIN
					ROLLBACK TRAN
					RAISERROR('更新报价单据子表状态出错!',16,1) WITH SETERROR
					RETURN
				END
	
	END
	
----更新报价单主表记录状态	

	IF EXISTS(SELECT 1 FROM CG_QuotationSub 
				WHERE CG_QuotationMain_ID=(SELECT  CG_QuotationMain_ID FROM CG_QuotationSub WHERE ID=@CG_QuotationSub_ID) 
				AND Status IN ('20','10'))
	AND  EXISTS(SELECT 1 FROM CG_QuotationMain
				WHERE ID=(SELECT  CG_QuotationMain_ID FROM CG_QuotationSub WHERE ID=@CG_QuotationSub_ID)
				AND Status='30')
	BEGIN
		UPDATE CG_QuotationMain
		SET Status='20'
		WHERE ID=(SELECT  CG_QuotationMain_ID FROM CG_QuotationSub WHERE ID=@CG_QuotationSub_ID) 
		-- AND Status='30'
		IF @@ROWCOUNT<>1 OR @@error<>0
				BEGIN
					ROLLBACK TRAN
					RAISERROR('更新报价单据主表状态出错!',16,1) WITH SETERROR
					RETURN
				END
	
	END
	
END


CLOSE @Curline
DEALLOCATE @Curline


END











