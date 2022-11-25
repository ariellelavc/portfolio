CREATE OR REPLACE  PROCEDURE 
    "SP_EOM_CLEARREVIEWREASONS"  (v_n_minus_1_irm 
    in varchar2)

as

begin

	dbms_output.enable(10000000);
	delete from item_review_reason_log where item_sid in (select i.item_sid 
		        from work_productive_item i, item_monthly_status ims 
		        where  i.item_sid = ims.item_sid and 
                	ims.rpc_flag = 'Y' and ims.item_rpc_status_end_irm = '999912' 
                 	and i.item_review_status in ('NORV','RVCOM'));
                 
	dbms_output.put_line('sp_eom_clearreviewreasons: '|| 'done delete item_review_reason_log');

	update work_spec 
          set  
          unit_of_measure_chg_flag = 'N', 
          type_of_price_chg_flag = 'N',
          prod_code_chg_flag = 'N', 
          text_spec_chg_flag = 'N',
          columnar_spec_chg_flag = 'N' 
          where item_sid in (select i.item_sid 
		        from work_productive_item i, item_monthly_status ims 
		        where  i.item_sid = ims.item_sid and 
                	ims.rpc_flag = 'Y' and ims.item_rpc_status_end_irm = '999912' 
                 	and i.item_review_status in ('NORV','RVCOM'))
          		and irm between to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM') and v_n_minus_1_irm;
          
 	dbms_output.put_line('sp_eom_clearreviewreasons: '|| 'done update work_spec');  
                 
        update work_term_of_trans
	    set  
	    type_of_sale_chg_flag = 'N' ,  
	    domestic_foreign_chg_flag = 'N' ,  
	    type_of_buyer_chg_flag = 'N' ,  
	    bls_contract_chg_flag = 'N' ,  
	    contract_terms_chg_flag = 'N' ,  
	    freight_chg_flag = 'N' ,  
	    size_of_shipment_chg_flag = 'N' ,  
	    size_of_order_chg_flag = 'N'
	    where item_sid in (select i.item_sid 
		     	from work_productive_item i, item_monthly_status ims 
		    	where  i.item_sid = ims.item_sid and 
			ims.rpc_flag = 'Y' and ims.item_rpc_status_end_irm = '999912' 
	 		and i.item_review_status in ('NORV','RVCOM'))
			and irm between to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM') and v_n_minus_1_irm;
                        
	dbms_output.put_line('sp_eom_clearreviewreasons: '|| 'done update work_term_of_trans');                        
                                   
	update work_item_price 
	    set  
	    rptd_price1_chg_flag = 'N' ,  
	    rptd_price2_chg_flag = 'N' , 
	    gross_price1_chg_flag = 'N' , 
	    gross_price2_chg_flag = 'N' , 
	    print_option1_flag = 'N' , 
	    print_option1_chg_flag = 'N' , 
	    print_option2_flag = 'N' , 
	    print_option2_chg_flag = 'N'  
	    where item_sid in (select i.item_sid 
		     	from work_productive_item i, item_monthly_status ims 
		    	where  i.item_sid = ims.item_sid and 
			ims.rpc_flag = 'Y' and ims.item_rpc_status_end_irm = '999912' 
	 		and i.item_review_status in ('NORV','RVCOM'))
			and irm between to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM') and v_n_minus_1_irm; 
                        
	dbms_output.put_line('sp_eom_clearreviewreasons: '|| 'done update work_item_price');                  
                   
	update work_item_cell_price 
	    set  
	    est_method_code_chg_flag = 'N' ,  
	    np_quality_code_chg_flag = 'N' , 
	    base_price_chg_flag = 'N' , 
	    bp_method_code_chg_flag = 'N'                                          
	    where item_sid in (select i.item_sid 
		     	from work_productive_item i, item_monthly_status ims 
		    	where  i.item_sid = ims.item_sid and 
			ims.rpc_flag = 'Y' and ims.item_rpc_status_end_irm = '999912' 
	 		and i.item_review_status in ('NORV','RVCOM'))
			and irm between to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM') and v_n_minus_1_irm; 

	dbms_output.put_line('sp_eom_clearreviewreasons: '|| 'done update work_item_cell_price'); 
	
	update work_adjustment_to_price 
          set  
          adj_chg_flag = 'N' 
          where item_sid in (select i.item_sid 
		        from work_productive_item i, item_monthly_status ims 
		        where  i.item_sid = ims.item_sid and 
                	ims.rpc_flag = 'Y' and ims.item_rpc_status_end_irm = '999912' 
                 	and i.item_review_status in ('NORV','RVCOM'))
          		and irm between to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM') and v_n_minus_1_irm;
          
 	dbms_output.put_line('sp_eom_clearreviewreasons: '|| 'done update work_adjustment_to_price'); 

	update work_productive_item 
          set 
          work_in_progress_flag = 'N' , 
          posted_price_flag = 'N' , 
          return_flag = 'N' ,
          tol_flag = 'N' ,
          price_review_flag = 'N' , 
          text_spec_chg_flag = 'N' , 
          columnar_spec_chg_flag = 'N' ,
          adj_chg_flag = 'N' , 
          terms_chg_flag = 'N' , 
          rmks_rptd_flag = 'N' , 
          other_reason_flag = 'N',
          item_review_bypass_flag = 'N',
	  item_review_status = 'NOINFO'
          where item_sid in (select i.item_sid 
		        from work_productive_item i, item_monthly_status ims 
		        where  i.item_sid = ims.item_sid and 
                	ims.rpc_flag = 'Y' and ims.item_rpc_status_end_irm = '999912' 
                 	and i.item_review_status in ('NORV','RVCOM'));

	dbms_output.put_line('sp_eom_clearreviewreasons: '|| 'done update work_productive_item'); 
	
	update productive_item
		set
		item_review_bypass_flag = 'N'
		where item_sid in (select a.item_sid
		        from productive_item a, work_productive_item i, item_monthly_status ims
		        where a.item_sid = i.item_sid and  
		              i.item_sid = ims.item_sid and
                	ims.rpc_flag = 'Y' and ims.item_rpc_status_end_irm = '999912'
                 	and i.item_review_status in ('NORV','RVCOM'));
 
 dbms_output.put_line('sp_eom_clearreviewreasons: '|| 'done update productive_item');   

end;
/