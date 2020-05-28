/************************************************************************
Procedure Name	:	MDM.SetMasterContactAddressAttribute
Objective		:	This procedure is used to save the master data for Contact/Address Attribute
Database		:	GlobalMasterAttributes
Author			:	Pragya Sanjana
Creation Date	:	13th May 2020
Modified By		:
Modified Date	:
Execution Time	:	00.00
Input Parameters:	@jsonStringForContactAddressAttributes, @machineName, @loginUser

Algorithm and other details:
Test Run		:	Attached in the text file
*************************************************************************/
CREATE PROCEDURE MDM.SetMasterContactAddressAttribute
(
	@jsonStringForContactAddressAttributes		NVARCHAR(MAX)
	,@machineName								NVARCHAR(60)
	,@loginUser									NVARCHAR(60)
)

AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRY

		--DECLARE VARIABLES
		DECLARE @lastModifiedDate	DATETIME2
		DECLARE @AttributeID INTEGER

		DECLARE @ContactAddressAttributeMaster TABLE
		(
			AttributeMasterValueID		INTEGER				NOT NULL
			,AttributeID				INTEGER				NOT NULL
			,AttributeName				MDM.UDTLongName		NOT NULL	
			,AttributeCode				MDM.UDTShortName
			,AttributeValue				MDM.UDTLongName
			,IsActive					TINYINT				NOT NULL
			,IsDeleted					TINYINT				NOT NULL
			,ControlType				INTEGER
			,ApplicableFor				TINYINT				NOT NULL
			,Action						CHAR(1)				NOT NULL
		)

		DECLARE @ContactAttributeMasterValues TABLE
		(
			AttributeMasterID		INTEGER				NOT NULL
			,AttributeID				INTEGER				NOT NULL	
			,SubType					INTEGER				NOT NULL
			,IsDefaultValue				TINYINT				NOT NULL
			,IsMandatory				TINYINT			    
			,ApplicableFor				TINYINT				NOT NULL
			,Action						CHAR(1)				NOT NULL
		)

		DECLARE @resultset TABLE
		(
			AttributeID INTEGER
		)

		--Update last modified date
		SET @lastModifiedDate = GETDATE()

		--READ DATA FROM JSON AND INSERT IT INTO TEMP TABLE
		IF (@jsonStringForContactAddressAttributes IS NOT NULL)
		BEGIN
			INSERT INTO @ContactAddressAttributeMaster(	
														AttributeMasterValueID	
														,AttributeID		
														,AttributeName		
														,AttributeCode		
														,AttributeValue		
														,IsActive			
														,IsDeleted			
														,ControlType		
														,ApplicableFor		
														,Action				
														)
												SELECT	AttributeMasterID	
														,AttributeID		
														,AttributeName		
														,AttributeCode		
														,AttributeValue		
														,IsActive			
														,IsDeleted			
														,ControlType		
														,ApplicableFor		
														,Action				
										FROM	OPENJSON(@jsonStringForContactAddressAttributes, '$.AttributeMaster')   
										WITH  (	
												AttributeMasterID			INTEGER			
												,AttributeID				INTEGER			
												,AttributeName				MDM.UDTLongName	
												,AttributeCode				MDM.UDTShortName
												,AttributeValue				MDM.UDTLongName
												,IsActive					TINYINT			
												,IsDeleted					TINYINT			
												,ControlType				INTEGER
												,ApplicableFor				TINYINT			
												,Action						CHAR(1)
											  )

			INSERT INTO @ContactAttributeMasterValues(
														AttributeMasterID	
														,AttributeID			
														,SubType				
														,IsDefaultValue			
														,IsMandatory			
														,ApplicableFor			
														,Action	
													 )
												SELECT	MappingID	
														,AttributeID			
														,SubType				
														,IsDefaultValue			
														,IsMandatory			
														,ApplicableFor			
														,Action		
												FROM OPENJSON(@jsonStringForContactAddressAttributes, '$.AttributeMasterMapping')
												WITH(
														MappingID					INTEGER	
														,AttributeID				INTEGER	
														,SubType					INTEGER	
														,IsDefaultValue				TINYINT	
														,IsMandatory				TINYINT	
														,ApplicableFor				TINYINT	
														,Action						CHAR(1)	
													)
		END

		
		--Set AttributeID for new Attribute
		SELECT	@AttributeID = NEXT VALUE FOR MDM.ContactAddressAttributeID
		UPDATE A
			SET A.AttributeID = @AttributeID
		FROM @ContactAddressAttributeMaster A
		WHERE Action = 'I'
		AND	A.AttributeID = 0

		UPDATE A
			SET A.AttributeID = @AttributeID
		FROM @ContactAttributeMasterValues A
		WHERE Action = 'I'
		AND	A.AttributeID = 0

		BEGIN TRANSACTION
			
			--Update Data into MDM.ContactAttributeMaster table when action is 'U'
			UPDATE A
				SET		A.AttributeName				=		B.AttributeName			
						,A.IsActive					=		B.IsActive				
						,A.IsDeleted				=		B.IsDeleted				
						,A.ControlType				=		B.ControlType			
						,A.IsMandatory				=		C.IsMandatory			
						,A.IsAddressType			=		C.SubType			
						,A.ReviewedBy				=		@loginUser			
						,A.LastModifiedDate			=		@lastModifiedDate		
						,A.LastModifiedByUser		=		@loginUser		
						,A.LastModifiedByMachine	=		@machineName
			FROM MDM.ContactAttributeMaster A
			INNER JOIN @ContactAddressAttributeMaster B
				ON A.AttributeID = B.AttributeID
			INNER JOIN	@ContactAttributeMasterValues C
				ON B.AttributeID = C.AttributeID
			WHERE 
				B.Action = 'U'
				AND
				C.Action = 'U'
				AND
				B.ApplicableFor = 3
				AND
				C.ApplicableFor = 3

			--Update Data into MDM.ContactAttributeMasterValues table when action is 'U'
			UPDATE A
				SET		A.AttributeCode				=		B.AttributeCode	
						,A.AttributeValue			=		B.AttributeValue	
						,A.IsDefaultValue			=		C.IsDefaultValue	
						,A.IsActive					=		B.IsActive		
			FROM MDM.ContactAttributeMasterValues A
			INNER JOIN @ContactAddressAttributeMaster B
				ON A.AttributeMasterValueID = B.AttributeMasterValueID
			INNER JOIN @ContactAttributeMasterValues C
				ON B.AttributeID = C.AttributeID
			WHERE 
				B.Action = 'U'
				AND
				C.Action = 'U'
				AND
				B.ApplicableFor = 3
				AND
				C.ApplicableFor = 3
			
			--Insert Data into MDM.ContactAttributeMaster Table when Action is 'I'
			INSERT INTO MDM.ContactAttributeMaster(
													AttributeID			
													,AttributeName			
													,IsActive				
													,IsDeleted				
													,ControlType			
													,IsMandatory			
													,IsAddressType			
													,ReviewedBy				
													,LastModifiedDate		
													,LastModifiedByUser		
													,LastModifiedByMachine
												  )
								SELECT	DISTINCT	CAAM.AttributeID			
													,AttributeName			
													,IsActive				
													,IsDeleted				
													,ControlType			
													,IsMandatory			
													,CAMV.SubType			
													,@loginUser
													,@lastModifiedDate		
													,@loginUser		
													,@machineName
											FROM @ContactAddressAttributeMaster CAAM
											INNER JOIN
												@ContactAttributeMasterValues CAMV
												ON CAMV.AttributeID= CAAM.AttributeID
											WHERE 
												CAAM.Action = 'I'
												AND
												CAMV.Action = 'I'
												AND 
												CAAM.ApplicableFor = 3
												AND
												CAMV.ApplicableFor = 3

			--Insert Data into MDM.ContactAttributeMasterValues Table when Action is 'I'
			INSERT INTO MDM.ContactAttributeMasterValues(
															AttributeID	
															,AttributeCode	
															,AttributeValue	
															,IsDefaultValue	
															,IsActive		
														)
												SELECT		CAMV.AttributeID	
															,AttributeCode	
															,AttributeValue	
															,IsDefaultValue	
															,IsActive
												FROM @ContactAttributeMasterValues CAMV
												INNER JOIN
													@ContactAddressAttributeMaster CAAM
													ON CAMV.AttributeID = CAAM.AttributeID														
												WHERE 
													CAMV.Action = 'I'
													AND
													CAAM.Action = 'I'
													AND 
													CAAM.ApplicableFor = 3
													AND
													CAMV.ApplicableFor = 3

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


