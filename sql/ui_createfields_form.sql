USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[UI_CreateFields_Form]    Script Date: 2018/5/24 7:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Michael，日期05年
作用：是自己人都知道
*/

ALTER  proc [dbo].[UI_CreateFields_Form]
@FormID int
As
DECLARE @DataID int
DECLARE @CursorDatas CURSOR

IF @FormID = -999
SET @CursorDatas = CURSOR
FOR SELECT ID FROM UI_Datas
Else
SET @CursorDatas = CURSOR
FOR SELECT ID FROM UI_Datas WHERE (FormsID = @FormID) And (DataTypeID not in (0,1,101,102))

OPEN @CursorDatas

WHILE (0=0)
BEGIN
FETCH NEXT FROM @CursorDatas Into @DataID
if (@@FETCH_STATUS<>0)break
Execute UI_CreateFields @DataID
END

CLOSE @CursorDatas
DEALLOCATE @CursorDatas
