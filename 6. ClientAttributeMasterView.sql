/************************************************************************
View Name		:	MDM.ClientAttributeMasterView
Objective		:	This view is used to display the detailed information of Client Attributes.
Database		:	GlobalMasterAttributes
Author			:	Pragya Sanjana
Creation Date	:	12th May 2020
Modified By		:	
Modified Date	:	
Execution Time	:	00.00

Algorithm and other details:
Test Run		:	Select * from MDM.ClientAttributeMasterView 
*************************************************************************/
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
