/************************************************************************
View Name		:	MDM.ContactAddressAttributeMasterView 
Objective		:	This view is used to display the detailed information of Fund Contact Address Attributes.
Database		:	GlobalMasterAttributes
Author			:	Pragya Sanjana
Creation Date	:	12th May 2020
Modified By		:	
Modified Date	:	
Execution Time	:	00.00

Algorithm and other details:
Test Run		:	Select * from MDM.ContactAddressAttributeMasterView 
*************************************************************************/
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
