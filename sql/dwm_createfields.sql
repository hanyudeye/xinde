USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[DWM_CreateFields]    Script Date: 2018/5/24 7:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER
 PROC [dbo].[DWM_CreateFields]
@DataID NVARCHAR(50),
@EMSCommonDataBaseName NVARCHAR(50)
AS
DECLARE @TmpDataString NVARCHAR(4000)
DECLARE @TmpFormID NVARCHAR(50)
DECLARE @TmpDataTypeID NVARCHAR(50)
DECLARE @TmpSql NVARCHAR(4000)
SET @TmpSql = 'SELECT @TmpDataString = DataString,@TmpFormID = FormID,@TmpDataTypeID = DataTypeID 
FROM '+@EMSCommonDataBaseName+'..UI_Datas WHERE ID = '''+@DataID+''''

EXEC SP_EXECUTESQL @TmpSql ,N'@TmpDataString NVARCHAR(4000) OUTPUT,@TmpFormID NVARCHAR(50) OUTPUT,@TmpDataTypeID NVARCHAR(50) OUTPUT',
@TmpDataString OUTPUT,@TmpFormID OUTPUT,@TmpDataTypeID OUTPUT
IF ISNULL(@TmpDataString,'')<>'' AND @TmpDataString<>'CopyData'
	BEGIN
		
	    IF EXISTS (SELECT TOP 1 name FROM sys.views WHERE name = '[dbo].Temp_CreateFieldView')
			BEGIN
				DROP VIEW Temp_CreateFieldView
			END
		SET @TmpSql = 'CREATE VIEW Temp_CreateFieldView AS '+@TmpDataString
		EXEC(@TmpSql)
		EXEC('INSERT INTO '+@EMSCommonDataBaseName+'..UI_Fields(ID,FormID,DataID, SN,VarName,DataField,lan1_Caption,lan3_Caption,Width,
		Enabled,Visible,AllowNull,AllowSort,GroupMode,VarLength,VarLenScale,VarType,IsMerge,AutoID)
		
		SELECT NEWID(),'''+@TmpFormID+''','''+ @DataID+''',c.colorder,
		  c.name,c.name,CONVERT(NVARCHAR(50),p.Value),CONVERT(NVARCHAR(50),p.Value),
		  200,1,1,c.isnullable,1,''None'',
		  c.prec,c.scale,t.name,0,0
		FROM syscolumns c INNER JOIN
			  systypes t ON c.xusertype = t.xusertype
				LEFT JOIN sys.extended_properties AS p
			 ON p.major_id = object_id(''Temp_CreateFieldView'')
			AND p.minor_id = c.colid 
			AND p.name = ''MS_Description''
		WHERE c.id = OBJECT_ID(''Temp_CreateFieldView'') And
		 c.name not in (Select DataField From '+@EMSCommonDataBaseName+'..UI_Fields Where DataID = '''+@DataID+''')') 
		 
		EXEC('UPDATE '+@EMSCommonDataBaseName+'..UI_Fields SET lan1_Caption = VarName WHERE ISNULL(lan1_Caption,'''')=''''')
		EXEC('UPDATE '+@EMSCommonDataBaseName+'..UI_Fields SET ControlType=''1'' WHERE DataID='''+@DataID+'''')
		EXEC('UPDATE '+@EMSCommonDataBaseName+'..UI_Fields SET ControlType = ''2'' WHERE (VarType = ''bit'') AND (DataID = '''+@DataID+''')')
		EXEC('UPDATE '+@EMSCommonDataBaseName+'..UI_Fields SET ControlType = ''3'' WHERE VarType IN (''datetime'', ''smalldatetime'') AND DataID = '''+@DataID+'''')

		IF @TmpDataTypeID='11'
			BEGIN
				EXEC('UPDATE '+@EMSCommonDataBaseName+'..UI_Fields SET Width=80 WHERE DataID='''+@DataID+'''')
			END
		DROP VIEW Temp_CreateFieldView

		SELECT '1' AS CheckResult,'生成成功' AS CheckMsg
		
		
	END


