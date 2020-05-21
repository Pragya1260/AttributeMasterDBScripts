USE GlobalMasterAttributes ;
GO

CREATE VIEW MDM.ContactAddressAttributeMasterView 
AS
	SELECT 
			CAM.AttributeMasterID
			,CAMV.AttributeMasterValueID
			,CAM.AttributeID
			,AttributeName
			,AttributeCode
			,AttributeValue
			,CAM.IsActive
			,IsDeleted
			,ControlType
			,IsMandatory
			,IsAddressType
			,IsDefaultValue
			,ReviewedBy
			,VersionNumber
			,LastModifiedDate
			,LastModifiedByUser
			,LastModifiedByMachine
	 FROM MDM.ContactAttributeMaster CAM
	 INNER JOIN 
	 MDM.ContactAttributeMasterValues CAMV
	 ON CAM.AttributeID = CAMV.AttributeID
