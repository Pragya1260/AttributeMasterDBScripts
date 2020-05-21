/************************************************************************
Procedure Name	:	MDM.SetMasterAttributes
Objective		:	This procedure is used to save the master Attribute data for entity, clients, contacts & addresses
Database		:	GlobalMasterAttributes
Author			:	Pragya Sanjana
Creation Date	:	14th May 2020
Modified By		:
Modified Date	:
Execution Time	:	00.00
Input Parameters:	@applicationType, @machineName, @loginUser, @jsonStringForEntityAttributes, @jsonStringForClientAttributes,
					@jsonStringForContactAddressAttributes

Algorithm and other details:
Test Run		:	"E:\NAVMDM\AttributeMaster\Docs\Execution Report - Insert (EntityAttributes).txt"
					"E:\NAVMDM\AttributeMaster\Docs\Execution Report - Update(EntityAttributes).txt"
*************************************************************************/
CREATE PROCEDURE MDM.SetMasterAttributes
(
	@machineName							VARCHAR(60)
	,@loginUser								VARCHAR(60)
	,@jsonStringForMasterAttributes			NVARCHAR(MAX)
)

AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRY

		--DECLARE VARIABLES   
		DECLARE @ApplicableFor TABLE
		(
			ApplicableFor TINYINT
		)

		INSERT INTO @ApplicableFor(ApplicableFor)
		SELECT ApplicableFor FROM OPENJSON(@jsonStringForMasterAttributes, '$.AttributeMaster')
		WITH (ApplicableFor	TINYINT)

		INSERT INTO @ApplicableFor(ApplicableFor)
		SELECT ApplicableFor FROM OPENJSON(@jsonStringForMasterAttributes, '$.AttributeMasterMapping')
		WITH (ApplicableFor	TINYINT)

		BEGIN TRANSACTION

			IF EXISTS(Select ApplicableFor  from @ApplicableFor WHERE ApplicableFor = 1)
			BEGIN
				EXEC MDM.SetMasterEntityAttribute	@machineName = @machineName, @loginUser = @loginUser
													,@jsonStringForEntityAttributes = @jsonStringForMasterAttributes
			END				

			IF EXISTS(Select ApplicableFor  from @ApplicableFor WHERE ApplicableFor = 2)
			BEGIN
				 EXEC MDM.SetMasterClientAttribute	@machineName = @machineName, @loginUser = @loginUser
													,@jsonStringForClientAttributes = @jsonStringForMasterAttributes
			END

			IF EXISTS(Select ApplicableFor  from @ApplicableFor WHERE ApplicableFor = 3)
			BEGIN
				EXEC MDM.SetMasterContactAddressAttribute	@machineName = @machineName, @loginUser = @loginUser
															,@jsonStringForContactAddressAttributes = @jsonStringForMasterAttributes
			END

		COMMIT TRANSACTION
		RETURN 0
	
	END TRY
	BEGIN CATCH
		IF(XACT_STATE() != 0 OR @@TRANCOUNT > 0)
		ROLLBACK TRANSACTION
		--EXEC MDM.RethrowError
		RETURN -1
	END CATCH
END


