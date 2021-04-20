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

        ;---------------------------------------
		; 【処理の開始】
		;---------------------------------------
		cdecl	puts, .s0						; // ヘッダを表示

		mov		bp, 0							; lines = 0; // 行数
		mov		ebx, 0							; index = 0; // インデックスを初期化
.10L:											; do
												; {
		mov		eax, 0x0000E820					;   EAX   = 0xE820
												;   EBX   = インデックス
		mov		ecx, E820_RECORD_SIZE			;   ECX   = 要求バイト数
		mov 	edx, 'PAMS'						;   EDX   = 'SMAP';
		mov		di, .b0							;   ES:DI = バッファ
		int		0x15							;   BIOS(0x15, 0xE820);

		; コマンドに対応か？
		cmp		eax, 'PAMS'						;   if ('SMAP' != EAX)
		je		.12E							;   {
		jmp		.10E							;     break; // コマンド未対応
.12E:											;   }

		; エラー無し？							 ;   if (CF)
		jnc		.14E							;   {
		jmp		.10E							;     break; // エラー発生
.14E:											;   }

		; 1レコード分のメモリ情報を表示
		cdecl	put_mem_info, di				;   1レコード分のメモリ情報を表示

		; ACPI dataのアドレスを取得
		mov		eax, [di + 16]					;   EAX = レコードタイプ;
		cmp		eax, 3							;   if (3 == EAX) // ACPI data
		jne		.15E							;   {
												;     
		mov		eax, [di +  0]					;     EAX   = BASEアドレス;
		mov		[ACPI_DATA.adr], eax			;     ACPI_DATA.adr = EAX;
												;     
		mov		eax, [di +  8]					;     EAX   = Length;
		mov		[ACPI_DATA.len], eax			;     ACPI_DATA.len = EAX;
.15E:											;   }

		cmp		ebx, 0							;   if (0 != EBX)
		jz		.16E							;   {
												;     
		inc		bp								;     lines++;
		and		bp, 0x07						;     lines &= 0x07;
		jnz		.16E							;     if (0 == lines)
												;     {
		cdecl	puts, .s2						;       // 中断メッセージを表示
												;       
		mov		ah, 0x10						;       // キー入力待ち
		int		0x16							;       AL = BIOS(0x16, 0x10);
												;       
		cdecl	puts, .s3						;       // 中断メッセージを消去
												;     }
.16E:											;   }
												;   
		cmp		ebx, 0							;   
		jne		.10L							; }
.10E:											; while (0 != EBX);

		cdecl	puts, .s1						; // フッダを表示