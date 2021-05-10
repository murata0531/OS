;************************************************************************
;	リングバッファからデータを取得
;========================================================================
;■書式		: DWORD ring_rd(buff, data);
;
;■引数
;	buff	: リングバッファ
;	data	: 読み込んだデータの保存先アドレス
;
;■戻り値	: データあり(0以外)、データ無し(0)
;************************************************************************
ring_rd:
		;---------------------------------------
		; 【スタックフレームの構築】
		;---------------------------------------
												; ------|--------
												;    +12| リングデータ
												;    + 8| データアドレス
												; ------|--------
												;    + 4| EIP（戻り番地）
		push	ebp								; EBP+ 0| EBP（元の値）
		mov		ebp, esp						; ------+--------

		;---------------------------------------
		; 【レジスタの保存】
		;---------------------------------------
		push	ebx
		push	esi
		push	edi

		;---------------------------------------
		; 引数を取得
		;---------------------------------------
		mov		esi, [ebp + 8]					; ESI = リングバッファ;
		mov		edi, [ebp +12]					; EDI = データアドレス;

		;---------------------------------------
		; 読み込み位置を確認
		;---------------------------------------
		mov		eax, 0							; EAX = 0;          // データ無し
		mov		ebx, [esi + ring_buff.rp]		; EBX = rp;         // 読み込み位置
		cmp		ebx, [esi + ring_buff.wp]		; if (EBX != wp)    // 書き込み位置と異なる
		je		.10E							; {
												;   
		mov		al, [esi + ring_buff.item + ebx] ;   AL = BUFF[rp]; // キーコードを保存
												;   
		mov		[edi], al						;   [EDI] = AL;     // データを保存
												;   
		inc		ebx								;   EBX++;          // 次の読み込み位置
		and		ebx, RING_INDEX_MASK			;   EBX &= 0x0F     // サイズの制限
		mov		[esi + ring_buff.rp], ebx		;   rp = EBX;       // 読み込み位置を保存
												;   
		mov		eax, 1							;   EAX = 1;        // データあり
.10E:											; }

		;---------------------------------------
		; 【レジスタの復帰】
		;---------------------------------------
		pop		edi
		pop		esi
		pop		ebx

		;---------------------------------------
		; 【スタックフレームの破棄】
		;---------------------------------------
		mov		esp, ebp
		pop		ebp

		ret