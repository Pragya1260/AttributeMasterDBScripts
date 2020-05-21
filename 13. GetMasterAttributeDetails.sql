/************************************************************************
Procedure Name	:	MDM.GetMasterAttributeDetails
Objective		:	This procedure is used to get the detail master attribute data for entity, clients, contacts or addresses based on attributeID.
Database		:	GlobalMasterAttributes
Author			:	Pragya Sanjana
Creation Date	:	15th May 2020
Modified By		:
Modified Date	:
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
							,SI.Name
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
					INNER JOIN
						MDM.SystemInformation SI
						ON SI.Code = EAMV.EntityType
					WHERE 
						EAMV.AttributeID = @attributeID
						AND
						SI.Type = 'EntityType'
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
							,SI.Name
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
					INNER JOIN
						MDM.SystemInformation SI
						ON SI.Code = CAMV.ClientType
					WHERE 
						CAMV.AttributeID = @attributeID
						AND
						SI.Type = 'ClientType'
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
							,SI.Name
							,IsDefaultValue
							,ReviewedBy
							,CAAMV.VersionNumber
							,CAAMV.LastModifiedDate
							,CAAMV.LastModifiedByUser
							,CAAMV.LastModifiedByMachine
					FROM MDM.ContactAddressAttributeMasterView CAAMV
					INNER JOIN
						MDM.SystemInformation SI
						ON SI.Code = CAAMV.IsAddressType
					WHERE 
						CAAMV.AttributeID = @attributeID
						AND
						SI.Type = 'ContactAddressType'
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
