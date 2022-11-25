CREATE OR REPLACE  PROCEDURE 
    "SP_EOM_SETPOSTEDPRICE"  
    (v_eomIRM_MonthOnly in number)

as

	v_do_ins_rv number;
	v_review_reason_code varchar2(2);
 
begin        
      
    	dbms_output.enable(10000000);
    
	for rec in ( select i.item_sid from work_productive_item i, item_monthly_status ims, item_reporter ir, reporter r 
		            	where  i.item_sid = ims.item_sid and 
                		ims.rpc_flag = 'Y' and ims.item_rpc_status_end_irm = '999912' 
                 		and i.item_sid = ir.item_sid and 
                       		i.reporter_sid = ir.reporter_sid and 
                       		ir.reporter_sid = r.reporter_sid and 
				ir.item_rptr_end_irm = '999912' 
				and rpc_method = 'P' and 
				SUBSTR(i.rpc_cycle_code_01 || 
				i.rpc_cycle_code_02 || 
				i.rpc_cycle_code_03 ||
				i.rpc_cycle_code_04 ||
				i.rpc_cycle_code_05 ||
				i.rpc_cycle_code_06 ||
				i.rpc_cycle_code_07 ||
				i.rpc_cycle_code_08 ||
				i.rpc_cycle_code_09 ||
				i.rpc_cycle_code_10 ||
				i.rpc_cycle_code_11 ||
				i.rpc_cycle_code_12, v_eomIRM_MonthOnly, 1) = 'M')

                loop
                 
                  
			update work_productive_item set posted_price_flag = 'Y', item_review_status = 'IARV' where item_sid = rec.item_sid;
         
                	select count(*) into v_do_ins_rv from item_review_reason_log where item_sid = rec.item_sid and review_reason_code = '26';
                  
			if  v_do_ins_rv = 0 then 
				insert into item_review_reason_log (item_sid, review_reason_code) values (rec.item_sid, '26');
			end if;




		 end loop;    
     
	dbms_output.put_line('sp_eom_setpostedprice: '|| 'completed');
end;
/