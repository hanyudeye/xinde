USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[BO_CreateFields]    Script Date: 2018/5/24 7:21:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--@ObjectID传入-999则刷新有的
ALTER    proc [dbo].[BO_CreateFields]
@Object int
As
DECLARE @ObjectID int
DECLARE @CursorDatas CURSOR

IF @Object = -999
SET @CursorDatas = CURSOR
FOR SELECT ID FROM BO_Objects Where (isnull(ObjectTypeID,0) <> 1)
Else
SET @CursorDatas = CURSOR
FOR SELECT ID FROM BO_Objects WHERE (ID = @Object) And (isnull(ObjectTypeID,0) <> 1)

OPEN @CursorDatas

WHILE (0=0)
BEGIN
  FETCH NEXT FROM @CursorDatas Into @ObjectID
  if (@@FETCH_STATUS<>0)break
  
  Update BO_ObjectFields
  Set SN = c.colid, VarType = t.name, VarLength = c.prec, 
      Caption = isnull(cast(p.[value] as varchar),c.name), 
      AllowNull = c.isnullable, 
      AutoID = case when c.status=0x80 then 1 else 0 end
  FROM syscolumns c INNER JOIN
      systypes t ON c.xusertype = t.xusertype LEFT OUTER JOIN
      sysproperties p ON c.id = p.id AND c.colid = p.smallid INNER JOIN
      BO_ObjectFields ON c.name = BO_ObjectFields.VarName 
  WHERE (c.id = OBJECT_ID
          ((SELECT LinkTable
          FROM BO_Objects
          WHERE (ID = @ObjectID)))) And
                (c.name in (Select VarName From BO_ObjectFields Where ObjectID = @ObjectID)) And
                (BO_ObjectFields.ObjectID = @ObjectID)

  INSERT INTO BO_ObjectFields
      (ObjectID, VarName, SN, VarType, VarLength, Caption, AllowNull, AutoID)
  SELECT @ObjectID As ObjectID, c.name, c.colid, t.name AS Vartype, c.prec, 
      isnull(cast(p.[value] as varchar),c.name), c.isnullable,
      case when c.status=0x80 then 1 else 0 end AutoID
  FROM syscolumns c INNER JOIN
      systypes t ON c.xusertype = t.xusertype LEFT OUTER JOIN
      sysproperties p ON c.id = p.id AND c.colid = p.smallid
  WHERE (c.id = OBJECT_ID
          ((SELECT LinkTable
          FROM BO_Objects
          WHERE (ID = @ObjectID)))) And
  (c.name not in (Select VarName From BO_ObjectFields Where ObjectID = @ObjectID))

  UPDATE BO_ObjectFields
  SET LinkObjID = BO_Objects.ID
  FROM (SELECT syscolumns.name AS FieldName, OBJECT_NAME(sysreferences.rkeyid) 
              AS LinkTable
        FROM sysreferences INNER JOIN
              syscolumns ON sysreferences.fkeyid = syscolumns.id AND 
              sysreferences.fkey1 = syscolumns.colid
        WHERE (sysreferences.fkeyid = OBJECT_ID
                  ((SELECT LinkTable
                  FROM BO_Objects
                  WHERE (ID = @ObjectID)))) AND (sysreferences.rkeyindid = sysreferences.keycnt)) 
      F1 INNER JOIN
      BO_Objects ON F1.LinkTable = BO_Objects.LinkTable INNER JOIN
      BO_ObjectFields ON 
      F1.FieldName COLLATE Chinese_PRC_CI_AS = BO_ObjectFields.VarName
  WHERE (BO_ObjectFields.ObjectID = @ObjectID)    
END

CLOSE @CursorDatas
DEALLOCATE @CursorDatas
