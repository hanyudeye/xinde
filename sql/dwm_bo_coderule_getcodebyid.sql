USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[DWM_BO_CodeRule_GetDocNumByID]    Script Date: 2018/5/24 7:24:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER proc [dbo].[DWM_BO_CodeRule_GetDocNumByID]
@GItem NVARCHAR(50),
@DItem NVARCHAR(50),
@CompanyMCode NVARCHAR(10),
@CodeRuleID NVARCHAR(50),
@DataField NVARCHAR(50),
@EMSCommonDataBaseName NVARCHAR(50),
@DocNum NVARCHAR(50) OUTPUT
AS
--EXEC DWM_BO_CodeRule_GetDocNumByID 'FTZY','SHFT','1','84','DocNum','DowayEMSCommon'

DECLARE @CodeRuleMask NVARCHAR(1000)
DECLARE @TmpCodeRule NVARCHAR(1000)
DECLARE @TmpCodeRuleExpression NVARCHAR(1000)
DECLARE @TmpCodeRuleTable NVARCHAR(50)
        DECLARE @TmpSql NVARCHAR(4000)
DECLARE @TmpTable TABLE(ID INT IDENTITY(1,1),CodeRuleMask NVARCHAR(1000),
CodeRule NVARCHAR(1000),CodeRuleExpression NVARCHAR(1000),CodeRuleTable NVARCHAR(50))

INSERT INTO @TmpTable(CodeRuleMask,CodeRule,CodeRuleExpression,CodeRuleTable)
EXEC('SELECT T1.CodeRuleMask,T1.CodeRule,T1.CodeRuleExpression,T1.CodeRuleTable FROM '+@EMSCommonDataBaseName+'..UI_Forms_CodeRule AS T1
WHERE T1.ID = '''+@CodeRuleID+'''')


SELECT TOP 1  @CodeRuleMask = CodeRuleMask,@TmpCodeRule = CodeRule,@TmpCodeRuleExpression = CodeRuleExpression,
@TmpCodeRuleTable = CodeRuleTable FROM @TmpTable 



IF ISNULL(@TmpCodeRule,'')<>''--新的生产批次规则
	BEGIN
		IF ISNULL(@TmpCodeRuleTable,'')=''
			BEGIN
				RAISERROR('未设置表名称',16,1)WITH NOWAIT;
				RETURN;
			END
		DECLARE @TmpTableName NVARCHAR(100)
		DECLARE @TmpPrevStr NVARCHAR(100)
		DECLARE @TmpDocNumLength NVARCHAR(50)
		
		IF ISNULL(@TmpCodeRuleExpression,'')=''
			BEGIN
				SET @TmpCodeRuleExpression = ' 1 = 1 '
			END
		IF CHARINDEX('@GItem',@TmpCodeRuleExpression)>0--集团号替换
			BEGIN
				SET @TmpCodeRuleExpression = REPLACE(@TmpCodeRuleExpression,'@GItem',''''+@GItem+'''')
			END
		IF CHARINDEX('@DItem',@TmpCodeRuleExpression)>0--公司好替换
			BEGIN
				SET @TmpCodeRuleExpression = REPLACE(@TmpCodeRuleExpression,'@DItem',''''+@DItem+'''')
			END
		IF CHARINDEX('@CompanyMCode',@TmpCodeRuleExpression)>0--公司助记码替换
			BEGIN
				SET @TmpCodeRuleExpression = REPLACE(@TmpCodeRuleExpression,'@CompanyMCode',''''+@CompanyMCode+'''')
			END
		SET @TmpPrevStr = SUBSTRING(@TmpCodeRule,1,CHARINDEX('#',@TmpCodeRule)-1)
		SET @TmpDocNumLength = SUBSTRING(@TmpCodeRule,CHARINDEX('#',@TmpCodeRule),20)
		SET @TmpCodeRuleExpression =@TmpCodeRuleExpression+ ' AND '+ISNULL(@DataField,'')+' LIKE '''+ISNULL(@TmpPrevStr,'')+'%'''
		SET @TmpSql = 'SELECT dbo.CreateMatOrderNum((SELECT MAX('+ISNULL(@DataField,'')+
         ') FROM '+ISNULL(@TmpCodeRuleTable,'')+' WHERE '+ISNULL(@TmpCodeRuleExpression,'') 
		+'),'''+ISNULL(@TmpPrevStr,'')+''','+CAST(LEN(@TmpDocNumLength) AS NVARCHAR)+')'
		
		IF CHARINDEX('@GItem',@TmpSql)>0--集团号替换
			BEGIN
				SET @TmpSql = REPLACE(@TmpSql,'@GItem',@GItem)
			END
		IF CHARINDEX('@DItem',@TmpSql)>0--公司好替换
			BEGIN
				SET @TmpSql = REPLACE(@TmpSql,'@DItem',@DItem)
			END
		IF CHARINDEX('@CompanyMCode',@TmpSql)>0--公司好替换
			BEGIN
				SET @TmpSql = REPLACE(@TmpSql,'@CompanyMCode',@CompanyMCode)
			END
		IF CHARINDEX('@yyyy()',@TmpSql)>0--年份
			BEGIN
				SET @TmpSql = REPLACE(@TmpSql,'@yyyy()',CAST(YEAR(GETDATE()) AS NVARCHAR))
			END
		IF CHARINDEX('@yy()',@TmpSql)>0--年份
			BEGIN
				SET @TmpSql = REPLACE(@TmpSql,'@yy()',SUBSTRING(CAST(YEAR(GETDATE()) AS NVARCHAR),3,2))
			END
		IF CHARINDEX('@mm()',@TmpSql)>0--月份
			BEGIN
				SET @TmpSql = REPLACE(@TmpSql,'@mm()',RIGHT('0000'+ CAST(MONTH(GETDATE()) AS NVARCHAR),2))
			END
		IF CHARINDEX('@dd()',@TmpSql)>0--天数
			BEGIN
				SET @TmpSql = REPLACE(@TmpSql,'@dd()',RIGHT('0000'+ CAST(DAY(GETDATE()) AS NVARCHAR),2))
			END
	END
ELSE
	BEGIN
		SET @TmpSql = @CodeRuleMask
		IF CHARINDEX('@GItem',@TmpSql)>0--集团号替换
			BEGIN
				SET @TmpSql = REPLACE(@TmpSql,'@GItem',''''+@GItem+'''')
			END
		IF CHARINDEX('@DItem',@CodeRuleMask)>0--公司好替换
			BEGIN
				SET @TmpSql = REPLACE(@TmpSql,'@DItem',''''+@DItem+'''')
			END
		IF CHARINDEX('@CompanyMCode',@CodeRuleMask)>0--公司好替换
			BEGIN
				SET @TmpSql = REPLACE(@TmpSql,'@CompanyMCode',''''+@CompanyMCode+'''')
			END
	END
PRINT @TmpSql	
DECLARE @TmpCodeValueTable TABLE(DocNum NVARCHAR(100))
INSERT INTO @TmpCodeValueTable EXEC(@TmpSql)

SELECT @DocNum = DocNum FROM @TmpCodeValueTable








