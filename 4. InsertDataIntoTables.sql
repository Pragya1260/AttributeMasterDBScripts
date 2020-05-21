USE GlobalMasterAttributes ;
GO

--Insert query for MDM.EntityAttributesMaster
INSERT INTO MDM.EntityAttributesMaster(
										AttributeID
										,AttributeName
										,AttributeCode
										,AttributeValue
										,IsActive
										,IsDeleted
										,IsRTAAttribute
										,ControlType
										,ReviewedBy
										,LastModifiedDate
										,LastModifiedByUser
										,LastModifiedByMachine
									  )
							VALUES	  (
										1
										,'Attribute1'
										,'0'
										,'Yes'
										,1
										,0
										,0
										,1
										,'admin'
										,GETDATE()
										,'NAVadmin'
										,'SYSTEM'
									  )
									 ,(
										1
										,'Attribute1'
										,'1'
										,'No'
										,1
										,0
										,0
										,1
										,'admin'
										,GETDATE()
										,'NAVadmin'
										,'SYSTEM'
									  )
									 ,(
										1
										,'Attribute1'
										,'2'
										,'Maybe'
										,1
										,0
										,0
										,1
										,'admin'
										,GETDATE()
										,'NAVadmin'
										,'SYSTEM'
									  )
									 ,(
										2
										,'Attribute2'
										,'0'
										,'A'
										,1
										,0
										,0
										,1
										,'admin'
										,GETDATE()
										,'NAVadmin'
										,'SYSTEM'
									  )
									 ,(
										2
										,'Attribute2'
										,'1'
										,'B'
										,1
										,0
										,0
										,1
										,'admin'
										,GETDATE()
										,'NAVadmin'
										,'SYSTEM'
									 )
									,(
										3
										,'ClientAttribute1'
										,'0'
										,'Client'
										,1
										,0
										,0
										,1
										,'admin'
										,GETDATE()
										,'NAVadmin'
										,'SYSTEM'
									 )
									,(
										3
										,'ClientAttribute1'
										,'1'
										,'Client1'
										,1
										,0
										,0
										,1
										,'admin'
										,GETDATE()
										,'NAVadmin'
										,'SYSTEM'
									 )

SELECT * FROM MDM.EntityAttributesMaster

--Insert query for MDM.EntityAttributesMasterMapping
INSERT INTO MDM.EntityAttributesMasterMapping(
											   AttributeMasterID
											   ,EntityType
											   ,IsDefaultValue
											   ,IsPartOfDefaultSet
											   ,DisplayOrder
											   ,IsMandatory
											   ,IsValidateFASLockDate
											 )
									VALUES   (
											   1
											   ,0
											   ,1
											   ,0
											   ,1
											   ,0
											   ,0
											 )
											,(
											   2
											   ,0
											   ,0
											   ,0
											   ,2
											   ,0
											   ,0
											 )
											,(
											   3
											   ,0
											   ,0
											   ,0
											   ,3
											   ,0
											   ,0
											 )
											,(
											   4
											   ,0
											   ,1
											   ,0
											   ,1
											   ,0
											   ,0
											 )
											,(
											   5
											   ,0
											   ,0
											   ,0
											   ,2
											   ,0
											   ,0
											 )

SELECT * FROM MDM.EntityAttributesMasterMapping

--Insert query for MDM.ClientAttributeMasterMapping
INSERT INTO MDM.ClientAttributeMasterMapping(
												AttributeMasterID
												,ClientType
												,IsDefaultValue
												,IsPartOfDefaultSet
												,DisplayOrder
												,IsMandatory
											)
									VALUES  (
												6
												,1
												,0
												,0
												,1
												,1
											)
										   ,(
												7
												,2
												,0
												,0
												,1
												,1
											)

SELECT * FROM MDM.ClientAttributeMasterMapping

--Insert query for MDM.ContactAttributeMaster
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
								VALUES (
											100
											,'ContactAddressAttribute1'
											,1
											,0
											,1
											,0
											,1
											,'admin'
											,GETDATE()	
											,'NAVAdmin'
											,'SYSTEM'
									   )
									  ,(
											101
											,'ContactAddressAttribute2'
											,1
											,0
											,1
											,0
											,1
											,'admin'
											,GETDATE()	
											,'NAVAdmin'
											,'SYSTEM'
									   )
									   ,(
											102
											,'ContactAddressAttribute3'
											,1
											,0
											,1
											,0
											,0
											,'admin'
											,GETDATE()	
											,'NAVAdmin'
											,'SYSTEM'
									   )
									  ,(
											103
											,'ContactAddressAttribute4'
											,1
											,0
											,1
											,0
											,0
											,'admin'
											,GETDATE()	
											,'NAVAdmin'
											,'SYSTEM'
									   )

SELECT * FROM MDM.ContactAttributeMaster

--Insert query for MDM.ContactAttributeMasterValues
INSERT INTO MDM.ContactAttributeMasterValues(
												AttributeID
												,AttributeCode
												,AttributeValue
												,IsDefaultValue
												,IsActive
											)
									VALUES	(	
												100
												,'Code1'
												,'Value1'
												,0
												,1
											)
										   ,(	
												101
												,'Code2'
												,'Value2'
												,0
												,1
											)
										   ,(	
												102
												,'Code3'
												,'Value3'
												,0
												,1
											)
										   ,(	
												103
												,'Code4'
												,'Value4'
												,0
												,1
											)

SELECT * FROM MDM.ContactAttributeMasterValues