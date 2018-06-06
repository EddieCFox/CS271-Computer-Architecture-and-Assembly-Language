TITLE Program 1      (Program 1- Eddie Fox.asm)

;     Name: Eddie C. Fox
;     OSU e-mail address: foxed@oregonstate.edu
;     Class number and section: CS271-400
;     Assignment Number: 1
;     Due date: April 10, 2016 at midnight pacific time.
;     Description: This program prompts the user to enter
;                  two numbers, and calculates the sum,
;                  difference, product, and quotient.
;                  These calculations are then displayed.
INCLUDE Irvine32.inc

; The initial setups as described in the book.
; .model flat,stdcall is omitted because it would cause the
; program to not be able to build.


.386
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

; Variables stored below. 

.data

; Various prompting strings here

initialInformation BYTE "Programming assignment 1, by Eddie C. Fox",0
greeting BYTE "Welcome to the program!",0
prompt BYTE "Enter two positive integers to perform calculations on.",0
disclaimer BYTE "Please enter larger number first if you want to subtract.",0
firstNumberPrompt BYTE "Please enter the first number.",0
secondNumberPrompt BYTE "Please enter the second number.",0

; Variables that store the first and second number.

firstNumber DWORD ?
secondNumber DWORD ?

; Variables that hold the result of calculations

sum DWORD ?
difference DWORD ? 
product DWORD ? 
quotient DWORD ?
remainder DWORD ?

; Strings that display the results of the calculations.

sumDisplay BYTE "The sum of the two numbers is: ",0
differenceDisplay BYTE "The difference of the two numbers is: ",0
productDisplay BYTE "The product of the two numbers is: ",0
quotientDisplay BYTE "The quotient of the two numbers is: ",0
remainderDisplay BYTE ", remainder ",0

; String to say goodbye

goodbyeDisplay BYTE "It has been a pleasure. Goodbye!",0


; Code stored below. 

.code
main PROC

; Greeting 

	mov edx,OFFSET greeting
	call WriteString
	call Crlf

; Initial information

	mov edx,OFFSET initialInformation
	call WriteString
	call Crlf
	call Crlf

; Prompting user to enter two numbers.
	mov edx,OFFSET prompt
	call WriteString
	call Crlf
	mov edx,OFFSET disclaimer
	call WriteString
	call Crlf
	call Crlf

; Prompt and reading for first number

	mov edx,OFFSET firstNumberPrompt
	call WriteString
	call Crlf
	call ReadDec
	mov firstNumber,eax
	call Crlf

; Prompt and reading for second number.

	mov edx,OFFSET secondNumberPrompt
	call WriteString
	call Crlf
	call ReadDec
	mov secondNumber,eax
	call Crlf

; Calculations

	; Addition
	
	mov eax,firstNumber
	add eax,secondNumber
	mov sum,eax

	; Subtraction

	mov eax,firstNumber
	sub eax,secondNumber
	mov difference,eax

	; Multiplication 

	mov eax,firstNumber
	MUL secondNumber
	mov product,eax

	; Division

	mov eax,firstNumber
	mov edx,0
	DIV secondNumber
	mov quotient,eax
	mov remainder,edx

; Displaying calculations

	; Displaying addition

	mov edx,OFFSET sumDisplay
	call WriteString
	mov eax,sum
	call WriteDec
	call Crlf

	; Displaying subtraction

	mov edx,OFFSET differenceDisplay
	call WriteString
	mov eax,difference
	call WriteDec
	call Crlf

	; Displaying product

	mov edx,OFFSET productDisplay
	call WriteString
	mov eax,product
	Call WriteDec
	call Crlf

	; Displaying quotient
	mov edx,OFFSET quotientDisplay
	call WriteString
	mov eax,quotient
	Call WriteDec
	mov edx,OFFSET remainderDisplay
	Call WriteString
	mov eax,remainder
	Call WriteDec
	call Crlf
	call Crlf

; Saying goodbye

	mov edx,OFFSET goodbyeDisplay
	call WriteString


	INVOKE ExitProcess,0

main ENDP
END main