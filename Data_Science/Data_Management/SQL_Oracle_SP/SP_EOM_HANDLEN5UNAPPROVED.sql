CREATE OR REPLACE PROCEDURE SP_EOM_HANDLEN5UNAPPROVED
    (v_n_minus_1_irm in varchar2)

as

begin

	 dbms_output.enable(10000000);

	 delete from work_item_chars where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');



	 delete from work_columnar_spec_colwidth where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');



	 delete from work_columnar_spec_attribute where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');


	 delete from work_columnar_spec where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');


	 delete from work_spec where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');



	 delete from work_term_of_trans where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');

    delete from work_adjustment_detail where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');

  delete from work_adjustment_to_price where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');


	 delete from work_item_price where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');

	 delete from work_item_cell_price where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');

	 delete from work_item_cell_map where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');
					    
	 delete from work_item_monthly_status where item_sid in
			(select i.item_sid
				     from work_productive_item i, item_monthly_status ims
				     where  i.item_sid = ims.item_sid and
					    ims.rpc_flag = 'Y' and
					    ims.item_rpc_status_end_irm = '999912' and
					    i.item_review_status in ('NORV','RVCOM'))
					    and IRM <= to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),-4),'YYYYMM');
					    
  
	dbms_output.put_line('sp_eom_handlen5unapproved: '|| 'completed' );

end;
/
