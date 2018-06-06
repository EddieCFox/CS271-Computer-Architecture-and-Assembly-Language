TITLE Program 5     (Program 5 - Eddie Fox.asm)

;     Name: Eddie C. Fox
;     OSU e-mail address: foxed@oregonstate.edu
;     Class number and section: CS271-400
;     Assignment Number: 5
;     Due date: May 23, 2016 at midnight pacific time.
;     Description:  This program generates a number of
;                   random numbers equal to a user provided
;                   number. They are stored in an array and 
;                   displayed 10 at a time. They are sorted
;                   in descending order and re-displayed.
;                   Finally, the median is calculated and displayed.

INCLUDE Irvine32.inc

; Global strings and constants stored below.

.data

; Constants

MIN = 10   ; Minimum number user can enter. Minimum amount of random numbers.
MAX = 200  ; Maximum number user can enter. Maximum amount of random numbers.
LO = 100   ; Lowest value that a randomized number can have.
HI = 999   ; Highest value that a randomized number can have.

; Strings for introduction

introduction1 BYTE "Random Number Generator and Sorter.",0
introduction2 BYTE "Assignment #5, programmed by Eddie C. Fox",0
introduction3 BYTE "This program randomly generates numbers between 100 and 999.",0
introduction4 BYTE "These numbers will be displayed, then sorted in descending order.",0
introduction5 BYTE "The median will be calculated, and finally, the sorted list",0
introduction6 BYTE "will be displayed.",0


; Strings for prompting user and getting user data

prompt1 BYTE "Please enter an integer between 10 and 200.",0
prompt2 BYTE "That many random numbers will be generated.",0
invalid BYTE "The number you entered is out of range, or not a number. Please try again.",0
validInput BYTE "Input validated and recieved. Numbers will be generated and displayed.",0
validInput2 BYTE "The number that was accepted is ",0

; Strings for displaying array of random numbers

space BYTE ", ",0
displayUnsorted BYTE "Here are the unsorted randomized numbers:",0
displaySorted BYTE "Here are the sorted randomized numbers:",0

; String for displaying the median

displayMedian BYTE "The median of the sorted list is: ",0

.code

main PROC

.data

; ExitProcess prototype.

ExitProcess PROTO, dwExitCode:DWORD

; request and array

request DWORD ?
numberArray DWORD MAX DUP(?)

.code
	CALL Randomize ; calling Randomize once at the beginning of the program to seed the RNG properly.

	CALL displayIntroduction

	push OFFSET request
	CALL getData

	mov eax,request
	mov edx,OFFSET validInput2
	call WriteString
	call WriteDec
	call Crlf
	call Crlf

	push OFFSET numberArray
	push request
	call fillArray

	push OFFSET numberArray
	push OFFSET displayUnsorted
	push request
	call displayList

	push OFFSET numberArray
	push request
	call sortList

	push OFFSET numberArray
	push OFFSET displaySorted
	push request
	call displayList

	push OFFSET numberArray
	push request
	call median

	INVOKE ExitProcess,0 ; Put a breakpoint here if grading	
main ENDP

;--------------------------------
displayIntroduction PROC
; Description: Displays the introduction to the program. This consists of programmer name,
; program title, and a basic introduction to the program.
; Recieves: Nothing
; Returns: Nothing
; Prediconditions: None technically, but should only be called at the beginning of the program.
; Registers changed: EDX will have the OFFSET of introduction6 after execution is finished.
;--------------------------------
	mov edx,OFFSET introduction1
	call WriteString
	call Crlf

	mov edx,OFFSET introduction2
	call WriteString
	call Crlf
	call Crlf

	mov edx,OFFSET introduction3
	call WriteString
	call Crlf

	mov edx,OFFSET introduction4
	call WriteString
	call Crlf

	mov edx,OFFSET introduction5
	call WriteString
	call Crlf

	mov edx,OFFSET introduction6
	call WriteString
	call Crlf
	call Crlf
	ret
displayIntroduction ENDP

;--------------------------------
getData PROC
; Description: Prompts user to enter number between 10 and 200, and reads their input.
; This input is validated.
; Recieves: request (by reference)
; Returns: request (by reference)
; Prediconditions: OFFSET of request must be pushed before calling this function.
; Registers changed: EDI changed to OFFSET request and [EDI] is request,
; the doubleword from main.
;--------------------------------

; Stack in this procedure:
; EBP = Base pointer
; [EBP + 4] = Return address
; [EBP + 8] = OFFSET request (passed by reference)

	push ebp
	mov ebp, esp

	mov edx,OFFSET prompt1
	call WriteString
	call Crlf
	mov edx,OFFSET prompt2
	call WriteString
	call Crlf
	call Crlf

; Reading input
	
	READ:
		mov edx,OFFSET prompt1
		call WriteString
		call Crlf
		call ReadDec

; Valid input to ensure it is inside range by comparing to 10 and 200.
	
		cmp eax,MIN
		JB NOT_VALID

		cmp eax,MAX
		JA NOT_VALID
		JMP VALID

	NOT_VALID:
		mov edx,OFFSET invalid
		call Crlf
		call WriteString
		call Crlf
		JMP READ

	VALID:
		mov edx,OFFSET validInput
		call Crlf
		call WriteString
		call Crlf
		call Crlf

		mov edi, [ebp+8]
		mov [edi],eax
	
	pop ebp
	ret 4;

getData ENDP

;--------------------------------
fillArray PROC
; Description: Fills the array with randomized numbers between 100 and 999.
; Recieves: request (by value), numberArray (by reference)
; Returns: Modifies numberArray.
; Prediconditions: Before calling the function, you must push the OFFSET of the array,
; then push the request variable in that order. Count must be initialized and in the 
; proper range.
; Registers changed: [EDI] is the array filled with randomized doublenumbers between 100 and 999.
; ECX changed to request. EAX changed to range.
;-------------------------------

; Stack in this procedure:
; EBP = Base pointer
; [EBP + 4] = Return address
; [EBP + 8] = request (passed by value)
; [EBP + 12] = OFFSET numberArray

	push ebp
	mov ebp, esp

	mov ecx,[ebp + 8] 
	mov edi,[ebp + 12]

	mov edx,HI
	sub edx,LO
	inc edx
	cld
	

	ADD_NUMBER:	
		mov eax,edx
		call RandomRange
		add eax,LO
		stosd
		loop ADD_NUMBER

	pop ebp

	ret 8

fillArray ENDP

;--------------------------------
displayList PROC
; Description: Displays the array's. This code was inspired by the PrintArray
; example shown on Page 381.
; Recieves: request (by value), numberArray (by reference), title (by reference)
; Returns: Prints the array.
; Prediconditions: Before calling the function, you must push the OFFSET of the array,
; OFFSET of the string identifying the displayList, and request, in that order. 
; Count must be initialized and in the 
; proper range.
; Registers changed: EAX, EBX, ECX, EDX, ESI
;-------------------------------

.data
printCount DWORD 0

.code 
; Stack in this procedure:
; EBP = Base pointer
; [EBP + 4] = Return address
; [EBP + 8] = request
; [EBP + 12] = OFFSET displayUnsorted / OFFSET displaySorted
; [EBP + 16] = OFFSET numberArray

	push ebp
	mov ebp,esp

	mov edx,[EBP + 12]
	call WriteString
	call Crlf
	call Crlf

	mov ecx,[EBP + 8]
	mov esi,[EBP + 16]
	cld

	PRINT_NUMBER:
		lodsd
		call WriteDec
		mov edx,OFFSET space
		call WriteString
		inc printCount
		mov eax,printCount
		mov edx,0
		mov ebx,10
		div ebx
		cmp edx,0
		JE NEW_LINE
	
	NEXT_NUMBER:
		loop PRINT_NUMBER
		JMP END_OF_LOOP

	NEW_LINE:
		call Crlf
		JMP NEXT_NUMBER

	END_OF_LOOP:
		pop ebp
		call Crlf
		mov printCount,0
		ret 12	

displayList ENDP

;--------------------------------
sortList PROC
; Description: Sorts the array in descending order (from largest to smallest). This
; function uses bubble sort, heavily drawn from the book, Page 375 which details the
; Bubble Sort algorithm. I modified it so that it would sort by descending order rather
; than ascending order. I considered using selection sort, but realized it had no 
; efficency advantages, as both were complexity O(n^2).
; Recieves: request (by value), numberArray (by reference)
; Returns: Nothing, but prints array.
; Prediconditions: Before calling the function, you must push the OFFSET of the array,
; and request, in that order. Count must be initialized and in the proper range.
; Registers changed: Write here later.
;-------------------------------

; Stack in this procedure:
; EBP = Base pointer
; [EBP + 4] = Return address
; [EBP + 8] = request (passed by value)
; [EBP + 12] = OFFSET numberArray

	push ebp
	mov ebp,esp

	mov ecx,[EBP + 8]
	dec ecx

	L1:
		push ecx
		mov esi,[EBP + 12]

	L2:
		mov eax,[esi]
		cmp [esi + 4],eax
		JB L3
		xchg eax,[esi + 4]
		mov [esi],eax

	L3:
		add esi,4
		loop L2

		pop ecx
		loop L1

	L4:
		pop ebp
		ret 8

sortList ENDP

;--------------------------------
median PROC
; Description: Calculates and displays the median of a sorted array of numbers. If,
; the array is of odd size, the median is the value at the middle of the array.
; If the array is of odd size, the median is the value of the two middle elements,
; rounded. The median is correct for odd numbers, but I couldn't get it correct for
; even numbers in time. Even is almost correct.
; Recieves: request (by value), numberArray (by reference)
; Returns: 
; Prediconditions: Before calling the function, you must push the OFFSET of the array,
; and request, in that order. Count must be initialized and in the proper range.
; Registers changed: ESI, EAX, ECX
;-------------------------------

.data
halfSize DWORD ?
leftIndex DWORD ?
rightIndex DWORD ?

leftNumber DWORD ?
rightNumber DWORD ?

average DWORD ?
averageRemainder DWORD ?

; Stack in this procedure:
; EBP = Base pointer
; [EBP + 4] = Return address
; [EBP + 8] = request (passed by value)
; [EBP + 12] = OFFSET numberArray

.code
	push ebp
	mov ebp,esp

	mov eax,[EBP + 8]
	mov esi, [EBP + 12]
	mov edi,[EBP + 12]
	mov ebx,2
	mov edx,0
	div ebx

	mov halfSize,eax

	cmp edx,0
	JE EVEN_SIZE

	mov eax,halfSize
	mov ebx,4
	mul ebx
	add esi,eax
	mov eax,[esi]
	mov average,eax

	JMP DISPLAY
	

	EVEN_SIZE:

	mov eax,halfSize
	mov leftIndex,eax
	mov rightIndex,eax
	dec leftIndex
	inc rightIndex

	mov eax,leftIndex
	mov ebx,4
	mul ebx

	add esi,eax
	mov eax,[esi]
	mov leftNumber,eax

	mov eax,rightIndex
	mov ebx,4
	mul ebx

	add edi,eax
	mov eax,[edi]
	mov rightNumber,eax

	mov eax,leftNumber
	mov average,eax
	mov eax,rightNumber
	add average,eax

	mov eax,average
	mov ebx,2
	mov edx,0
	div ebx
	mov average,eax
	
	
	DISPLAY:
		call Crlf
		mov edx,OFFSET displayMedian
		call WriteString
		mov eax,average
		call WriteDec

		pop ebp
		ret 8

median ENDP
END main