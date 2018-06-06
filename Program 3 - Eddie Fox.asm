TITLE Program 3     (Program 3 - Eddie Fox.asm)

;     Name: Eddie C. Fox
;     OSU e-mail address: foxed@oregonstate.edu
;     Class number and section: CS271-400
;     Assignment Number: 3
;     Due date: May 1, 2016 at midnight pacific time.
;     Description: This program prompts the user to enter
;				   multiple negative numbers, until they 
;				   enter a non-negative number. The program
;				   then displays the sum of all numbers
;				   entered (excluding the non-negative one),
;				   the rounded average, and the number of
;				   numbers entered.

INCLUDE Irvine32.inc

; Initial setup

ExitProcess PROTO, dwExitCode:DWORD

; Variables stored below

.data

; String for introducting program and programmer

programTitle BYTE "Welcome to the Negative Integer Accumulator.",0
assignmentInfo BYTE "This is CS271 Assignment #3, programmed by Eddie C. Fox",0

; Variables to get user's Name and greet them 

namePrompt BYTE "What is your name?",0
userName BYTE 100 DUP(0) ; stores the users name
hello BYTE "Hello, ",0

;Strings to provide user with information and instructions

instructions1 BYTE "This program takes multiple negative numbers, then provides the",0
instructions2 BYTE "sum, amount of numbers entered, and the rounded average.",0
instructions3 BYTE "Please enter negative integers between -100 and -1,",0
instructions4 BYTE "presing enter after each one. After you are done,",0
instructions5 BYTE "type a non-negative integer, then press enter again.",0
instructions6 BYTE "The above mentioned information will then be calculated and displayed.",0

; Variables for input collection, validation. 

userNumber SDWORD ?
LOWERLIMIT = -100 ; This is the lower limit of the negative numbers the user can enter. 


prompt BYTE "Please enter a number:",0

invalid1 BYTE "The number entered for calculation must be an integer between",0
invalid2 BYTE "negative 100 and negative 1.",0
invalid3 BYTE "If you are done, enter a non-negative integer. Try again.",0

; Variables for calculating outputs

sum SDWORD 0 ; This is the accumulator of the numbers the user enters, initalize at 0
amount SDWORD 0 ; This is the number of numbers the user entered, starting with 0 and incrementing by 1 each valid number.
average SDWORD 0 ; The average of all the valid numbers entered
remainder SDWORD ? ; Remainder of dividing the sum by the amount. 

; Variables for displaying calculated output

displayAverage BYTE "Average: ",0
displayRemainder BYTE "Remainder: ",0
display1 BYTE "You entered ",0
display2 BYTE " numbers.",0
display3 BYTE "The sum of these numbers is ",0
display4 BYTE "The rounded average of these numbers is ",0

; Variables to say goodbye

goodbye1 BYTE "Thank you for using the Negative Integer Accumulator, ",0
exclamation BYTE "!",0
goodbye2 BYTE "It was nice to meet you. Goodbye!"

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

	mov edx,OFFSET instructions1
	call WriteString
	call Crlf
	mov edx,OFFSET instructions2
	call WriteString
	call Crlf
	mov edx,OFFSET instructions3
	call WriteString
	call Crlf
	mov edx,OFFSET instructions4
	call WriteString
	call Crlf
	mov edx,OFFSET instructions5
	call WriteString
	call Crlf
	mov edx,OFFSET instructions6
	call WriteString
	call Crlf
	call Crlf

; Input collection, validation, and calculation

	INPUT:
		mov edx,OFFSET prompt
		call WriteString
		call Crlf
		call ReadInt
		mov userNumber,eax

		cmp userNumber,LOWERLIMIT
		JL INVALID

		cmp userNumber,0
		JGE CALCULATE_AVERAGE

		add sum,eax
		inc amount
		JMP INPUT

	
	INVALID:
		mov edx,OFFSET invalid1
		call WriteString
		call Crlf
		mov edx,OFFSET invalid2
		call WriteString
		call Crlf
		mov edx,OFFSET invalid3
		call WriteString
		call Crlf
		JMP INPUT

; Calculating average

	CALCULATE_AVERAGE:
		mov eax,sum
		cdq
		mov ebx,amount
		IDIV ebx
		mov average,eax
		mov remainder,edx

		mov eax,remainder
		IMUL eax,-2
		mov remainder,eax
		mov eax,remainder
		cmp eax,amount
		JLE DISPLAY
		dec average

; Displaying calculated output
	
	DISPLAY:
		call Crlf
		mov edx,OFFSET display1
		call WriteString

		mov eax,amount
		call WriteDec

		mov edx,OFFSET display2
		call WriteString
		call Crlf

		mov edx,OFFSET display3
		call WriteString

		mov eax,sum
		call WriteInt
		call Crlf

		mov edx,OFFSET display4
		call WriteString

		mov eax,average
		call WriteInt
		call Crlf
		call Crlf

; Goodbye
	
	mov edx,OFFSET goodbye1
	call WriteString
	mov edx,OFFSET userName
	call WriteString
	mov edx,OFFSET exclamation
	call WriteString

	call Crlf
	mov edx,OFFSET goodbye2
	call WriteString

	INVOKE ExitProcess,0	
main ENDP
END main