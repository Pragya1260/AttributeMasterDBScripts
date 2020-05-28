/************************************************************************
View Name		:	MDM.EntityAttributeMasterView
Objective		:	This view is used to display the detailed information of Entity Attributes.
Database		:	GlobalMasterAttributes
Author			:	Pragya Sanjana
Creation Date	:	12th May 2020
Modified By		:	
Modified Date	:	
Execution Time	:	00.00

Algorithm and other details:
Test Run		:	Select * from MDM.EntityAttributeMasterView 
*************************************************************************/
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
			,ApplicableStartDateChange
			,ApplicableEndDateChange
			,ReviewedBy
			,VersionNumber
			,LastModifiedDate
			,LastModifiedByUser
			,LastModifiedByMachine
	 FROM MDM.EntityAttributesMaster EAM
	 INNER JOIN 
	 MDM.EntityAttributesMasterMapping EAMM
	 ON EAM.AttributeMasterID = EAMM.AttributeMasterID
