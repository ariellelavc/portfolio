CREATE OR REPLACE  PROCEDURE 
    "SP_EOM_SETPRODCODE"  (v_eomirm in 
    varchar2)
as

	v_n_prod_code varchar2(11);  
 
begin        
      
	dbms_output.enable(10000000);

	FOR rec in ( select f.item_sid, f.future_prod_code from work_future_item_chars f, item_monthly_status ims where  f.item_sid = ims.item_sid and 
	     ims.rpc_flag = 'Y'
	    and ims.item_rpc_status_end_irm = '999912' and f.future_prod_code_eff_irm = v_eomirm)

			 LOOP
			    dbms_output.put_line('sp_eom_setprodcode item: '|| rec.item_sid);

			     Select prod_code Into v_n_prod_code  
			      From   work_spec
			      Where  item_sid = rec.item_sid and irm = to_char(add_months(to_date(v_eomirm,'yyyymm'),-1),'YYYYMM');

			   if v_n_prod_code = rec.future_prod_code then

				    Update  work_spec
					       set prod_code_chg_flag = 'N' , prod_code = rec.future_prod_code 
					       where item_sid = rec.item_sid and irm = v_eomirm;

					     else 
						 Update  work_spec
					       set prod_code_chg_flag = 'N' , prod_code = rec.future_prod_code, prod_code_eff_irm = v_eomirm 
					       where item_sid = rec.item_sid and irm = v_eomirm;
					     end if;

					     update work_future_item_chars set future_prod_code = null, future_prod_code_eff_irm = null, future_prod_code_chg_flag = 'N' 
					     where item_sid = rec.item_sid;

			 END LOOP;    

	dbms_output.put_line('sp_eom_setprodcode: '|| 'completed');    

end;
/