/************************************************************************
Procedure Name	:	MDM.GetMasterAttributes
Objective		:	This procedure is used to get the master attribute data for entity, clients, contacts & addresses
Database		:	GlobalMasterAttributes
Author			:	Pragya Sanjana
Creation Date	:	15th May 2020
Modified By		:
Modified Date	:
Execution Time	:	00.00
Input Parameters:	@applicationType, @entityTypes, @clienTypes, @attributeIDs, @

Algorithm and other details:
Test Run		:	Attached in Text File.
*************************************************************************/
CREATE PROCEDURE MDM.GetMasterAttributes
(
	@applicationType	TINYINT						-- 0:ALL, 1: Entity, 2: Client, 3: Contact/Address
	,@type				VARCHAR(50)			=	NULL
	,@isActive			BIT
	,@isDeleted			BIT
	,@attributeName		MDM.UDTLongName		=	NULL   
	,@attributeID		VARCHAR(150)		=	NULL
)
AS
BEGIN
	SET NOCOUNT ON 
	SET XACT_ABORT ON

	BEGIN TRY
	
		--DECLARE VARIABLES
		DECLARE @masterAttributes TABLE
		(
			ApplicationType				VARCHAR(60)
			,AttributeID				INTEGER
			,AttributeName				MDM.UDTLongName	
			,AttributeCode				MDM.UDTShortName
			,AttributeValue				MDM.UDTLongName
			,SubType					VARCHAR(120)
			,IsActive					BIT
			,IsDeleted					BIT
			,ReviewedBy					MDM.UDTModifiedBy
			,LastModifiedDate			DATETIME2		
			,LastModifiedByUser			MDM.UDTModifiedBy		
			,LastModifiedByMachine		MDM.UDTModifiedBy
		)	
		
		DECLARE @types TABLE
		(
			SubType	INTEGER	DEFAULT	NULL
		)  

		DECLARE @AttributeIDs TABLE
		(
			AttributeID	INTEGER	DEFAULT	NULL
		)  

		IF(@type IS NOT NULL)
			BEGIN
				INSERT INTO @types(SubType)
				SELECT VALUE
				FROM  STRING_SPLIT(@type, ',')
			END
		ELSE
			INSERT INTO @types DEFAULT VALUES

		IF(@attributeID IS NOT NULL)
			BEGIN
				INSERT INTO @AttributeIDs(AttributeID)
				SELECT VALUE
				FROM  STRING_SPLIT(@attributeID, ',')
			END
		ELSE
			INSERT INTO @AttributeIDs DEFAULT VALUES

		BEGIN TRANSACTION

			
			--ResultSet for Entity Attribute Data
			IF (@applicationType = 1 OR @applicationType = 0)
			BEGIN
				INSERT INTO @masterAttributes(
												ApplicationType
												,AttributeID				
												,AttributeName			
												,AttributeCode			
												,AttributeValue			
												,SubType				
												,IsActive				
												,IsDeleted				
												,ReviewedBy				
												,LastModifiedDate		
												,LastModifiedByUser		
												,LastModifiedByMachine	
											 )
										SELECT	'Entity'
												,EAMV.AttributeID
												,AttributeName
												,AttributeCode
												,AttributeValue
												,SI.Name
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
											@AttributeIDs AI
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
										SI.Type = 'EntityType'
			END

			--Resultset for Client Attribute Data
			IF (@applicationType = 2 OR @applicationType = 0)
			BEGIN
				INSERT INTO @masterAttributes(	
												ApplicationType
												,AttributeID				
												,AttributeName			
												,AttributeCode			
												,AttributeValue			
												,SubType				
												,IsActive				
												,IsDeleted				
												,ReviewedBy				
												,LastModifiedDate		
												,LastModifiedByUser		
												,LastModifiedByMachine	
											 )
										SELECT	'Client'
												,CAMV.AttributeID
												,AttributeName
												,AttributeCode
												,AttributeValue
												,SI.Name
												,IsActive
												,IsDeleted
												,ReviewedBy
												,CAMV.LastModifiedDate
												,CAMV.LastModifiedByUser
												,CAMV.LastModifiedByMachine
										FROM MDM.ClientAttributeMasterView CAMV
										INNER JOIN
											@types T
											ON CAMV.ClientType = ISNULL(T.SubType,CAMV.ClientType)
										INNER JOIN
											MDM.SystemInformation SI
											ON SI.Code = CAMV.ClientType 
										WHERE	
										CAMV.AttributeName = ISNULL(@attributeName,CAMV.AttributeName)
										AND
										CAMV.AttributeID = ISNULL(@attributeID,CAMV.AttributeID)
										AND
										CAMV.IsActive = @isActive
									 	AND
										CAMV.IsDeleted = @isDeleted
										AND 
										SI.Type = 'ClientType'
			END

			--Resultset for Contact Address Attribute Data
			IF (@applicationType = 3 OR @applicationType = 0)
			BEGIN
				INSERT INTO @masterAttributes(
												ApplicationType
												,AttributeID				
												,AttributeName			
												,AttributeCode			
												,AttributeValue			
												,SubType				
												,IsActive				
												,IsDeleted				
												,ReviewedBy				
												,LastModifiedDate		
												,LastModifiedByUser		
												,LastModifiedByMachine	
											 )
										SELECT	'Fund Contact Address'
												,CAAMV.AttributeID
												,AttributeName
												,AttributeCode
												,AttributeValue
												,SI.Code
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
											MDM.SystemInformation SI
											ON SI.Code = CAAMV.IsAddressType
										WHERE	
										CAAMV.AttributeName = ISNULL(@attributeName,CAAMV.AttributeName)
										AND
										CAAMV.AttributeID = ISNULL(@attributeID,CAAMV.AttributeID)
										AND
										CAAMV.IsActive = @isActive
										AND
										CAAMV.IsDeleted = @isDeleted
										AND
										SI.Type = 'ContactAddressType'
			END

			--ResultSet for MasterAttributes
			SELECT DISTINCT	ApplicationType
							,AttributeID
							,AttributeName			
							,AttributeCode			
							,AttributeValue			
							,SubType				
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
