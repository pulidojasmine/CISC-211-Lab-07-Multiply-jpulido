/*** asmMult.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Jasmine Pulido"  
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

.global a_Multiplicand,b_Multiplier,rng_Error,a_Sign,b_Sign,prod_Is_Neg,a_Abs,b_Abs,init_Product,final_Product
.type a_Multiplicand,%gnu_unique_object
.type b_Multiplier,%gnu_unique_object
.type rng_Error,%gnu_unique_object
.type a_Sign,%gnu_unique_object
.type b_Sign,%gnu_unique_object
.type prod_Is_Neg,%gnu_unique_object
.type a_Abs,%gnu_unique_object
.type b_Abs,%gnu_unique_object
.type init_Product,%gnu_unique_object
.type final_Product,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmMult gets called, you must set
 * them to 0 at the start of your code!
 */
a_Multiplicand:  .word     0  
b_Multiplier:    .word     0  
rng_Error:       .word     0  
a_Sign:          .word     0  
b_Sign:          .word     0 
prod_Is_Neg:     .word     0  
a_Abs:           .word     0  
b_Abs:           .word     0 
init_Product:    .word     0
final_Product:   .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmMult
function description:
     output = asmMult ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmMult
.type asmMult,%function
asmMult:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmMult.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 8 Multiply
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    MOV R5, 0
    
    
    
    LDR R4, =b_Sign
    STR R5, [R4]
    
    LDR R6, =prod_Is_Neg
    STR R5, [R6]
    
    LDR R7, =a_Abs
    STR R5, [R7]
    
    LDR R3, =b_Abs
    STR R5, [R3]
    
    LDR R4, =init_Product
    STR R5, [R4]
    
    LDR R3, =final_Product
    STR R5, [R3]
    
    LDR R3, =a_Sign
    STR R5, [R3]
    
    LDR R2, =rng_Error
    STR R5, [R2]
    
    /* copy what's in r0 and r1 into multi-d and multi-r */
    
    LDR R0, =a_Multiplicand
    STR R0, [R0]
    
    LDR R1, =b_Multiplier
    STR R1, [R1]
    
    /* seeing if multiplier and multiplicand are in range */
    /* check if negative and store the sign bit */
    
    LDR R5, =a_Sign
    LDR R6, =b_Sign
    
    LSRS R2, R0, 15
    STR R2, [R5]
    LSLS R3, R2, 1
    LSRS R4, R3, 15
    CMP R4, 0
    BNE out_of_range
   
    LSRS R2, R1, 15
    STR R2, [R6]
    LSLS R3, R2, 1
    LSRS R4, R3, 15
    CMP R4, 0
    BNE out_of_range
   
   /* see if product will be negative or positive */
   
    LDR R4, =prod_Is_Neg
   
    CMP R5, R6
    BEQ same_sign
   
    MOV R1, 1
    B store_prod_neg
   
same_sign:
    CMP R5, 0
    BEQ zero_mult
    CMP R6, 0
    BEQ zero_mult
   
    MOV R4, 0
    B store_prod_neg
   
zero_mult:
    MOV R4, 0
   
store_prod_neg:
    STR R4, [R9]
   
    LDR R0, =a_Multiplicand
    LDR R1, [R0]             
    MOVS R2, R1, LSR 15     
    LSLS R1, R1, 1          
    SUBS R1, R1, R2          
    STR R1, [R7]            

    LDR R0, =b_Multiplier
    LDR R1, [R0]             
    MOVS R2, R1, LSR 15     
    LSLS R1, R1, 1          
    SUBS R1, R1, R2          
    STR R1, [R3]             

    
    MOV R4, 0              
    LDR R5, =a_Abs
    LDR R6, =b_Abs

multiply_loop:
    LSRS R7, R6, 1         
    BEQ multiply_skip        
    ADDS R4, R4, R5         
multiply_skip:
    LSRS R6, R6, 1          
    LSLS R5, R5, 1         
    BNE multiply_loop        

   
    LDR R0, =init_Product
    STR R4, [R0]             


    LDR R0, =prod_Is_Neg
    LDR R1, [R0]             
    CMP R1, 1               
    BEQ negate_product       

    
    B done

negate_product:
    RSBS R4, R4, 0         
    STR R4, [R0]             
    B done

    
out_of_range: 
    LDR R5, =rng_Error
    MOV R3, 1
    STR R3, [R0]
    MOV R0, 0
    B done
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmMult return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




