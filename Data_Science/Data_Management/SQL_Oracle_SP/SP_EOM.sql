CREATE OR REPLACE PROCEDURE "SP_EOM" as
	v_n_minus_1_irm varchar2(6);
	v_n_irm varchar2(6);
	v_n_minus_1_month_only number;

	begin

		 select param_value into v_n_minus_1_irm from global_param where param_name='IRM';
		 v_n_irm := to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),1),'YYYYMM');
		 v_n_minus_1_month_only := to_number(substr(v_n_minus_1_irm,5,2));

		 sp_eom_copynminus1ton(v_n_minus_1_irm);
		
		 sp_eom_handlen5unapproved(v_n_minus_1_irm);
    
		 sp_eom_clearreviewreasons(v_n_minus_1_irm);
     
		 sp_eom_setprodcode(v_n_irm);
     
		 sp_eom_setautoreturn(v_n_irm);
     
		 sp_eom_setpostedprice(v_n_minus_1_month_only);
		

	end;
/