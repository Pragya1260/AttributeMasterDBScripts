USE GlobalMasterAttributes ;
GO

CREATE VIEW MDM.EntityAttributeMasterView 
AS
	SELECT 
			EAMM.MappingID
			,EAM.AttributeMasterID																			
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
			,DisplayOrder
			,IsMandatory
			,IsValidateFASLockDate
			,ReviewedBy
			,VersionNumber
			,LastModifiedDate
			,LastModifiedByUser
			,LastModifiedByMachine
	 FROM MDM.EntityAttributesMaster EAM
	 INNER JOIN 
	 MDM.EntityAttributesMasterMapping EAMM
	 ON EAM.AttributeMasterID = EAMM.AttributeMasterID
