--**********************************************--
--						--
-- 	EDXVAULT DATABASE			--
--						--
--**********************************************--

--**********************************************--
--						--
-- 	REPOSITORY TABLES			--
--						--
--**********************************************--

--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_PAYLOAD
--
--+++++++++++++++++++++++++++++++++++	


CREATE TABLE EDX_PAYLOAD ( 
  PAYLOAD_ID      NUMBER        NOT NULL, 
  PAYLOAD_STATUS  VARCHAR2 (32)  NOT NULL, 
  PAYLOAD_DESC    VARCHAR2 (255), 
  PAYLOAD_DT      DATE          NOT NULL, 
  PAYLOAD_RS_LOC  VARCHAR2(1024),
  CONSTRAINT EDX_PAYLOAD_IDX_PK PRIMARY KEY ( PAYLOAD_ID )); 


CREATE INDEX EDX_PAYLOAD_IDX_STS ON 
  EDX_PAYLOAD(PAYLOAD_STATUS); 


--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_REQUEST
--
--+++++++++++++++++++++++++++++++++++ 

CREATE TABLE EDX_REQUEST ( 
  VAULT_ID    VARCHAR2 (32)     NOT NULL, 
  OWNER_ID    VARCHAR2 (255)  NOT NULL, 
  PAYLOAD_ID  NUMBER        NOT NULL, 
  RQ_STATUS   VARCHAR2 (32)  NOT NULL, 
  RQ_DESC     VARCHAR2 (255), 
  CONSTRAINT EDX_REQUEST_IDX_PK PRIMARY KEY ( VAULT_ID ),
  CONSTRAINT EDX_REQUEST_PAYLOAD_IDX_FK FOREIGN KEY (PAYLOAD_ID) REFERENCES EDX_PAYLOAD (PAYLOAD_ID)); 



--**********************************************--
--						--
-- 	REPOSITORY TABLES			--
--						--
--**********************************************--

--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_RECORD
--
--+++++++++++++++++++++++++++++++++++  

CREATE TABLE EDX_RECORD ( 
  VAULT_ID    VARCHAR2 (32)     NOT NULL, 
  OWNER_ID    VARCHAR2 (255)  NOT NULL,
  OWNER_ORG   vARCHAR2 (64) NOT NULL,   
  REC_STATUS   VARCHAR2 (32)  NOT NULL, 
  RESOURCE_LOC     VARCHAR2 (1024),
  RESOURCE_BACKUP_LOC     VARCHAR2 (1024),
  ECONTRACT   BLOB NOT NULL, 
  CONSTRAINT EDX_RECORD_IDX_PK PRIMARY KEY ( VAULT_ID )); 

CREATE INDEX EDX_RECORD_IDX_OID ON EDX_RECORD(OWNER_ID);

CREATE INDEX EDX_RECORD_IDX_STS ON EDX_RECORD(REC_STATUS);

CREATE INDEX EDX_RECORD_IDX_ORG ON EDX_RECORD(OWNER_ORG); 


--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_HISTORY
--
--+++++++++++++++++++++++++++++++++++ 

CREATE TABLE EDX_HISTORY (
  HISTORY_ID  NUMBER NOT NULL, 
  VAULT_ID    VARCHAR2 (32)     NOT NULL, 
  ACTION      VARCHAR2 (16)  NOT NULL, 
  ACTION_DT   DATE NOT NULL,
  HISTORY_ENTRY  BLOB, 
  CONSTRAINT EDX_HISTORY_IDX_PK PRIMARY KEY ( HISTORY_ID ),
  CONSTRAINT EDX_HISTORY_RECORD_IDX_FK FOREIGN KEY (VAULT_ID) REFERENCES EDX_RECORD (VAULT_ID)); 

CREATE INDEX EDX_HISTORY_IDX_ACT ON EDX_HISTORY(ACTION);

CREATE INDEX EDX_HISTORY_IDX_ACTDT ON EDX_HISTORY(ACTION_DT); 

--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_METADATA
--
--+++++++++++++++++++++++++++++++++++ 

CREATE TABLE EDX_METADATA (  
  METADATA_ID  NUMBER NOT NULL,    
  METADATA_NAME  VARCHAR2 (255)  NOT NULL,   
  CONSTRAINT EDX_METADATA_IDX_PK PRIMARY KEY ( METADATA_ID ) ); 
 
CREATE INDEX EDX_METADATA_IDX_NAME ON 
  EDX_METADATA(METADATA_NAME); 

--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_RECORD_METADATA
--
--+++++++++++++++++++++++++++++++++++ 

CREATE TABLE EDX_RECORD_METADATA (
  VAULT_METADATA_ID NUMBER NOT NULL,
  METADATA_ID  NUMBER NOT NULL, 
  VAULT_ID    VARCHAR2 (32)     NOT NULL, 
  METADATA_VALUE  VARCHAR2 (3000)  NOT NULL,   
  CONSTRAINT EDX_RECORD_METADATA_IDX_PK PRIMARY KEY ( VAULT_METADATA_ID ),
  CONSTRAINT EDX_RECORD_METADATA_REC_IDX_FK FOREIGN KEY (VAULT_ID) REFERENCES EDX_RECORD (VAULT_ID),
  CONSTRAINT EDX_RECORD_METADATA_MTD_IDX_FK FOREIGN KEY (METADATA_ID) REFERENCES EDX_METADATA (METADATA_ID));  
  
CREATE INDEX EDX_RECORD_METADATA_IDX_VAL ON 
  EDX_RECORD_METADATA(METADATA_VALUE); 

--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_MIMETYPE
--
--+++++++++++++++++++++++++++++++++++

CREATE TABLE EDX_MIMETYPE (  
  MIME_ID  NUMBER NOT NULL,    
  MIME_NAME  VARCHAR2 (64)  NOT NULL,     
  CONSTRAINT EDX_MIMETYPE_IDX_PK PRIMARY KEY ( MIME_ID ) ); 
 
--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_ENCODINGTYPE
--
--+++++++++++++++++++++++++++++++++++

CREATE TABLE EDX_ENCODINGTYPE (  
  ENCODING_ID  NUMBER NOT NULL,    
  ENCODING_NAME  VARCHAR2 (64)  NOT NULL,     
  CONSTRAINT EDX_ENCODINGTYPE_IDX_PK PRIMARY KEY ( ENCODING_ID )); 

--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_RECORD_CONTENT
--
--+++++++++++++++++++++++++++++++++++

CREATE TABLE EDX_RECORD_CONTENT (
  RECORD_CONTENT_ID  NUMBER NOT NULL, 
  CONTENT_ID  VARCHAR2 (255),
  VAULT_ID    VARCHAR2 (32)     NOT NULL, 
  CONTENT_DESC  VARCHAR2 (255), 
  CONTENT_AUTH   NUMBER (1) NOT NULL,
  CONTENT_MIME_ID   NUMBER  NOT NULL,
  CONTENT_ENCODING_ID   NUMBER  NOT NULL,
  CONSTRAINT EDX_RECORD_CONTENT_IDX_PK PRIMARY KEY ( RECORD_CONTENT_ID ),
  CONSTRAINT EDX_CONTENT_RECORD_IDX_FK FOREIGN KEY (VAULT_ID) REFERENCES EDX_RECORD (VAULT_ID), 
  CONSTRAINT EDX_CONTENT_MIME_IDX_FK FOREIGN KEY (CONTENT_MIME_ID) REFERENCES EDX_MIMETYPE (MIME_ID),
  CONSTRAINT EDX_CONTENT_ENCODING_IDX_FK FOREIGN KEY (CONTENT_ENCODING_ID) REFERENCES EDX_ENCODINGTYPE (ENCODING_ID)); 

CREATE INDEX EDX_RECORD_CONTENT_IDX_ID ON 
  EDX_RECORD_CONTENT(CONTENT_ID);

CREATE INDEX EDX_RECORD_CONTENT_IDX_AUTH ON 
  EDX_RECORD_CONTENT(CONTENT_AUTH); 


--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_INDICES
--
--+++++++++++++++++++++++++++++++++++

CREATE TABLE EDX_INDICES (      
  IDX_NAME  VARCHAR2 (32)  NOT NULL,
  IDX_VALUE NUMERIC NOT NULL,   
  CONSTRAINT EDX_INTERNALINDICES_IDX_PK PRIMARY KEY ( IDX_NAME ) );  
 
--**********************************************--
--						--
-- DIAGNOSTIC TABLES				--	
--						--
--**********************************************--

--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_SYSLOG_LEVEL
--
--+++++++++++++++++++++++++++++++++++


CREATE TABLE EDX_SYSLOG_LEVEL ( 
  SYSLOG_LEVEL    NUMBER     NOT NULL, 
  SYSLOG_LEVEL_NAME    VARCHAR2 (8)  NOT NULL,    
  CONSTRAINT EDX_SYSLOG_LEVEL_IDX_PK PRIMARY KEY ( SYSLOG_LEVEL ) ); 


--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_SYSLOG_CHANNEL
--
--+++++++++++++++++++++++++++++++++++


CREATE TABLE EDX_SYSLOG_CHANNEL ( 
  CHANNEL    NUMBER     NOT NULL, 
  CHANNEL_NAME    VARCHAR2 (128)  NOT NULL,    
  CONSTRAINT EDX_SYSLOG_CHANNEL_IDX_PK PRIMARY KEY ( CHANNEL ) ); 


--+++++++++++++++++++++++++++++++++++
--
--	TABLE EDX_SYSLOG_LOG
--
--+++++++++++++++++++++++++++++++++++

CREATE TABLE EDX_SYSLOG_LOG ( 
  ID	        NUMBER,
  STATUS	NUMBER	NOT NULL,
  LOG_TIME	DATE	NOT NULL,
  SYSLOG_LEVEL	NUMBER	NOT NULL,
  HOST	        VARCHAR2 (32)	NOT NULL,
  LOGGER	VARCHAR2 (64)	NOT NULL,
  CHANNEL	NUMBER	NOT NULL,
  MESSAGE	VARCHAR2 (255)	NOT NULL,
  DETAIL	VARCHAR2 (4000),
  THREAD_NAME	VARCHAR2(255),
  CONSTRAINT EDX_SYSLOG_LOG_IDX_PK PRIMARY KEY ( ID ),
  CONSTRAINT EDX_SYSLOG_LEVEL_IDX_FK FOREIGN KEY (SYSLOG_LEVEL) REFERENCES EDX_SYSLOG_LEVEL (SYSLOG_LEVEL),
  CONSTRAINT EDX_SYSLOG_CHANNEL_IDX_FK FOREIGN KEY (CHANNEL) REFERENCES EDX_SYSLOG_CHANNEL (CHANNEL) ); 



