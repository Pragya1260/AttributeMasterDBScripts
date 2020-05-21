USE GlobalMasterAttributes ;
GO

CREATE VIEW MDM.ClientAttributeMasterView 
AS
	SELECT 
		CAMM.MappingID
		,EAM.AttributeMasterID
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
		,DisplayOrder
		,IsMandatory
		,ReviewedBy
		,VersionNumber
		,LastModifiedDate
		,LastModifiedByUser
		,LastModifiedByMachine
	 FROM MDM.EntityAttributesMaster EAM
	 INNER JOIN 
	 MDM.ClientAttributeMasterMapping CAMM
	 ON EAM.AttributeMasterID = CAMM.AttributeMasterID
