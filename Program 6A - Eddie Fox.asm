TITLE Program 6A     (Program 6A - Eddie Fox.asm)

;     Name: Eddie C. Fox
;     OSU e-mail address: foxed@oregonstate.edu
;     Class number and section: CS271-400
;     Assignment Number: 6
;     Due date: June 5, 2016 at midnight pacific time.
;     Description:  This program asks the user to enter
;                   10 unsigned decimal integers. Validation
;                   is performed, and the integers are summed up.
;                   All the valid, accepted numbers are displayed,
;                   as well as the sum and a calcualted average
;                   that is rounded down to the nearest integer.


INCLUDE Irvine32.inc

; Global strings and constants stored below.

.data

; Strings for introduction

introduction1 BYTE "Desinging low-level I/O procedures",0
introduction2 BYTE "Assignment #6A, programmed by Eddie C. Fox",0
introduction3 BYTE "Please enter 10 unsigned decimal integers.",0
introduction4 BYTE "These numbers must be small enough to fit inside a 32 bit register.",0
introduction5 BYTE "A list of the integers, their sum, and the average will be displayed.",0


; Strings for prompting user and getting user data

prompt1 BYTE "Please enter a 32 bit unsigned decimal integer.",0
invalid BYTE "The number you entered is out of range, or not a number. Please try again.",0


; Strings for displaying array of accepted integers

display1 BYTE "The numbers you entered are: ",0
sum1 BYTE "The sum of all these numbers is: ",0
average1 BYTE "The average of all these numbers is: ",0
bye BYTE "Thank you for playing! Bye!",0

.code

main PROC

.data

; ExitProcess prototype.

ExitProcess PROTO, dwExitCode:DWORD

; array

numberArray DWORD 10 DUP(?)

; sum and average variables

sum DWORD 0
average DWORD ?

.code
	
	CALL displayIntroduction

	push OFFSET numberArray
	push OFFSET average
	push OFFSET sum
	call getValues

	push OFFSET numberArray
	push OFFSET average
	push OFFSET sum
	call displayValues

	INVOKE ExitProcess,0 ; Put a breakpoint here if grading	
main ENDP

;--------------------------------
displayString MACRO stringAddress
; Description: Displays a string. 
; Recieves: OFFSET of a string variable.
; Returns: Nothing.
; Prediconditions: displayString must be provided the OFFSET of a string variable.
; Registers changed: None. EDX is changed, but pushed and popped properly, so there is no change
; after the macro from the original format.
;--------------------------------

	push edx
	mov edx,stringAddress
	call WriteString
	pop edx

ENDM

;--------------------------------
getString MACRO stringAddress, size
; Description: Reads a string. 
; Recieves: OFFSET of a string variable. size of string variable. 
; Returns: Nothing.
; Prediconditions: getString must be provided with the OFFSET of a string variable and the SIZEOF
; the string variable. Not LENGTHOF, because SIZEOF accounts for the NULL terminator. 
; Registers changed: None, due to proper pushing and popping.
;--------------------------------

	push edx
	push ecx
	push eax

	mov edx,stringAddress
	mov ecx,(size)
	call ReadString

	pop eax
	pop ecx
	pop edx

ENDM	

;--------------------------------
displayIntroduction PROC
; Description: Displays the introduction to the program. This consists of programmer name,
; program title, and a basic introduction to the program.
; Recieves: OFFSET's of global string variables. No parameters actually passed.
; Returns: Nothing
; Prediconditions: None technically, but should only be called at the beginning of the program.
; Registers changed: EDX will be pushed before the procedure modifies it and popped when done, so
; none of the registers will be changed from their value before they are called.
;--------------------------------
	
	displayString OFFSET introduction1
	call Crlf

	displayString OFFSET introduction2
	call Crlf
	call Crlf

	displayString OFFSET introduction3
	call Crlf

	displayString OFFSET introduction4
	call Crlf

	displayString OFFSET introduction5
	call Crlf
	call Crlf

	ret

displayIntroduction ENDP

;--------------------------------
readVal PROC
; Description: Reads string from the user. Verifies their input to ensure it is a number no larger than
; that which can fit in a 32 bit register. Converts the string to a number, and then stores it in the DWORD
; variable passed to it.
; Recieves: OFFSET of string variable that the result of reading the users input will be stored in. size of
; string variable. OFFSET of DWORD variable that the numeric conversion of the users input will be stored.
; Also recieves the OFFSET of array to store the converted strings in. 
; Returns: Modifies string variable passed to it, and DWORD variable passed to it. 
; Prediconditions: Before being called, arguments must be pushed in the following order: OFFSET of string variable,
; size of string variable, OFFSET of DWORD variable.  
; Registers changed: No registers changed due to proper popping and pushing. 
;--------------------------------

; Stack in this procedure
; All PUSHAD registers
; EBP = Base Pointer
; [EBP + 4] = Return Address
; [EBP + 8] = OFFSET DWORD variable
; [EBP + 12] = Size of string variable
; [EBP + 16] = OFFSET string variable 

.data 

accumulator DWORD 0

.code

	push ebp
	mov ebp,esp

	pushad

	displayString OFFSET prompt1
	call Crlf

	BEGINNING:

		getString [EBP + 16], [EBP + 12]
		call Crlf
		
		mov eax,0
		mov ebx,10
		mov ecx,0
		mov esi, [EBP + 16]
		
		cld

	LOAD_CHAR:
		lodsb
		cmp al,0
		JE DONE

		cmp al,48
		jb NOT_VALID
		cmp al,57
		ja NOT_VALID

		sub al,48
		xchg eax,accumulator
		mul ebx
		JC NOT_VALID
		JMP VALID


	NOT_VALID:
		displayString OFFSET invalid
		call Crlf
		mov accumulator,0
		JMP BEGINNING

	VALID:
		add eax,accumulator
		xchg eax,accumulator
		JMP LOAD_CHAR
	
	DONE:

		mov eax,accumulator
		mov accumulator,0
		mov edi,[EBP + 8]
		mov [edi],eax
	
		popad
		pop ebp

	ret 12

readVal ENDP

;--------------------------------
getValues PROC
; Description: In a loop: Calls readVal. Takes result, adds to the sum variable. Stores result of readVal
; and stores it in the array. 
; Recieves: OFFSET of array to store readVal results in. Also recieves OFFSET of variables to store
; sum and average in . 
; Returns: Modifies string variable passed to it, and DWORD variable apssed ot it. 
; Prediconditions: Before being called, arguments must be pushed in the following order: OFFSET of array,
; OFFSET of average, OFFSET of sum.
; Registers changed: No register changed due to proper popping and pushing. 
;--------------------------------

; Stack in this procedure
; All PUSHAD registers
; EBP = Base Pointer
; [EBP + 4] = Return Address
; [EBP + 8] = OFFSET of Sum
; [EBP + 12] = OFFSET of Average
; [EBP + 16] = OFFSET of array

.data

buffer BYTE 255 DUP(?)
testString BYTE "The value recieved from readVal is: ",0
value DWORD ?

.code

	push ebp
	mov ebp,esp

	pushad

	mov ebx, [EBP + 8]
	mov ecx,10
	mov edi, [EBP + 16]
	
	START:
		push OFFSET buffer
		push SIZEOF buffer
		push OFFSET value

		CALL readVal

		cld
		mov eax,value
		add [ebx],eax
		stosd
		loop START

	CALCULATE:

; This section got a bit confusing for me, so my comments were more for me than any grader.

		push ebx            ; Save the value of ebx, which has both the contents and value of sum. 

		mov eax,[ebx]       ; Move the value of sum into eax
		mov ebx,10          ; Move 10 into ebx
		mov ecx,[EBP + 12]  ; Move the offset of average into ecx
		mov edx,0           ; Move 0 into edx for proper division.
		
		div ebx             ; Divide eax, which holds the value of sum, by 10, leaving eax with the value of average.
		mov [ecx],eax       ; Move eax, which has the value of average into ecx, which has the contents of average
		

		pop ebx             ; Restores the value of ebx, which has the contents and value of sum. 

; In the end, eax has the value and contents of sum, and ebx has the value and contents of average.
	
	popad
	pop ebp

	ret 12

getValues ENDP

;--------------------------------
writeVal PROC
; Description: In a loop: Takes number argument and converts to string, storing it in the string variable argument.
; Then uses the displayString macro to output the string to console. 
; Recieves: OFFSET of string variable to store converted string in. Integer to convert.
; Returns: Doesn't return anything, but outputs a converted number to console.
; Prediconditions: Before being called, arguments must be pushed in the following order: OFFSET of string variable, OFFSET of unsigned integer.
; Registers changed: No register changed due to proper popping and pushing. 
;--------------------------------

; Stack in this procedure
; All PUSHAD registers
; EBP = Base Pointer
; [EBP + 4] = Return Address
; [EBP + 8] = Integer
; [EBP + 12] = Offset of string variable to store conversion in.

.data

tempString BYTE 12 DUP(?)

; All the values in tempString need to be reset at the end of every pass or errors ensue. 

.code

	push ebp
	mov ebp,esp

	pushad

	
	mov eax,[EBP + 8]
	mov ebx,10
	mov ecx,0

	mov edi,[EBP + 12]

	cld

	
	CONVERT:
		mov edx,0
		div ebx
		xchg eax,edx
		add eax,48
		stosb
		inc ecx
		xchg eax,edx
		cmp eax,0
		jne CONVERT
	
	mov esi,[EBP + 12]
	add esi,ecx
	dec esi
	mov edi, OFFSET tempString

	REVERSE:

; The following code was inspired by demo6.asm

		std
		lodsb
		cld
		stosb
		loop REVERSE
		
	
	DONE:
		
		displayString OFFSET tempString

		mov eax,0
		mov ecx, SIZEOF tempString
		mov edi, OFFSET tempString
		cld
		rep stosb
		
		popad
		pop ebp

		ret 8

writeVal ENDP

;--------------------------------
displayValues PROC
; Description: In a loop: Loads value from numbers array. Calls writeVal to convert to string and print number.
; Displays array, displays passed sum and average variables. 
; Recieves: OFFSET of array of numbers. Also recieves offset of average and sum.
; Returns: Doesn't return anything, but prints a lot of stuff.
; Prediconditions: Before being called, arguments must be pushed in the following order: OFFSET of array,
; OFFSET of average, OFFSET of sum.
; Registers changed: No register changed due to proper popping and pushing. 
;--------------------------------

; Stack in this procedure
; All PUSHAD registers
; EBP = Base Pointer
; [EBP + 4] = Return Address
; [EBP + 8] = OFFSET Sum
; [EBP + 12] = OFFSET Average
; [EBP + 16] = OFFSET of array with numbers

.data
temporaryString BYTE 10 DUP(?)

.code
	push ebp
	mov ebp,esp

	pushad

	mov esi,[EBP + 16]
	mov ecx,10

	displayString OFFSET display1
	call Crlf
	call Crlf

	DISPLAY_ARRAY:
		lodsd
		push OFFSET temporaryString
		push eax
		call writeVal
		call Crlf
		loop DISPLAY_ARRAY

	call Crlf

	displayString OFFSET sum1
	mov eax,[EBP + 8]
	push OFFSET temporaryString
	push [eax]
	call writeVal
	call Crlf

	displayString OFFSET average1
	mov eax,[EBP + 12]
	push OFFSET temporaryString
	push [eax]
	call writeVal

	call Crlf
	call Crlf
	displayString OFFSET bye

	popad
	pop ebp

	ret 12

displayValues ENDP


END main