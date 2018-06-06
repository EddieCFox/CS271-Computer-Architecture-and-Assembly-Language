TITLE Program 2     (Program 2 - Eddie Fox.asm)

;     Name: Eddie C. Fox
;     OSU e-mail address: foxed@oregonstate.edu
;     Class number and section: CS271-400
;     Assignment Number: 2
;     Due date: April 17, 2016 at midnight pacific time.
;               Grace day used.
;     Description: This program prompts the user to enter
;                  two numbers, and calculates the sum,
;                  difference, product, and quotient.
;                  These calculations are then displayed.\

INCLUDE Irvine32.inc

; Initial setup

.386
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

; Variables stored below

.data

; Program information strings

programTitle BYTE "Fibonacci Numbers",0
assignmentInfo BYTE "Assignment #2, by Eddie C. Fox",0

; User name and greeting strings

namePrompt BYTE "What is your name?",0
userName BYTE 100 DUP(0) ; stores the users name
hello BYTE "Hello, ",0

; User instruction strings

prompt1 BYTE "Please enter the number of fibonacci terms you would like displayed.",0
prompt2 BYTE "Enter a number from 1 to 46. 47 and above is too large to display.",0
prompt3 BYTE "How many fibonacci numbers would you like to see?",0

; Input collection and validation

userNumber DWORD ?
UPPERLIMIT = 46 ; This is the upper limit of what the user can enter when prompted for # of fiobonacci numbers
invalid BYTE "The number must be between 1 and 46. Please try again.",0

; Showing user what was accepted

showing1 BYTE "Input accepted. Now showing the first ",0
showing2 BYTE " Fibonacci Numbers.",0

; Variables to help calculate fibonacci numbers

total DWORD ?
first DWORD 1
second DWORD 1
loopCount DWORD 2
loopRemainder DWORD ?
; Variables to help display fibonacci numbers

spaces BYTE "     ",0

; Farewell string

goodbye BYTE "Farewell for now, ",0
terminating BYTE "The program is now terminating.",0

; Code stored below

.code

main PROC

; Program information 

	mov edx,OFFSET programTitle
	call WriteString
	call Crlf
	mov edx,OFFSET assignmentINFO
	call WriteString
	call Crlf
	
; Getting user name and greeting them

	mov edx,OFFSET namePrompt
	call WriteString
	call Crlf
	call Crlf
	mov edx,OFFSET userName
	mov ecx,SIZEOF userName
	call ReadString
	call Crlf
	mov edx,OFFSET hello
	call WriteString
	mov edx,OFFSET userName
	call WriteString
	call Crlf
	call Crlf

; User instructions

	mov edx,OFFSET prompt1
	call WriteString
	call Crlf
	mov edx,OFFSET prompt2
	call WriteString
	call Crlf
	
; User prompt

	call Crlf
	mov edx,OFFSET prompt3
	call WriteString
	call Crlf

; Input collection and validation post-test loop

	L1: 
		call ReadDec 
		mov userNumber,eax 
		cmp userNumber,UPPERLIMIT
		JBE L2

		mov edx,OFFSET invalid
		call WriteString
		call Crlf
		JMP L1

; Showing user what they entered.
	
	L2:
		mov edx,OFFSET showing1
		call WriteString
		mov eax,userNumber
		call WriteDec

		mov edx,OFFSET showing2
		call WriteString
		call Crlf

; Loop to calculate and display Fibonacci Numbers

	mov ecx,userNumber
	mov eax,first
	call WriteDec
	mov edx,OFFSET spaces
	call WriteString
	mov eax,second
	call WriteDec
	call WriteString


	FLOOP:
		mov eax,first
		add eax,second
		mov total,eax
		mov eax,total
		call WriteDec
		mov edx,OFFSET spaces
		call WriteString
		mov eax,second
		mov first,ebx
		mov eax,total
		mov second,eax
		
		LOOP FLOOP


; Farewell
	call Crlf
	call Crlf
	mov edx,OFFSET goodbye
	call WriteString
	mov edx,OFFSET username
	call WriteString
	call Crlf
	mov edx,OFFSET terminating
	call WriteString

	INVOKE ExitProcess,0
	
main ENDP
END main