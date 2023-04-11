.data
	lfsr:			.word			0
	cards:			.word			120
	dice:			.word			120
	
	pitch: 			.word 			72
	duration: 		.word 			1000
	introMusic: 		.word 			67, 67, 67, 66, 66, 67, 67, 67, 69, 67, 67, 67, 66, 66, 67, 67, 67, 69, 64, 64, 67, 69, 69, 67

	
	welcome: 		.asciiz			"WELCOME TO ONLINE BLACKCRAPS!!!\nBY AJ RODRIGO\n"
	disclaimer:		.asciiz			"\nAre you over the legal age of 21? '0' for yes, '1' for no.\t"
	displayAgeError:	.asciiz			"\n\nUnfortunately, you have to be over the age of 21 under legal jurisdiction. Please exit now.\n\n"	
	depositFunds:		.asciiz			"\nHow much money do you wish to deposit? $"	
	successfulTransfer: 	.asciiz 		"\nYou have successfully deposited: $"
	youAreBroke: 		.asciiz 		"\nPlease deposit funds.\n"
	wagerMsg: 		.asciiz  		"\n\nPlease place down your wager(s): $"
	zeroFunds:		.asciiz			"You have run out of funds, thank you for playing!\n\n"
	goodluck: 		.asciiz 		"\nThank you, GOOD LUCK!\n\n\n"
	insufficientFunds: 	.asciiz 		"\nThe amount you wagered exceeds your balance. Please re-enter your wager."	
	hitOrStandDice:		.asciiz			"Hit or Stand? '0' for hit, '1' for stand\t"
	
	
	userCardPrint:		.asciiz			"User Card: "
	dealerCardPrint: 	.asciiz			"Dealer Card: "
	userDicePrint:		.asciiz			"User Dice: "
	dealerDicePrint: 	.asciiz			"Dealer Dice: "
	userTtl:		.asciiz			"User Total: "
	dealerTtl:		.asciiz			"\t\t\tDealer Total: " 
	userBJ:			.asciiz			"Blackcraps! You win!\n"
	dealerBJ:		.asciiz			"Dealer has Blackcraps! You lose!\n"
	tieMsg:			.asciiz			"Push!\n"
	dealerBustMsg: 		.asciiz 		"Dealer has bust, You win!\n"
	userBustMsg:		.asciiz			"Bust! Dealer wins!\n"
	dealerWinMsg:		.asciiz			"Dealer wins!\n"
	userWinnerMsg:		.asciiz			"User wins!\n"
	congratsWager:		.asciiz			"Congratulations, you won $"
	
	diceOrCards:		.asciiz			"Would you like to draw a card or roll a dice? '0' for cards, '1' for dice\t"
	hitStandPrompt:		.asciiz			"Hit or Stand? '0' for Hit, '1' for Stand\t"
	playAgain:		.asciiz			"Play again? '0' for Yes, '1' for No\t"
	
	balanceDis: 		.asciiz 		"\nBALANCE: $"
	wagerDis: 		.asciiz 		"\t\t\t\t\tWAGER: $"
	
	newLine:		.asciiz			"\n"
	space: 			.asciiz 		"\n\n"
	
################################################################################################################################################	
.text 

#This section is the first part of the project to where it welcomes the user, checks if the user is of legal age, deposits funds, checks if funds deposited is 
#reasonable, asks for a wager, and displays the stats before moving onto the next section of the project

###########################
# s2 - user funds counter #
# s3 - user wager amount  #
###########################



intro:					#Game introduction
	addi $t4, $zero, 0 
	addi $t5, $zero, 0		#Initializing temporary registers for array counter for intro song
	addi $t6, $zero, 0

	li $v0, 4
	la $a0, welcome			#Printing welcome prompt
	syscall
	
	j themeSong			#Playing sound of intro chime

disclaimerNote:
	li $v0, 4
	la $a0, disclaimer		#Printing disclaimer prompt
	syscall
	
	li $v0, 5
	syscall				#Getting user input in response to disclaimer prompt
	move $t0, $v0

		
#If(userInput != 0)
#	printf(underTwentyOne);
#	exit();
#Else
#	printf(depositFunds);
#	scanf("%d", &x);
#	
#	If(x == 0)
#		printf(youAreBroke);
#		exit();
#	Else
#		printf(success);
#		printf(" %d", x);
	
	addi $t1, $zero, 0		
	bne $t0, $t1, underTwentyOne	#If else statement checking whether user is over the legal age
	j depositingFunds	
	
underTwentyOne:				#If user is not over 21 then come to this routine, which will give user feedback and terminate
	li $v0, 4
	la $a0, displayAgeError		#Printing displayAgeError message
	syscall
	
	j end				#Terminates program
	
depositingFunds:			#If user is over the age of 21, then it will jump to this routine and skip the underTwentyOne routine
	li $v0, 4
	la $a0, depositFunds		#Printing depositFunds message
	syscall
	
	li $v0, 5
	syscall				#Getting user input for game funds
	move $s2, $v0
	
	j fundsChecker
	
fundsChecker:				#Checking funds if amount of funds entered is greater than zero
	bnez $s2, success		
	li $v0, 4
	la $a0, youAreBroke		#Printing youAreBroke message
	syscall
	j end
	
success:				#If user input was greater than zero, then come to this routine
	li $v0, 4
	la $a0, successfulTransfer	#Printing successfulTranser message
	syscall
	
	jal positiveSound		#Function for sound feedback successful deposit chime

	move $a0, $s2
	li $v0, 1			#Printing the value of the user input as confirmation
	syscall
	j wager
	
#printf(wagerMsg);
#scanf("%d", &y);
#While(x < y)
#	printf(insufficientFunds);
#printf(goodLuck);
#printf(balanceDis);
#x -= y;
#printf(" %d", &x);
#printf(wagerDis);
#printf(" %d", &y);

wager:
	li $v0, 4
	la $a0, wagerMsg		#Printing wagerMsg prompt
	syscall
	
	li $v0, 5
	syscall				#Getting user input for amount of wager to play with and move it to the saved register
	move $s3, $v0
	
	bge $s2, $s3, goodluckMessage	#Condition to check if balance is greater or equal to wager
		
	li $v0, 4
	la $a0, insufficientFunds	#Printing insufficientFunds message
	syscall
	
	jal negativeSound		#Function for sound feedback invalid wager chime
	
	j wager				#Loop until wager is within the conditions
	
goodluckMessage: 
	li $v0, 4
	la $a0, goodluck		#Printing goodLuck message as successful feedback before printing out the balanceWagerStats 
	syscall
	
balanceWagerStats:
	li $v0, 4
	la $a0, balanceDis		#Printing balanceDis message
	syscall
	
	sub $s2, $s2, $s3		#Updating balance after accepting user inputted wager
	
	move $a0, $s2
	li $v0, 1			#Printing new total balance after update
	syscall
	
	li $v0, 4
	la $a0, wagerDis		#Printing wagerDis message
	syscall
	
	move $a0, $s3
	li $v0, 1			#This will print the amount wagered 
	syscall
	
	li $v0, 4	
	la $a0, space			#Printing space for tidiness
	syscall
	
	addi $t8, $zero, 0		#Initiallizing the t8 register which will serve as the register that holds the cards pulled 

################################################################################################################################################

# 32 Bit LFSR for both cards and dice
# Partial code used from Homework 3

cardMain:
	addi $t9, $zero, 0		#Initializing t9 register that will serve as a counter to store the dice and card array with random numbers 
	la $t7, cards			#Loading address of cards to t7 register
	jal cardsFirst

cardsFirst:
	addi $sp, $sp, -4		#Multiple function calling, saving address of this function to stack
	sw $ra, 0($sp)
	addi $t1, $zero, 0
	beq $t9, 30, diceMain		#Counter condition that will populate card array with 30 numbers before populating dice array
	j lfsrNum			#LFSR function that will get random numbers

diceMain:
	addi $t5, $zero, 0x10010084	#Loading t5 with address to store the next 30 random numbers into dice array
	jal diceSecond

diceSecond: 
	addi $sp, $sp, -4		#Saving diceSecond address so that it can loop and populate dice array
	sw $ra, 0($sp)
	addi $t1, $zero, 0
	beq $t9, 60, drawingMain	#Counter condition that will populate dice array with the next 30 numbers
	j lfsrDice

lfsrDice:				#LFSR dice routine 
	la $t0, lfsr
	jal randNumGen
	beq $t1, 16, diceRoll
	j randNumGen

lfsrNum:				#LFSR card routine
	la $t0, lfsr
	jal randNumGen
	beq $t1, 16, deckOfCards


#If(a0 == 0)
#	int a0 = 0xF00F5AA5
#	lfsr[] = a0;
#int t2 = 1;
#int s0 = a0 & t2;
#int t3 = a0 << 2;
#int s1 = t3 & t2;
#int s4 = s0 ^ s1;
#int t3 = 0;
#t3 = a0 << 7;
#s1 = t3 & t2
#int s5 = s0 ^ s1;
#int s6 = s4 ^ s5;
#
#If(s6 == 0)
#	a0 << 1;
#	lfsr[] = a0;
#	t1 += 1;
#Else
#	int t4 = 0x80000000;
#	a0 << 1
#	a0 = a0 + t4;
#	lfsr[] = a0;
#	t1 += 1;

#Used from homework 3, slightly modified
randNumGen:				#Random number generator LFSR
	lw $a0, 0($t0)
	beqz $a0, initialSeedValue	#If LFSR array is not initialized, then go ahead and initialize with seed value
	
	addi $t2, $zero, 1		#Mask number one that will strip the 32nd bit
	and $s0, $a0, $t2		#Bitwise and that will get the 32nd bit and store it in s0
	
	srl $t3, $a0, 2			#Shifting LFSR array by 2 to get the 30th bit
	and $s1, $t3, $t2		
	
	xor $s4, $s0, $s1		#Bitwise XOR of the 32nd and 30th bit we had just stripped
	
	addi $t3, $zero, 0		#Resetting register
	srl $t3, $a0, 6			#Shifting to get the 26th bit of seed
	and $s0, $t3, $t2		
	
	addi $t3, $zero, 0		#Resetting register
	srl $t3, $a0, 7			#Shifting to get the 25th bit of seed
	and $s1, $t3, $t2
	
	xor $s5, $s0, $s1		#Bitwise XOR of 26th and 25th bit we had just stripped
	
	xor $s6, $s4, $s5		#Bitwise XOR of the results of XOR of 32nd and 30th bit and XOR of 25th and 26th bit
	
	beqz $s6, addingZero		#Checking if the XOR results is equal to 0, if it is then shift number once to add a zero to front
	addi $t4, $zero, 0x80000000	#Creating a mask that will add 1 to the front of the original 32 bit number
	srl $a0, $a0, 1			#Shifting by one and adding that to original number to get a one in front
	add $a0, $a0, $t4 
	sw $a0, 0($t0)
	addi $t1, $t1, 1		#Updating count
	
	jr $ra				#Jumps back to either lfsrNum or lfsrDice routine depending on what function called it
	
addingZero:				#This routine shifts 32 bit number, placing 0 in front and storing to array, and updating count
	srl $a0, $a0, 1
	sw $a0, 0($t0)
	addi $t1, $t1, 1
	
	jr $ra
	
initialSeedValue:			#Seed initializing value to this 32 bit number
	addi $a0, $zero, 0xF00F5AA5
	sw $a0, 0($t0)
	j lfsrNum
	
#DECK OF CARDS#
#int t6 = 0xF;
#t8 = lfsr[t0] & t6;
#If(t8 > 11)
#	t8 -= 4;
#	cards[t7] = t8;
#	t7 += 1;
#	t9 += 1;
#	cardsFirst();
#Else if(t8 == 0)
#	t8 += 4;
#	cards[t7] = t8;
#	t7 += 1;
#	t9 += 1;
#	cardsFirst();
#Else
#	cards[t7] = t8;
#	t7 += 1;
#	t9 += 1;
#	cardsFirst();


deckOfCards:				
	addi $t6, $zero, 0xF		#Mask that will limit numbers from 1-11 for cards
	lw $a0, 0($t0)
	and $t8, $a0, $t6		#Strips 32 bit number down to the last 4 bits
	bgt $t8, 11, subtract4		#Condition that will determine if we need to trim the number if number is over 11
	beqz $t8, add4			#If the number is 0, then we will make the number 4
	sw $t8, 0($t7)
	addi $t7, $t7, 4		#Updating array location, 4 bytes
	addi $t9, $t9, 1		#Counter for populating array
	
	lw $ra, 0($sp)			#Popping array using stack to return to function call
	addi $sp, $sp, 4
	jr $ra
	
#DECK OF DICE#
#int t6 = 0x7;
#t8 = lfsr[t0] + t6;
#If(t8 == 0)
#	t8 += 3;
#	dice[t5] = t8;
#	t5 += 1;
#	t9 += 1;
#	diceSecond();
#Else
#	dice[t5] = t8;
#	t5 += 1;
#	t9 += 1;
#	diceSecond();
	
	
diceRoll:
	addi $t6, $zero, 0x7		#Mask that will limit numbers from 1-11 for cards
	lw $a0, 0($t0)
	and $t8, $a0, $t6		#Strips 32 bit number to the last 3 bits
	beqz $t8, add3			#Conditions that checks if new number is zero, then that number will become 3
	sw $t8, 0($t5)			#Store new number to dice array
	addi $t5, $t5, 4		#Updating array location, 4 bytes
	addi $t9, $t9, 1		#Counter for populating array
	
	lw $ra, 0($sp)			#Popping array using stack to return to function call
	addi $sp, $sp, 4
	jr $ra
	
subtract4: 				#This function subtracts 4 if number is greater than 11 for cards puller, stores into cards array, updates counter				#
	sub $t8, $t8, 4			#and jumps backs to function using popping with stack
	sw $t8, 0($t7)
	addi $t7, $t7, 4
	addi $t9, $t9, 1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

add3:					#This function adds 3 to dice array if new number stripped is zero, stores into dice array, updates counter
	add $t8, $t8, 3			#and jumps backs to function using popping with stack
	sw $t8, 0($t5)   
	addi $t5, $t5, 4
	addi $t9, $t9, 1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

add4:					#This function adds 4 to cards array if new number is zero, stores into cards array, updates counter
	add $t8, $t8, 4			#and jumps backs to function using popping with stack
	sw $t8, 0($t7)
	addi $t7, $t7, 4
	addi $t9, $t9, 1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

################################################################################################################################################

###########################################
# t0 - start of card array                #
# t1 - start of dice array                #
# t6 - dealer number running total        #
# t8 - user number pulled running total   #
###########################################

drawingMain:				#Initializing some temporary registers
	addi $t0, $zero, 0
	addi $t1, $zero, 124
	addi $t3, $zero, 0
	addi $t6, $zero, 0  
	addi $t7, $zero, 0
	addi $t8, $zero, 0  
	addi $t9, $zero, 0
	
drawingGameFlowCards:			#Drawing both user and dealer cards
	jal userDrawingCards
	jal dealerDrawingCards
	j drawingGameFlowDice
	
drawingGameFlowDice:			#Drawing both user and dealer dice rolls
	beq $t3, 1, blackcrapsChecker	#Once both hands drawn, check if anyone got blackcraps
	addi $t3, $t3, 1		#Counter
	
	jal userDrawingDice		
	jal dealerDrawingDice
	j drawingGameFlowDice

userDrawingCards:
	li $v0, 4
	la $a0, userCardPrint		#Printing userCardPrint message
	syscall
	
	lw $t9, cards($t0)
	move $a0, $t9			#Loading user number to register and displaying it 
	li $v0, 1
	syscall
	
	addi $t0, $t0, 4		#Updating cards array location, 4 bytes
	
	li $v0, 4
	la $a0, newLine			#Printing newLine for tidiness
	syscall
	
	add $t8, $t8, $t9		#Loading pull into t8 which will actively keep track of user running total
	jr $ra
	
dealerDrawingCards:
	li $v0, 4
	la $a0, dealerCardPrint		#Printing dealerCardPrint message
	syscall
	
	lw $t9, cards($t0)
	move $a0, $t9			#Loading dealer number to register and displaying it 
	li $v0, 1
	syscall
	
	addi $t0, $t0, 4		#Updating cards array location, 4 bytes
	
	li $v0, 4
	la $a0, newLine			#Printing newLine for tidiness
	syscall
	
	add $t6, $t6, $t9		#Loading pull into t6 which will actively keep track of dealer running total
	jr $ra
	
userDrawingDice:
	li $v0, 4
	la $a0, userDicePrint		#Printing userDicePrint message
	syscall
	
	lw $t7, dice($t1)
	move $a0, $t7			#Loading user dice number to register and displaying it 
	li $v0, 1	
	syscall
	
	addi $t1, $t1, 4		#Updating cards array location, 4 bytes
	
	li $v0, 4
	la $a0, newLine			#Printing newLine for tidiness
	syscall
	
	add $t8, $t8, $t7		#Loading dice pull into t8 which will actively keep track of user running total
	jr $ra
	
dealerDrawingDice:
	li $v0, 4
	la $a0, dealerDicePrint		#Printing dealerDicePrint
	syscall
	
	lw $t7, dice($t1)
	move $a0, $t7			#Loading dealer dice number to register and displaying it 
	li $v0, 1
	syscall
	
	addi $t1, $t1, 4		#Updating cards array location, 4 bytes
	
	li $v0, 4
	la $a0, newLine			#Printing newLine for tidiness
	syscall
	
	add $t6, $t6, $t7		#Loading dice pull into t6 which will actively keep track of dealer running total
	jr $ra

################################################################################################################################################

#This section contains code for how game functions / game rules

#If(user == 18)
#	if(dealer == 18)
#		printf(printPush)
#	printf(userBJ)
#	t7 = s2 * 2;
#	s2 += t7;
#	printf(balanceDis);
#	printf("%d", s2);
#	printf(space);
#	goto playAgainPrompt;
#Else if(dealer == 18)
#	if(user == 18)
#		printf(printPush);
#	printf(dealerBJ)
#	printf(balanceDis);
#	printf("%d", s2);
#	printf(space);
#	goto playAgainPrompt;
#Else
#	goto hitOrStand;

blackcrapsChecker:			#Checks if either user or dealer has Blackcraps on first hand
	beq $t8, 18, userBlackcrapsPrint
	beq $t6, 18, dealerBlackcrapsPrint
	j hitOrStand

userBlackcrapsPrint:			
	beq $t6, 18, printPush		#If user has 18 and dealer has 18 on first hand, then print push
	
	li $v0, 4
	la $a0, userBJ			#Printing userBJ message
	syscall 
	
	mul  $t7, $s3, 2		#Paying out user by multiplying wager by two and adding it to the remaining balance
	add $s2, $s2, $t7
	
	li $v0, 4
	la $a0, balanceDis		#Printing balanceDis message
	syscall
	
	move $a0, $s2
	li $v0, 1			#Printing new balance after user wins
	syscall
	
	li $v0, 4
	la $a0, space			#Printing space for tidiness
	syscall
	
	j playAgainPrompt		#Loop that prompts user if he wants to play again

dealerBlackcrapsPrint:
	beq $t8, 18, printPush		#If dealer has 18 and user has 18 on first hand, then print push
	
	li $v0, 4
	la $a0, dealerBJ		#Printing dealerBJ message
	syscall 
	
	li $v0, 4
	la $a0, balanceDis		#Printing balanceDis message
	syscall
	
	move $a0, $s2
	li $v0, 1			#Printing new balance after dealer wins
	syscall
	
	li $v0, 4
	la $a0, space			#Printing space for tidiness
	syscall
	
	j playAgainPrompt		#Loop that prompts user if he wants to play again

#printPush()
#	printf(tieMsg);
#	printf(balanceDis);
#	s2 += s3;
#	printf("%d", s2);
#	printf(space);
#	goto playAgainPrompt;
#	return;

printPush:
	li $v0, 4
	la $a0, tieMsg			#Printing tieMsg
	syscall
	
	li $v0, 4
	la $a0, balanceDis		#Printing balanceDis message
	syscall
	
	add $s2, $s2, $s3
	move $a0, $s2			#Tie = no money loss, adding wager back to balance and displaying it 
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, space			#Printing space for tidiness
	syscall
	
	j playAgainPrompt		#Loop that prompts user if he wants to play again

#hitOrStand();
#	printf(space);
#	printf(userTtl);
#	printf("%d", t8);
#	printf(dealerTtl);
#	printf("%d", t6);
#	printf(space);
#	printf(hitStandPrompt);
#	scanf("%d", &t7);
#	If(t7 == 0)
#		goto userHit;
#	Else
#		goto stand;

hitOrStand:
	li $v0, 4
	la $a0, space			#Printing space for tidiness
	syscall
	
	li $v0, 4
	la $a0, userTtl			#Printing out userTtl design
	syscall
	
	move $a0, $t8
	li $v0, 1			#Printing user running total number
	syscall
	
	li $v0, 4
	la $a0, dealerTtl		#Printing dealerTtl design
	syscall
	
	move $a0, $t6
	li $v0, 1			#Printing dealer running total number
	syscall
	
	li $v0, 4
	la $a0, space			#Printing space for tidiness
	syscall
	
	li $v0, 4
	la $a0, hitStandPrompt		#Printing hitStandPrompt
	syscall
	 
	li $v0, 5
	syscall				#Getting user input whether user wants to hit or stand
	move $t7, $v0
	
	beqz $t7, userHit 		#If user inputs zero, then hit, else stand
	j stand

#userHit()
#	printf(diceOrCards);
#	scanf("%d", &t7);
#	printf(newLine);
#	If(t7 == 0)
#		userDrawingDice();
#		userBustChecker();
#		goto hitOrStand;
#	Else
#		userDrawingDice();
#		userBustChecker();
#		goto hitOrStand;

userHit: 
	li $v0, 4
	la $a0, diceOrCards		#Printing diceOrCards prompt
	syscall
	
	li $v0, 5
	syscall				#Getting user input in response to whether user would like cards to draw or dice to roll; it's your gamble
	move $t7, $v0
	
	li $v0, 4
	la $a0, newLine			#Printing newLine for tidiness
	syscall
	
	beqz $t7, userCardsOpt		#If user chooses to hit cards then go to this routine
	jal userDrawingDice		#Else user draws dice and always check after drawing whether user busts
	jal userBustChecker
	j hitOrStand			#Loop hit or stand prompt
	
userCardsOpt:				#Function that draws user cards upon request of drawing, always checks if user busts, loop hit or stand prompt
	jal userDrawingCards
	jal userBustChecker
	j hitOrStand

#If(t6 >= 13)
#	goto determineWinner;
#Else
#	printf(newLine);
#	dealerDrawingDice();
#	goto dealerBustChecker;	
			
stand:
	bge $t6, 13, determineWinner	#When you stand, check if dealer has at least a 13 before determining the winner. Dealers stands on a 13
	
	li $v0, 4
	la $a0, newLine			#Printing newLine for tidiness
	syscall	
	
	jal dealerDrawingDice		#Dealer automatically draws dice as his hit cards and followed by a dealer bust checker
	j dealerBustChecker
	
#userBustChecker()
#	int t5 = 18;
#	If(user > 18)
#		printf(userBustMsg);
#		printf(balanceDis);
#		printf("%d", s2);
#		printf(space);
#		goto playAgainPrompt;
#	return;

userBustChecker:			#Checks if user goes past 18
	addi $t5, $zero, 18
	blt $t5, $t8, displayUserBust
	jr $ra
	
#dealerBustChecker()
#	int t5 = 18;
#	If(dealer > 18)
#		printf(dealerBustMsg);
#		t7 = s3 * 2;
#		s2 += t7;
#		printf(balanceDis);
#		printf("%d", s2);
#		printf(space);
#		goto playAgainPrompt;
#	return;

		
dealerBustChecker: 			#Checks if dealer goes past 18
	addi $t5, $zero, 18
	blt $t5, $t6, displayDealerBust
	j stand

#determineWinner()
#	printf(newLine);
#	printf(space);
#	printf(userTtl);
#	printf("%d", t8);
#	printf(dealerTtl);
#	printf("%d", t6);
#	printf(space);
#	If(user > dealer)
#		printf(userWinnerMsg);
#		printf(congratsWager);
#		printf("%d", s3);
#		printf(space);
#		t7 = s3 * 2;
#		s2 += t7;
#		printf(balanceDis);
#		printf("%d", s2);
#		printf(space);
#		goto playAgainPrompt
#	Else if(dealer == user)
#		goto printPush;
#	Else
#		printf(dealerWinMsg);
#		printf(balanceDis);
#		printf("%d", s2);
#		printf(space);
#		goto playAgainPrompt;

determineWinner:			#Determining winner by comparing the dealer and user total, if they are equal, then print push
	li $v0, 4
	la $a0, newLine			#Printing newLine for tidiness
	syscall
	
	li $v0, 4
	la $a0, space			#Printing space for tidiness
	syscall
	
	li $v0, 4
	la $a0, userTtl			#Printing out userTtl design
	syscall
	
	move $a0, $t8
	li $v0, 1			#Printing user running total number
	syscall
	
	li $v0, 4
	la $a0, dealerTtl		#Printing dealerTtl design
	syscall
	
	move $a0, $t6
	li $v0, 1			#Printing dealer running total number
	syscall
	
	li $v0, 4
	la $a0, space			#Printing space for tidiness
	syscall
	
	bgt $t8, $t6, printUserWinner
	beq $t8, $t6, printPush
	
	li $v0, 4
	la $a0, dealerWinMsg		#Printing dealerWinMsg if dealer > user
	syscall
	
	li $v0, 4
	la $a0, balanceDis		#Printing balanceDis message design
	syscall
	
	move $a0, $s2
	li $v0, 1			#Printing out new balance after losing your hand
	syscall
	
	li $v0, 4
	la $a0, space			#Printing space for tidiness
	syscall
	
	j playAgainPrompt		#Loop play again prompt 
	
printUserWinner:
	li $v0, 4
	la $a0, userWinnerMsg		#Printing userWinnerMsg if user > dealer
	syscall
	
	li $v0, 4
	la $a0, congratsWager		#Printing congratsWager message
	syscall
	
	move $a0, $s3
	li $v0, 1			#Printing amount you wagered 
	syscall
	
	li $v0, 4	
	la $a0, space			#Printing out space for tidiness
	syscall
	
	mul  $t7, $s3, 2		#Paying out user by multiplying wager by two and adding it to the remaining balance
	add $s2, $s2, $t7
	
	li $v0, 4
	la $a0, balanceDis		#Printing out balanceDis message design
	syscall
	
	move $a0, $s2
	li $v0, 1			#Printing out new updated balance after user win
	syscall
	
	li $v0, 4
	la $a0, space			#Printing out space for tidiness
	syscall
	
	j playAgainPrompt		#Loop play again prompt
	
displayDealerBust:
	li $v0, 4
	la $a0, dealerBustMsg		#Printing dealerBustMsg
	syscall
	
	mul  $t7, $s3, 2		#Paying out user by multiplying wager by two and adding it to the remaining balance
	add $s2, $s2, $t7
	
	li $v0, 4
	la $a0, balanceDis		#Printing out balanceDis message design
	syscall
	
	move $a0, $s2
	li $v0, 1			#Printing out new updated balance after user win
	syscall
	
	li $v0, 4
	la $a0, space			#Printing out space for tidiness
	syscall
	
	j playAgainPrompt 		#Loop play again prompt

displayUserBust:
	li $v0, 4
	la $a0, userBustMsg		#Printing userBustMsg 
	syscall
	
	li $v0, 4
	la $a0, balanceDis		#Printing out balanceDis message design
	syscall
	
	move $a0, $s2
	li $v0, 1			#Printing out new user total after losing hand 
	syscall
	
	li $v0, 4
	la $a0, space			#Printing out space for tidiness
	syscall
	
	j playAgainPrompt 		#Loop play again prompt
	
#playAgainPrompt()	
#	If(s2 == 0)
#		printf(newLine);
#		printf(zeroFunds);
#		exit();
#	printf(playAgain);
#	scanf("%d", t7);
#	If(t7 == 0)
#		goto wager;
#	Else
#		exit();

playAgainPrompt:
	beqz $s2, youHitZero		#Checking whether your total balance is still above zero
	li $v0, 4
	la $a0, playAgain		#Printing playAgain message
	syscall
	
	li $v0, 5
	syscall				#Getting user input whether if user wants to play another game 
	move $t7, $v0
	
	beqz $t7, wager			#If user wants to play again, jump to wager to prompt process all over again
	j end				#Else terminate
	
youHitZero:
	li $v0, 4
	la $a0, newLine			#Printing newLine for tidiness
	syscall

	li $v0, 4	
	la $a0, zeroFunds		#Printing out zeroFunds message
	syscall
	
	j end				#When user has no more funds left, terminate program

################################################################################################################################################
#SOUND FX
positiveSound:
	lw $t1, pitch($zero)		#Loading integer from first element in array to temp registers
	lw $t2, duration($zero)

	li $v0, 31			#31 Syscall for sound
	la $a0, ($t1)			#Loading into a0 for pitch
	la $a1, ($t2)			#Loading into a1 for duration
	la $a2, 33			#Loading number to a2 for instrument
	la $a3, 127			#Loading number to a3 for volume
	syscall
	
	jr $ra

negativeSound:				#Same as above, but with a different instrument 
	lw $t1, pitch($zero)
	lw $t2, duration($zero)

	li $v0, 31
	la $a0, ($t1)
	la $a1, ($t2)
	la $a2, 113
	la $a3, 127
	syscall

	jr $ra
	
themeSong:				#Function plays notes in array as theme song, once it plays the array then it will continue with prompt of the game
	beq $t4, 24, disclaimerNote	

	lw $t1, introMusic($t5)
	lw $t2, duration($zero)

	li $v0, 31
	la $a0, ($t1)
	la $a1, ($t2)
	la $a2, 0
	la $a3, 127
	syscall

	addi $t4, $t4, 1		#Counter for each note 
	addi $t5, $t5, 4		#Counter for moving element in array, 4 bytes

	li $v0, 32
	addi $a0, $zero, 220
	syscall

	j themeSong

################################################################################################################################################
end: 
	jal negativeSound
	
	li $v0, 10 			#Terminating program
	syscall
	
	
