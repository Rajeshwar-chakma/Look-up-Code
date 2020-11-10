create or replace package XXFND_LIST_LOOKUP_CODES_PKG 
as
  P_LOOKUP_TYPE VARCHAR2(30); 
  function BeforeReportTrigger return boolean;
END XXFND_LIST_LOOKUP_CODES_PKG;
/

create or replace package body XXFND_LIST_LOOKUP_CODES_PKG 
as
  FUNCTION BeforeReportTrigger return boolean 
  is
  begin
    INSERT INTO XXFND_LOOKUP_TYPES_D(request_id, LOOKUP_TYPE_D, LOOKUP_TYPE_MEANING_D)
	                                 SELECT FND_GLOBAL.CONC_REQUEST_ID,
	                                     fltv.LOOKUP_TYPE LOOKUP_TYPE_D,
	                                     fltv.MEANING LOOKUP_TYPE_MEANING_D
                                     FROM FND_LOOKUP_TYPES_VL fltv
                                     WHERE fltv.LOOKUP_TYPE = P_LOOKUP_TYPE;
									 
	INSERT INTO XXFND_LOOKUP_VALUES_D(request_id, APPLICATION_ID, APPLICATION_NAME, LOOKUP_TYPE, LOOKUP_TYPE_DESCRIPTION, LOOKUP_CODE, LOOKUP_CODE_MEANING, 
	                                  LOOKUP_CODE_DESCRIPTION, CREATION_DATE)
	                                 SELECT FND_GLOBAL.CONC_REQUEST_ID,
	                                        fltv.APPLICATION_NAME,
											fltv.LOOKUP_TYPE,
                                            fltv.DESCRIPTION LOOKUP_TYPE_DESCRIPTION,
	                                        flvv.LOOKUP_CODE,
	                                        flvv.MEANING LOOKUP_CODE_MEANING,
                                            flvv.DESCRIPTION LOOKUP_CODE_DESCRIPTION,
	                                        fltv.CREATION_DATE
                                     FROM FND_LOOKUP_TYPES_VL fltv, FND_LOOKUP_VALUES_VL flvv, FND_APPLICATION_VL fav
                                     WHERE fltv.LOOKUP_TYPE = flvv.LOOKUP_TYPE
									 AND fltv.LOOKUP_TYPE = P_LOOKUP_TYPE
									 AND fltv.APPLICATION_ID = fav.APPLICATION_ID
                                     -- AND fltv.APPLICATION_ID = flvv.view_application_id
                                     AND fltv.SECURITY_GROUP_ID = flvv.SECURITY_GROUP_ID;				 
    -- fnd_file.put_line(fnd_file.log,'This log message is from XXFND_LIST_LOOKUP_CODES_PKG.BeforeReportTrigger()');
    -- INSERT INTO XXEDP_LOG_MESSAGES(LOG_MESSAGE_DESCRIPTION, ATTRIBUTE1, CREATION_DATE) 
    --                        VALUES('This log message is from XXFND_LIST_LOOKUP_CODES_PKG.BeforeReportTrigger()', NULL, SYSDATE);
    --COMMIT;    
    RETURN(TRUE);
  end BeforeReportTrigger;
END XXFND_LIST_LOOKUP_CODES_PKG;
/