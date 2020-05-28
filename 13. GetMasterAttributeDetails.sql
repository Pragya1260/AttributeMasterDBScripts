/************************************************************************
Procedure Name	:	MDM.GetMasterAttributeDetails
Objective		:	This procedure is used to get the detail master attribute data for entity, clients, contacts or addresses based on attributeID.
Database		:	GlobalMasterAttributes
Author			:	Pragya Sanjana
Creation Date	:	15th May 2020
Modified By		:	Pragya Sanjana	
Modified Date	:	27th May 2020
Execution Time	:	00.00
Input Parameters:	@applicationType,@attributeID

Algorithm and other details:
Test Run		:	Attached in the text file.
*************************************************************************/
CREATE PROCEDURE MDM.GetMasterAttributeDetails
(
	@applicationType	TINYINT			-- 1: Entity, 2: Client, 3: Contact/Address
	,@attributeID		INTEGER 
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRY

		BEGIN TRANSACTION
			   IF(@applicationType = 1)
			   BEGIN
					SELECT	'Entity' AS 'ApplicationType'
							,MappingID
							,AttributeMasterID
							,AttributeID
							,AttributeName
							,AttributeCode
							,AttributeValue
							,EntityType
							,IsActive
							,IsDeleted
							,IsRTAAttribute
							,ControlType
							,IsDefaultValue
							,IsPartOfDefaultSet
							,EAMV.DisplayOrder
							,IsMandatory
							,IsValidateFASLockDate
							,ReviewedBy
							,EAMV.VersionNumber
							,EAMV.LastModifiedDate
							,EAMV.LastModifiedByUser
							,EAMV.LastModifiedByMachine
					FROM MDM.EntityAttributeMasterView EAMV
					WHERE 
						EAMV.AttributeID = @attributeID
			   END

			   IF(@applicationType = 2)
			   BEGIN
					SELECT	'Client' AS 'ApplicationType'
							,MappingID
							,AttributeMasterID
							,AttributeID
							,AttributeName
							,AttributeCode
							,AttributeValue
							,ClientType
							,IsActive
							,IsDeleted
							,IsRTAAttribute
							,ControlType
							,IsDefaultValue
							,IsPartOfDefaultSet
							,CAMV.DisplayOrder
							,IsMandatory
							,ReviewedBy
							,CAMV.VersionNumber
							,CAMV.LastModifiedDate
							,CAMV.LastModifiedByUser
							,CAMV.LastModifiedByMachine
					FROM MDM.ClientAttributeMasterView CAMV
					WHERE 
						CAMV.AttributeID = @attributeID
			   END

			   IF(@applicationType = 3)
			   BEGIN
					SELECT	'Fund Contact Address' AS 'ApplicationType'
							,AttributeMasterID
							,AttributeMasterValueID
							,AttributeID
							,AttributeName
							,AttributeCode
							,AttributeValue
							,IsActive
							,IsDeleted
							,ControlType
							,IsMandatory
							,IsAddressType
							,IsDefaultValue
							,ReviewedBy
							,CAAMV.VersionNumber
							,CAAMV.LastModifiedDate
							,CAAMV.LastModifiedByUser
							,CAAMV.LastModifiedByMachine
					FROM MDM.ContactAddressAttributeMasterView CAAMV
					WHERE 
						CAAMV.AttributeID = @attributeID
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
