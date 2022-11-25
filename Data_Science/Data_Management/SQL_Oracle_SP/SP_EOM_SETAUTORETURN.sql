CREATE OR REPLACE  PROCEDURE 
    "SP_EOM_SETAUTORETURN"  (v_eomirm in 
    varchar2)

as
	v_do_ins_rv number;
	v_autoreturn_month varchar2(6);

begin

	dbms_output.enable(10000000);

	FOR rec in ( select i.item_sid, auto_return_type_code from work_productive_item i, item_monthly_status ims where  i.item_sid = ims.item_sid and 
	     ims.rpc_flag = 'Y'
	    and ims.item_rpc_status_end_irm = '999912')
			 LOOP

			 if rec.auto_return_type_code is null then
			    update work_productive_item set auto_return_flag = 'N' where 
		 item_sid = rec.item_sid;
			 end if;

			 if rec.auto_return_type_code ='1' then
			    update work_productive_item set auto_return_type_code = null, auto_return_flag = 'Y', item_review_status = 'IARV' where 
		 item_sid = rec.item_sid;

			    select count(*) into v_do_ins_rv from item_review_reason_log where item_sid = rec.item_sid and 
			  review_reason_code = '25';

			    if  v_do_ins_rv = 0 then 
			      insert into item_review_reason_log (item_sid, review_reason_code) values (rec.item_sid, '25');
			    end if;
			 end if;

			 if rec.auto_return_type_code ='2' then 
			    select count(*) into v_autoreturn_month from auto_return_month where item_sid = rec.item_sid and 
			  auto_return_month = substr(v_eomirm,5,2);

			    if  v_autoreturn_month = 1 then 
				update work_productive_item set auto_return_flag = 'Y', item_review_status = 'IARV' where 
		 item_sid = rec.item_sid;

				select count(*) into v_do_ins_rv from item_review_reason_log where item_sid = rec.item_sid and 
			  review_reason_code = '25';

				if  v_do_ins_rv = 0 then 
				  insert into item_review_reason_log (item_sid, review_reason_code) values (rec.item_sid, '25');
				end if;

			    end if;
			 end if;        


			 END LOOP;    


	dbms_output.put_line('sp_eom_setautoreturn: '|| 'completed' );

end;
/