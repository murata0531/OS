;************************************************************************
;	メモリ情報の表示
;------------------------------------------------------------------------
;	ACPIデータのアドレスと長さをグローバル変数に保存する
;========================================================================
;■書式		: void get_mem_info(void);
;
;■引数		: 無し
;
;■戻り値;	: 無し
;************************************************************************
get_mem_info:
		;---------------------------------------
		; 【レジスタの保存】
		;---------------------------------------
		push	eax
		push	ebx
		push	ecx
		push	edx
		push	si
		push	di
		push	bp