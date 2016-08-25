sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'clr enabled', 1;
GO
RECONFIGURE;
GO

ALTER DATABASE AddressDB SET TRUSTWORTHY ON
GO


IF EXISTS ( SELECT 1
   FROM  sys.assemblies asms
   WHERE asms.name = N'ClrLibrary' )
BEGIN
	DROP FUNCTION GetValidatedAddress
	DROP ASSEMBLY ClrLibrary
END

GO

Create Assembly ClrLibrary
FROM
'<full path to file ClrLibrary.dll>'
WITH PERMISSION_SET = UNSAFE
GO

CREATE FUNCTION	dbo.GetValidatedAddress(@FirmName NVARCHAR(max), @Address1 NVARCHAR(max), @Address2 NVARCHAR(max), @City NVARCHAR(max),@State NVARCHAR(max), @Zip5 NVARCHAR(max), @Zip4 NVARCHAR(max))
returns xml --NVARCHAR(max)
	WITH EXECUTE AS CALLER
AS EXTERNAL NAME ClrLibrary.[ClrLibrary.UserDefinedFunctions].GetValidatedAddress;
GO


