TITLE Program 4     (Program 4 - Eddie Fox.asm)

;     Name: Eddie C. Fox
;     OSU e-mail address: foxed@oregonstate.edu
;     Class number and section: CS271-400
;     Assignment Number: 4
;     Due date: May 8, 2016 at midnight pacific time.
;     Description:  This program prompts the user to enter
;                   a number of composite numbers they would
;                   like to see calculated. The program then
;                   calculates and displays all composite
;                   numbers, 10 per line, 3 spaces inbetween.

INCLUDE Irvine32.inc

; Initial setup

ExitProcess PROTO, dwExitCode:DWORD

; Variables stored below

.data

; Constants

LOWERLIMIT = 1
UPPERLIMIT = 400

; Strings for introduction

introduction1 BYTE "Welcome to Composite Number Displayer!",0
introduction2 BYTE "This is Program #4 by Eddie C. Fox.",0

; Variables to get and validate user data

description1 BYTE "This program will calculate a user specified amount of composite numbers,",0
description2 BYTE "starting from the number 4, which is the first composite number.",0
instruction BYTE "Please enter the number of composite numbers you would like to see displayed.",0
prompt BYTE "Please enter a number between 1 and 400.",0
invalid BYTE "The number you entered is out of range, or not a number. Please try again.",0
validInput BYTE "Input validated and recieved. Composite numbers will be displayed below.",0
numberOfNumbers DWORD ?

; Variables to calculate and display composite numbers.

space BYTE "   ",0
innerLoopCount DWORD 0
outterLoopCount DWORD ?
writtenCount DWORD 0
innerNumber DWORD ?
outterNumber DWORD 3

; String to say farewell

farewell BYTE "Results verified by Eddie Fox. Goodbye.",0

; Code stored below

.code

main PROC

	CALL displayIntroduction
	CALL getData
	CALL showComposites
	CALL displayFarewell
	INVOKE ExitProcess,0 ; Put a breakpoint here if grading	
main ENDP

;--------------------------------
displayIntroduction PROC
; Description: Displays the introduction to the program. 
; Recieves: Nothing
; Returns: Nothing
; Prediconditions: None technically, but should only be called at the beginning of the program.
; Registers changed: EDX will have the OFFSET of introduction2 after execution is finished.
;--------------------------------
	mov edx,OFFSET introduction1
	call WriteString
	call Crlf
	mov edx,OFFSET introduction2
	call WriteString
	call Crlf
	call Crlf
	ret
displayIntroduction ENDP

;-------------------------------
getData PROC
; Description: Prompts user to enter a number of composite numbers they would like to see from 1-400
;              and validates the number to ensure it is in the range. 
; Recieves: Nothing
; Returns:  Doesn't return anything technically, but stores the user data in the numberOfNumbers variable.
; Prediconditions: None technically, but should be called after displayIntroduction and before displayFarewell
; Registers changed: EAX will have the validated user data in the variable numberOfNumbers.
;                    EDX will have the OFFSET of validInput after execution is finished.
;--------------------------------

; Strings to write descriptions and instructions

	mov edx,OFFSET description1
	call WriteString
	call Crlf

	mov edx,OFFSET description2
	call WriteString
	call Crlf

	mov edx,OFFSET instruction
	call WriteString
	call Crlf
	call Crlf

; Read input
	READ:
		mov edx,OFFSET prompt
		call WriteString
		call Crlf
		call ReadDec
		mov numberOfNumbers,eax

; Valid input to ensure it is inside range by comparing to 1 and 400

		cmp numberOfNumbers,LOWERLIMIT
		JB NOT_VALID

		cmp numberOfNumbers,UPPERLIMIT
		JA NOT_VALID
		JMP VALID

	NOT_VALID:
		mov edx,OFFSET invalid
		call Crlf
		call WriteString
		call Crlf
		JMP READ

; Inform user that input was validated, and that composite numbers will be below.

	VALID:
		mov edx,OFFSET validInput
		call Crlf
		call WriteString
		call Crlf
		call Crlf
		ret

getData ENDP

;-------------------------------
showComposites PROC
; Description: This function calculates composite numbers up to the amount the user requested.
;			   10 composite numbers are displayed per line, with 3 spaces in between each.
; Recieves: Nothing, but uses numberOfNumbers.
; Returns:  Doesn't return anything, but outputs a list of composite numbers.
; Prediconditions: Will not function if called before getData.
; Registers changed: EAX will have the validated user data in the variable numberOfNumbers.
;                    EDX will have the OFFSET of validInput after execution is finished.
;--------------------------------
	
	mov ecx,numberOfNumbers

	LOOP_BEGINNING:
		inc outterNumber
		mov innerNumber,2
	
	DETERMINE_COMPOSITE:
		
		mov eax,outterNumber
		cmp innerNumber,eax
		JE LOOP_BEGINNING

		mov edx,0
		div innerNumber
		cmp edx,0
		JE IS_COMPOSITE
		
		inc innerNumber
		JMP DETERMINE_COMPOSITE

	IS_COMPOSITE:
		mov eax,outterNumber
		call WriteDec
		mov edx,OFFSET space
		call WriteString
		inc innerLoopCount
		mov eax,innerLoopCount
		mov edx,0
		mov ebx,10
		div ebx
		cmp edx,0
		JE NEW_LINE
		JMP LOOP_END

		NEW_LINE:
			call Crlf
		
	LOOP_END:

		loop LOOP_BEGINNING
		ret

showComposites ENDP

;-------------------------------
displayFarewell PROC
; Description: This function displays the farewell message.
; Recieves: Nothing, but uses the farewell strings.
; Returns:  Doesn't return anything, but outputs a farewell message.
; Prediconditions: Technically none, but should be called at the end of the program.
; Registers changed: EDX will have the OFFSET of farewell after execution is finished.
;--------------------------------
	call Crlf
	mov edx,OFFSET farewell
	call Crlf
	call WriteString
	ret
displayFarewell ENDP
END main