USE GlobalMasterAttributes;
Go

-- Table : MDM.EntityAttributesMaster
CREATE TABLE MDM.EntityAttributesMaster
(
	AttributeMasterID			INTEGER				NOT NULL	IDENTITY(1,1)	PRIMARY KEY
	,AttributeID				INTEGER				NOT NULL
	,AttributeName				MDM.UDTLongName		NOT NULL	
	,AttributeCode				MDM.UDTShortName
	,AttributeValue				MDM.UDTLongName
	,IsActive					TINYINT				NOT NULL
	,IsDeleted					TINYINT				NOT NULL
	,IsRTAAttribute				TINYINT				NOT NULL
	,ControlType				INTEGER
	,ReviewedBy					VARCHAR(60)			NOT NULL
	,VersionNumber				TIMESTAMP			NOT NULL
	,LastModifiedDate			DATETIME2			NOT NULL
	,LastModifiedByUser			MDM.UDTModifiedBy	NOT NULL
	,LastModifiedByMachine		MDM.UDTModifiedBy	NOT NULL
	,CONSTRAINT UC_EntityAttributesMaster UNIQUE (AttributeName,AttributeCode,AttributeValue)
)

-- Table : MDM.EntityAttributesMasterMapping
CREATE TABLE MDM.EntityAttributesMasterMapping
(
	MappingID					INTEGER				NOT NULL	IDENTITY(1,1)	PRIMARY KEY
	,AttributeMasterID			INTEGER				NOT NULL	
	,EntityType					INTEGER				NOT NULL
	,IsDefaultValue				TINYINT				NOT NULL
	,IsPartOfDefaultSet			TINYINT				
	,DisplayOrder				TINYINT				
	,IsMandatory				TINYINT			    
	,IsValidateFASLockDate		BIT					NOT NULL
	,CONSTRAINT UC_EntityAttributesMasterMapping UNIQUE (AttributeMasterID,EntityType)
)

-- Table : MDM.ClientAttributeMasterMapping
CREATE TABLE MDM.ClientAttributeMasterMapping
(
	MappingID					INTEGER				NOT NULL	IDENTITY(1,1)	PRIMARY KEY
	,AttributeMasterID			INTEGER				NOT NULL
	,ClientType					TINYINT				NOT NULL
	,IsDefaultValue				BIT					NOT NULL
	,IsPartOfDefaultSet			BIT					NOT NULL
	,DisplayOrder				TINYINT				NOT NULL
	,IsMandatory				BIT					NOT NULL
	,CONSTRAINT UC_ClientAttributeMasterMapping UNIQUE (AttributeMasterID,ClientType)
)

-- Table : MDM.ContactAttributeMaster
CREATE TABLE MDM.ContactAttributeMaster
(
	AttributeMasterID			INTEGER				NOT NULL	IDENTITY(1,1)	PRIMARY KEY	
	,AttributeID				INTEGER				NOT NULL
	,AttributeName				MDM.UDTLongName		NOT NULL
	,IsActive					TINYINT				NOT NULL
	,IsDeleted					TINYINT				NOT NULL
	,ControlType				INTEGER				
	,IsMandatory				TINYINT				
	,IsAddressType				TINYINT				NOT NULL
	,ReviewedBy					MDM.UDTModifiedBy	NOT NULL
	,VersionNumber				TIMESTAMP			NOT NULL
	,LastModifiedDate			DATETIME2			NOT NULL
	,LastModifiedByUser			MDM.UDTModifiedBy	NOT NULL
	,LastModifiedByMachine		MDM.UDTModifiedBy	NOT NULL
	,CONSTRAINT UC_ContactAttributeMaster UNIQUE (AttributeID,AttributeName)
)

-- Table : MDM.ContactAttributeMasterValues
CREATE TABLE MDM.ContactAttributeMasterValues
(
	AttributeMasterValueID		INTEGER				NOT NULL	IDENTITY(1,1) PRIMARY KEY 
	,AttributeID				INTEGER				NOT NULL
	,AttributeCode				MDM.UDTShortName
	,AttributeValue				MDM.UDTLongName
	,IsDefaultValue				TINYINT				NOT NULL
	,IsActive					TINYINT				NOT NULL
	,CONSTRAINT UC_ContactAttributeMasterValues UNIQUE (AttributeID,AttributeCode,AttributeValue)
)

-- Table : MDM.SystemInformation
CREATE TABLE MDM.SystemInformation
(
	SystemInformationID			INTEGER			IDENTITY(1,1)		NOT NULL
	,Type						VARCHAR(30)							NOT NULL
	,Code						VARCHAR(30)							NOT NULL
	,Name						VARCHAR(120)						NOT NULL
	,Value						NVARCHAR(360)						NULL
	,RefID						INTEGER								NOT NULL
	,DisplayOrder				TINYINT								NOT NULL
	,ValidFrom					DATE								NOT NULL
	,ValidTo					DATE								NOT NULL
	,Status						TINYINT								NOT NULL
	,IsDefaultSet				TINYINT								NOT NULL
	,VersionNumber				ROWVERSION							NOT NULL
	,LastModifiedDate			DATETIME2(7)						NOT NULL
	,LastModifiedByUser			VARCHAR(60)							NOT NULL
	,LastModifiedByMachine		VARCHAR(60)							NOT NULL
	CONSTRAINT [PK_SystemInformation_SystemInformationID] PRIMARY KEY CLUSTERED (SystemInformationID ASC)
)

CREATE NONCLUSTERED INDEX idx_SystemInformation_VersionNumber
ON MDM.SystemInformation (VersionNumber DESC)

CREATE NONCLUSTERED INDEX idx_SystemInformation_TypeValidFromValidToCode
ON MDM.SystemInformation (Type ASC, ValidFrom ASC, ValidTo ASC, Code ASC, Value ASC)

CREATE NONCLUSTERED INDEX idx_SystemInformation_TypeCode
ON MDM.SystemInformation (Type ASC, Code ASC)
INCLUDE(Name)

