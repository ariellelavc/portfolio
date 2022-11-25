CREATE OR REPLACE PROCEDURE "SP_EOM_COPYNMINUS1TON"  (v_n_minus_1_irm in
    varchar2)

as

begin
dbms_output.enable(10000000);

update global_param set param_value = to_char(add_months(to_date(param_value,'yyyymm'),1),'YYYYMM') where param_name='IRM';

insert into work_item_monthly_status (item_sid, irm, rpc_flag) (select item_sid, to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),1),'YYYYMM'),'Y' FROM item_monthly_status
    WHERE rpc_flag = 'Y'
    and item_rpc_status_end_irm = '999912');

insert into work_item_chars(ITEM_SID,
IRM,
RPTD_PRICE_NUM,
GROSS_PRICE_NUM,
RPTD_PRICE_OPERATOR,
RPTD_PRICE1_HEADING,
RPTD_PRICE2_HEADING,
GROSS_PRICE1_HEADING,
GROSS_PRICE2_HEADING
) (select ws.item_sid, to_char(add_months(to_date(irm,'yyyymm'),1),'YYYYMM') irm,RPTD_PRICE_NUM,
	GROSS_PRICE_NUM,RPTD_PRICE_OPERATOR,RPTD_PRICE1_HEADING,RPTD_PRICE2_HEADING,GROSS_PRICE1_HEADING,
	GROSS_PRICE2_HEADING
	from work_item_chars ws, item_monthly_status ims 
	where ws.item_sid = ims.item_sid and
	      ims.rpc_flag = 'Y'and 
              ims.item_rpc_status_end_irm = '999912' and ws.irm =  v_n_minus_1_irm);
              
insert into work_item_schedule (item_sid, irm)(select item_sid,
to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),1),'YYYYMM') FROM item_monthly_status
    WHERE rpc_flag = 'Y'
    and item_rpc_status_end_irm = '999912');

insert into work_spec (item_sid, irm, unit_of_measure, unit_of_measure_eff_irm,
type_of_price_code,type_of_price_eff_irm, TYPE_OF_PRICE_DETAIL,
PROD_CODE,PROD_CODE_EFF_IRM,TEXT_SPEC,TEXT_SPEC_EFF_IRM,COLUMNAR_SPEC_EFF_IRM,TOTAL_NUM_OF_ROWS,TOTAL_NUM_OF_COLS,RPTD_PRICE1_SPEC_CELL_ADDR,RPTD_PRICE2_SPEC_CELL_ADDR) (select
ws.item_sid, to_char(add_months(to_date(irm,'yyyymm'),1),'YYYYMM') irm, unit_of_measure,
unit_of_measure_eff_irm, type_of_price_code,type_of_price_eff_irm, TYPE_OF_PRICE_DETAIL,
PROD_CODE,PROD_CODE_EFF_IRM,TEXT_SPEC,TEXT_SPEC_EFF_IRM,COLUMNAR_SPEC_EFF_IRM,TOTAL_NUM_OF_ROWS,TOTAL_NUM_OF_COLS,RPTD_PRICE1_SPEC_CELL_ADDR,RPTD_PRICE2_SPEC_CELL_ADDR from
work_spec ws, item_monthly_status ims where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912' and ws.irm = v_n_minus_1_irm);

insert into work_columnar_spec (Select ws.item_sid,
to_char(add_months(to_date(irm,'yyyymm'),1),'YYYYMM') irm, row_num, COLA_SPEC_CELL_VALUE,
COLB_SPEC_CELL_VALUE, COLC_SPEC_CELL_VALUE, COLD_SPEC_CELL_VALUE, COLE_SPEC_CELL_VALUE,
COLF_SPEC_CELL_VALUE, COLG_SPEC_CELL_VALUE, COLH_SPEC_CELL_VALUE, COLI_SPEC_CELL_VALUE,
COLJ_SPEC_CELL_VALUE, COLK_SPEC_CELL_VALUE, COLL_SPEC_CELL_VALUE, COLM_SPEC_CELL_VALUE,
COLN_SPEC_CELL_VALUE, COLO_SPEC_CELL_VALUE,
COLP_SPEC_CELL_VALUE,COLQ_SPEC_CELL_VALUE,COLR_SPEC_CELL_VALUE,COLS_SPEC_CELL_VALUE,
COLT_SPEC_CELL_VALUE,COLU_SPEC_CELL_VALUE,COLV_SPEC_CELL_VALUE,COLW_SPEC_CELL_VALUE,COLX_SPEC_CELL_VALUE,COLY_SPEC_CELL_VALUE
from work_columnar_spec ws, item_monthly_status ims where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912' and ws.irm = v_n_minus_1_irm);

insert into work_columnar_spec_attribute (item_sid, irm, SPEC_CELL_ADDR, SPEC_CELL_FORMAT_CODE,
SPEC_CELL_FORMULA, PRINT_FLAG) (select ws.item_sid,
to_char(add_months(to_date(irm,'yyyymm'),1),'YYYYMM') irm,
SPEC_CELL_ADDR,SPEC_CELL_FORMAT_CODE,
SPEC_CELL_FORMULA, PRINT_FLAG from work_columnar_spec_attribute ws, item_monthly_status ims where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912' and ws.irm = v_n_minus_1_irm);

insert into work_columnar_spec_colwidth (select ws.item_sid,
to_char(add_months(to_date(irm,'yyyymm'),1),'YYYYMM') irm, COL_TITLE, COLWIDTH from
work_columnar_spec_colwidth ws, item_monthly_status ims where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912' and ws.irm = v_n_minus_1_irm);

INSERT INTO WORK_TERM_OF_TRANS (ITEM_SID, IRM,
        TYPE_OF_SALE_CODE,TYPE_OF_SALE_EFF_IRM,
        DOMESTIC_FOREIGN_CODE,DOMESTIC_FOREIGN_EFF_IRM,
        TYPE_OF_BUYER_CODE,TYPE_OF_BUYER_DETAIL,TYPE_OF_BUYER_EFF_IRM,
        CONTRACT_TERMS_DESC, CONTRACT_TERMS_EFF_IRM,
        FREIGHT_CODE,FREIGHT_TERMS_DETAIL,FREIGHT_EFF_IRM,
        BLS_CONTRACT_CODE, BLS_CONTRACT_EFF_IRM,
        SIZE_OF_ORDER_DESC,SIZE_OF_ORDER_EFF_IRM,
        SIZE_OF_SHIPMENT_DESC,SIZE_OF_SHIPMENT_EFF_IRM )
        (SELECT ws.ITEM_SID, to_char(add_months(to_date(irm,'yyyymm'),1),'YYYYMM') IRM,
        TYPE_OF_SALE_CODE,TYPE_OF_SALE_EFF_IRM,
        DOMESTIC_FOREIGN_CODE,DOMESTIC_FOREIGN_EFF_IRM,
        TYPE_OF_BUYER_CODE,TYPE_OF_BUYER_DETAIL,TYPE_OF_BUYER_EFF_IRM,
        CONTRACT_TERMS_DESC, CONTRACT_TERMS_EFF_IRM,
        FREIGHT_CODE,FREIGHT_TERMS_DETAIL,FREIGHT_EFF_IRM,
        BLS_CONTRACT_CODE, BLS_CONTRACT_EFF_IRM,
        SIZE_OF_ORDER_DESC,SIZE_OF_ORDER_EFF_IRM,
        SIZE_OF_SHIPMENT_DESC,SIZE_OF_SHIPMENT_EFF_IRM
   from WORK_TERM_OF_TRANS ws, item_monthly_status ims where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912' and ws.irm = v_n_minus_1_irm);

insert into work_item_cell_map (item_sid, irm, tree_version_sid, ppi_index_sid) (select ws.item_sid, to_char(add_months(to_date(irm,'yyyymm'),1),'YYYYMM') irm, tree_version_sid, ppi_index_sid from work_item_cell_map ws, item_monthly_status ims where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912' and ws.irm = v_n_minus_1_irm);

insert into work_item_cell_price (item_sid, irm, tree_version_sid, ppi_index_sid, EST_METHOD_CODE, base_price, item_base_irm, BASE_PRICE_EFF_IRM, BASE_IN_FLAG, net_price, NET_PRICE_CHG_PCT) (select ws.item_sid, to_char(add_months(to_date(irm,'yyyymm'),1),'YYYYMM') irm, tree_version_sid, ppi_index_sid, EST_METHOD_CODE, base_price, item_base_irm, BASE_PRICE_EFF_IRM, BASE_IN_FLAG, null, null from work_item_cell_price ws, item_monthly_status ims where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912' and ws.irm = v_n_minus_1_irm); 

insert into work_item_price (item_sid, print_option1_flag, print_option2_flag, irm) (select ws.item_sid, print_option1_flag, print_option2_flag,
to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),1),'YYYYMM') FROM work_item_price ws, item_monthly_status ims
    where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912' and ws.irm = v_n_minus_1_irm);

insert into item_price (item_sid, irm)(select item_sid,
to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),1),'YYYYMM') FROM item_monthly_status
    WHERE rpc_flag = 'Y'
    and item_rpc_status_end_irm = '999912');

insert into net_price (item_sid, tree_version_sid, net_price_irm, map_eff_irm, ppi_index_sid, net_price, NET_PRICE_CHG_PCT,EST_METHOD_CODE, NET_PRICE_QUALITY_CODE, update_datetime) (select ws.item_sid, ws.tree_version_sid, to_char(add_months(to_date(net_price_irm,'yyyymm'),1),'YYYYMM') net_price_irm, ws.map_eff_irm, ws.ppi_index_sid,  null, null, EST_METHOD_CODE, 'D',systimestamp from net_price ws,
item_monthly_status ims, item_cell_map icm where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912'
    and ws.item_sid = icm.item_sid
    and ws.ppi_index_sid = icm.ppi_index_sid
    and ws.tree_version_sid = icm.tree_version_sid
    and ws.map_eff_irm = icm.map_eff_irm and net_price_irm = v_n_minus_1_irm
    and to_char(add_months(to_date(v_n_minus_1_irm,'yyyymm'),1),'YYYYMM') between icm.map_eff_irm and icm.map_end_irm);

insert into work_adjustment_to_price (item_sid, irm, adj_num, adj_type_code, adj_type_detail, adj_classification_code, adj_terms, adj_category_code, adj_rptr_applied_flag, adj_order_applied, adj_alias, adj_eff_irm) (select ws.item_sid, to_char(add_months(to_date(irm,'yyyymm'),1),'YYYYMM') irm, adj_num, adj_type_code, adj_type_detail, adj_classification_code, adj_terms, adj_category_code, adj_rptr_applied_flag, adj_order_applied, adj_alias, adj_eff_irm from
work_adjustment_to_price ws, item_monthly_status ims where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912' and ws.irm = v_n_minus_1_irm);


insert into work_adjustment_detail (select ws.item_sid, to_char(add_months(to_date(irm,'yyyymm'),1),'YYYYMM') irm, adj_num, adj_month, adj_amt, adj_sign, adj_factor from work_adjustment_detail ws, item_monthly_status ims where ws.item_sid = ims.item_sid and
     ims.rpc_flag = 'Y'
    and ims.item_rpc_status_end_irm = '999912' and ws.irm = v_n_minus_1_irm);


dbms_output.put_line('sp_eom_copynminus1ton: '|| 'completed');
end;
/
