USE [HLEMSBusiness]
GO
/****** Object:  StoredProcedure [dbo].[WX_Insert]    Script Date: 2018/5/24 7:32:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[WX_Insert]
as

insert openquery([192.168.1.21],  'SELECT content,ISDEPT,ISALLUSER,MSGTYPE,TOUSER,TOPARTY,ISSEND,agentid,erpid,title,url  FROM hlnpmphp.hlnpm_postmsg') 

select  MSG,ISDEPT,ISALLUSER,MSGTYPE,TOUSER,TOPARTY,ISSEND,agentid,id,title,url
from wx_message
where tbstatus=0


update wx_message
set tbstatus=1
where tbstatus=0
