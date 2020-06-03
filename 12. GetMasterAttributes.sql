/************************************************************************
Procedure Name	:	MDM.GetMasterAttributes
Objective		:	This procedure is used to get the master attribute data for entity, clients, contacts & addresses
Database		:	GlobalMasterAttributes
Author			:	Pragya Sanjana
Creation Date	:	15th May 2020
Modified By		:	Pragya Sanjana
Modified Date	:	27th May 2020
Execution Time	:	00.00
Input Parameters:	@applicableFor,@type,@isActive,@isDeleted,@isRTAAttribute
					,@isMandatory,@isFASLockDate,@attributeName,@attributeIDs

Algorithm and other details:
Test Run		:	Attached in Text File.
*************************************************************************/
CREATE PROCEDURE MDM.GetMasterAttributes
(
	@applicableFor		TINYINT						-- 0:ALL, 1: Entity, 2: Client, 3: Contact/Address
	,@type				VARCHAR(200)		=	NULL
	,@isActive			BIT
	,@isDeleted			BIT
	,@isRTAAttribute	BIT
	,@isMandatory		BIT
	,@isFASLockDate		BIT
	,@attributeName		MDM.UDTLongName		=	NULL   
	,@attributeIDs		VARCHAR(150)		=	NULL
)
AS
BEGIN
	SET NOCOUNT ON 
	SET XACT_ABORT ON

	BEGIN TRY
	
		--DECLARE VARIABLES
		DECLARE @masterAttributes TABLE
		(
			ApplicableFor					VARCHAR(60)
			,AttributeID					INTEGER
			,AttributeMasterID				INTEGER
			,MappingID						INTEGER
			,AttributeName					MDM.UDTLongName	
			,AttributeCode					MDM.UDTShortName
			,AttributeValue					MDM.UDTLongName
			,SubType						VARCHAR(120)
			,ControlType					INTEGER
			,IsRTAAttribute					VARCHAR(2)
			,IsValidateFASLockDate			VARCHAR(2)
			,IsMandatory					VARCHAR(2)
			,ApplicableStartDateChange		VARCHAR(2)
			,ApplicableEndDateChange		VARCHAR(2)
			,IsDefaultValue					TINYINT
			,IsPartOfDefaultSet				VARCHAR(2)
			,DisplayOrder					VARCHAR(2)
			,IsActive						BIT
			,IsDeleted						BIT
			,ReviewedBy						MDM.UDTModifiedBy
			,LastModifiedDate				DATETIME2		
			,LastModifiedByUser				MDM.UDTModifiedBy		
			,LastModifiedByMachine			MDM.UDTModifiedBy
		)	
		
		DECLARE @types TABLE
		(
			SubType	INTEGER	DEFAULT	NULL
		)  

		DECLARE @AttributeID TABLE
		(
			AttributeID	INTEGER	DEFAULT	NULL
		)  

		--Insert subtype values in temp table after splitting it from the string format. 
		IF(@type IS NOT NULL)
			BEGIN
				INSERT INTO @types(SubType)
				SELECT VALUE
				FROM  STRING_SPLIT(@type, ',')
			END
		--Insert null value in temp table when parameter @type is null. 
		ELSE
			INSERT INTO @types DEFAULT VALUES

		--Insert AttributeID values in temp table after splitting it from the string format. 
		IF(@attributeIDs IS NOT NULL)
			BEGIN
				INSERT INTO @AttributeID(AttributeID)
				SELECT VALUE
				FROM  STRING_SPLIT(@attributeIDs, ',')
			END
		--Insert null value in temp table when parameter @attributeIDs is null. 
		ELSE
			INSERT INTO @AttributeID DEFAULT VALUES

		BEGIN TRANSACTION

			--ResultSet for Entity Attribute Data
			IF (@applicableFor = 1 OR @applicableFor = 0)
			BEGIN
				INSERT INTO @masterAttributes(
												ApplicableFor				
												,AttributeID				
												,AttributeMasterID			
												,MappingID					
												,AttributeName				
												,AttributeCode				
												,AttributeValue				
												,SubType					
												,ControlType				
												,IsRTAAttribute				
												,IsValidateFASLockDate		
												,IsMandatory				
												,ApplicableStartDateChange	
												,ApplicableEndDateChange	
												,IsDefaultValue				
												,IsPartOfDefaultSet			
												,DisplayOrder				
												,IsActive					
												,IsDeleted					
												,ReviewedBy					
												,LastModifiedDate			
												,LastModifiedByUser			
												,LastModifiedByMachine	
											 )
										SELECT	'Entity'
												,EAMV.AttributeID
												,EAMV.AttributeMasterID
												,EAMV.MappingID
												,AttributeName
												,AttributeCode
												,AttributeValue
												,SI.Name
												,ControlType
												,IsRTAAttribute
												,IsValidateFASLockDate
												,IsMandatory
												,ApplicableStartDateChange
												,ApplicableEndDateChange
												,IsDefaultValue
												,IsPartOfDefaultSet
												,EAMV.DisplayOrder
												,IsActive
												,IsDeleted
												,ReviewedBy
												,EAMV.LastModifiedDate
												,EAMV.LastModifiedByUser
												,EAMV.LastModifiedByMachine
										FROM MDM.EntityAttributeMasterView EAMV
										INNER JOIN
											@types T
											ON EAMV.EntityType = ISNULL(T.SubType,EAMV.EntityType)
										INNER JOIN
											@AttributeID AI
											ON EAMV.AttributeID = ISNULL(AI.AttributeID,EAMV.AttributeID)
										INNER JOIN
											MDM.SystemInformation SI
											ON SI.Code = EAMV.EntityType
										WHERE	
										EAMV.AttributeName = ISNULL(@attributeName,EAMV.AttributeName)
										AND
										EAMV.IsActive = @isActive
										AND
										EAMV.IsDeleted = @isDeleted
										AND
										EAMV.IsRTAAttribute = @isRTAAttribute
										AND
										EAMV.IsMandatory = @isMandatory
										AND
										EAMV.IsValidateFASLockDate = @isFASLockDate
										AND 
										SI.Type = 'EntityType'
			END

			--Resultset for Client Attribute Data
			IF (@applicableFor = 2 OR @applicableFor = 0)
			BEGIN
				INSERT INTO @masterAttributes(	
												ApplicableFor				
												,AttributeID				
												,AttributeMasterID			
												,MappingID					
												,AttributeName				
												,AttributeCode				
												,AttributeValue				
												,SubType					
												,ControlType				
												,IsRTAAttribute				
												,IsValidateFASLockDate		
												,IsMandatory				
												,ApplicableStartDateChange	
												,ApplicableEndDateChange	
												,IsDefaultValue				
												,IsPartOfDefaultSet			
												,DisplayOrder				
												,IsActive					
												,IsDeleted					
												,ReviewedBy					
												,LastModifiedDate			
												,LastModifiedByUser			
												,LastModifiedByMachine	
											 )
										SELECT	'Client'
												,CAMV.AttributeID
												,AttributeMasterID
												,MappingID
												,AttributeName
												,AttributeCode
												,AttributeValue
												,SI.Name
												,ControlType
												,IsRTAAttribute
												,'NA'
												,IsMandatory
												,'NA'
												,'NA'
												,IsDefaultValue
												,IsPartOfDefaultSet
												,CAMV.DisplayOrder
												,IsActive
												,IsDeleted
												,ReviewedBy
												,CAMV.LastModifiedDate
												,CAMV.LastModifiedByUser
												,CAMV.LastModifiedByMachine
										FROM MDM.ClientAttributeMasterView CAMV
										INNER JOIN
											@AttributeID AI
											ON CAMV.AttributeID = ISNULL(AI.AttributeID,CAMV.AttributeID)
										INNER JOIN
											@types T
											ON CAMV.ClientType = ISNULL(T.SubType,CAMV.ClientType)
										INNER JOIN
											MDM.SystemInformation SI
											ON SI.Code = CAMV.ClientType
										WHERE	
										CAMV.AttributeName = ISNULL(@attributeName,CAMV.AttributeName)
										AND
										CAMV.IsActive = @isActive
									 	AND
										CAMV.IsDeleted = @isDeleted
										AND
										CAMV.IsMandatory = @isMandatory
										AND
										CAMV.IsRTAAttribute = @isRTAAttribute
										AND
										SI.Type = 'ClientType'
			END

			--Resultset for Contact Address Attribute Data
			IF (@applicableFor = 3 OR @applicableFor = 0)
			BEGIN
				INSERT INTO @masterAttributes(
												ApplicableFor				
												,AttributeID				
												,AttributeMasterID			
												,MappingID					
												,AttributeName				
												,AttributeCode				
												,AttributeValue				
												,SubType					
												,ControlType				
												,IsRTAAttribute				
												,IsValidateFASLockDate		
												,IsMandatory				
												,ApplicableStartDateChange	
												,ApplicableEndDateChange	
												,IsDefaultValue				
												,IsPartOfDefaultSet			
												,DisplayOrder				
												,IsActive					
												,IsDeleted					
												,ReviewedBy					
												,LastModifiedDate			
												,LastModifiedByUser			
												,LastModifiedByMachine	
											 )
										SELECT	'Fund Contact Address'
												,CAAMV.AttributeID
												,AttributeMasterID
												,AttributeMasterValueID
												,AttributeName
												,AttributeCode
												,AttributeValue
												,SI.Name
												,ControlType
												,'NA'
												,'NA'
												,IsMandatory
												,'NA'
												,'NA'
												,IsDefaultValue
												,'NA'
												,'NA'
												,IsActive
												,IsDeleted
												,ReviewedBy
												,CAAMV.LastModifiedDate
												,CAAMV.LastModifiedByUser
												,CAAMV.LastModifiedByMachine
										FROM MDM.ContactAddressAttributeMasterView CAAMV
										INNER JOIN
											@types T
											ON CAAMV.IsAddressType = ISNULL(T.SubType,CAAMV.IsAddressType)
										INNER JOIN
											@AttributeID AI
											ON CAAMV.AttributeID = ISNULL(AI.AttributeID,CAAMV.AttributeID)
										INNER JOIN
											MDM.SystemInformation SI
											ON SI.Code = CAAMV.IsAddressType
										WHERE	
										CAAMV.AttributeName = ISNULL(@attributeName,CAAMV.AttributeName)
										AND
										CAAMV.IsActive = @isActive
										AND
										CAAMV.IsDeleted = @isDeleted
										AND
										CAAMV.IsMandatory = @isMandatory
										AND
										SI.Code = 'ContactAddressType'
			END

			--ResultSet for MasterAttributes
			SELECT	ApplicableFor
					,AttributeID				
					,AttributeMasterID			
					,MappingID					
					,AttributeName				
					,AttributeCode				
					,AttributeValue				
					,SubType					
					,ControlType				
					,IsRTAAttribute				
					,IsValidateFASLockDate		
					,IsMandatory				
					,ApplicableStartDateChange	
					,ApplicableEndDateChange	
					,IsDefaultValue				
					,IsPartOfDefaultSet			
					,DisplayOrder				
					,IsActive					
					,IsDeleted					
					,ReviewedBy					
					,LastModifiedDate			
					,LastModifiedByUser			
					,LastModifiedByMachine	
			FROM @masterAttributes

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
