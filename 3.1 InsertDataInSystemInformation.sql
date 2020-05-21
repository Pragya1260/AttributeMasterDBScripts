INSERT INTO MDM.SystemInformation (
										Type					
										,Code					
										,Name					
										,Value					
										,RefID					
										,DisplayOrder			
										,ValidFrom				
										,ValidTo				
										,Status					
										,IsDefaultSet				
										,LastModifiedDate		
										,LastModifiedByUser		
										,LastModifiedByMachine	
								  )
VALUES ('ClientType','1','BusinessClient','1','349',1,'1900-01-01','9999-12-31',1,1,GETDATE(),'Administration','PRODSERVER')
,('ClientType','2','TransactionClient','1','349',2,'1900-01-01','9999-12-31',1,1,GETDATE(),'Administration','PRODSERVER')
,('ClientType','3','ReportingDelivery&ProcessingGroup','1','349',3,'1900-01-01','9999-12-31',1,1,GETDATE(),'Administration','PRODSERVER')
,('ContactAddressType','0','Contact','1','350',1,'1900-01-01','9999-12-31',1,1,GETDATE(),'Administration','PRODSERVER')
,('ContactAddressType','1','Address','1','350',2,'1900-01-01','9999-12-31',1,1,GETDATE(),'Administration','PRODSERVER')
