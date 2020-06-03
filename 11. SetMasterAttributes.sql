/************************************************************************
Procedure Name	:	MDM.SetMasterAttributes
Objective		:	This procedure is used to save the master Attribute data for entity, clients, contacts & addresses
Database		:	GlobalMasterAttributes
Author			:	Pragya Sanjana
Creation Date	:	14th May 2020
Modified By		:
Modified Date	:
Execution Time	:	00.00
Input Parameters:	@applicableFor, @machineName, @loginUser,
					@jsonStringForMasterAttributes

Algorithm and other details:
Test Run		:	Attached in text file
*************************************************************************/
CREATE PROCEDURE MDM.SetMasterAttributes
(
	@machineName							VARCHAR(60)
	,@loginUser								VARCHAR(60)
	,@jsonStringForMasterAttributes			NVARCHAR(MAX)
	,@applicableFor							TINYINT
)

AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRY

			IF (@applicableFor = 1)
			BEGIN
				EXEC MDM.SetMasterEntityAttribute	@machineName = @machineName, @loginUser = @loginUser
													,@jsonStringForEntityAttributes = @jsonStringForMasterAttributes
			END				

			IF (@applicableFor = 2)
			BEGIN
				 EXEC MDM.SetMasterClientAttribute	@machineName = @machineName, @loginUser = @loginUser
													,@jsonStringForClientAttributes = @jsonStringForMasterAttributes
			END

			IF (@applicableFor = 3)
			BEGIN
				EXEC MDM.SetMasterContactAddressAttribute	@machineName = @machineName, @loginUser = @loginUser
															,@jsonStringForContactAddressAttributes = @jsonStringForMasterAttributes
			END

	END TRY
	BEGIN CATCH
		IF(XACT_STATE() != 0 OR @@TRANCOUNT > 0)
		ROLLBACK TRANSACTION
		--EXEC MDM.RethrowError
		RETURN -1
	END CATCH
END


