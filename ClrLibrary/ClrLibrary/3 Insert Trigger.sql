CREATE TRIGGER [dbo].[TR_Addresses_InsteadOfInsert] ON [dbo].[Addresses]
--AFTER INSERT	as
INSTEAD OF INSERT AS
BEGIN

	DECLARE	@Address1 VARCHAR(MAX), @Address2 VARCHAR(MAX), @City VARCHAR(MAX), @StateProvince VARCHAR(MAX), @Zip VARCHAR(MAX), @Country VARCHAR(MAX)

	DECLARE c Cursor for
	SELECT i.Address1, i.Address2, i.City, i.StateProvince, i.Zip, i.Country
	FROM INSERTED i

	OPEN c

	FETCH NEXT
	FROM c
	INTO @Address1, @Address2, @City, @StateProvince, @Zip, @Country

	WHILE @@FETCH_STATUS = 0
	BEGIN

		DECLARE @usps xml = dbo.GetValidatedAddress('', '', @Address1, /* @Address2, */ @City, @StateProvince, @Zip, '')

	--@usp
		INSERT INTO dbo.[Addresses]
		(
			Address1,
			Address2,
			City,
			StateProvince,
			Zip,
			Country
		)
		VALUES
		(
			cast(@usps.query('/AddressValidateResponse/Address/Address2/text()') AS VARCHAR(MAX)),
			@Address2,
			cast(@usps.query('/AddressValidateResponse/Address/City/text()') AS VARCHAR(MAX)),
			cast(@usps.query('/AddressValidateResponse/Address/State/text()') AS VARCHAR(MAX)),
			cast(@usps.query('/AddressValidateResponse/Address/Zip5/text()') AS VARCHAR(MAX))
				+ '-' + cast(@usps.query('/AddressValidateResponse/Address/Zip4/text()') AS VARCHAR(MAX)),
			@Country
		)

		FETCH NEXT
		FROM c
		INTO @Address1, @Address2, @City, @StateProvince, @Zip, @Country

	END

	CLOSE c
	DEALLOCATE c

END



