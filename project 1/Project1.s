ldr r0,=textfile    @load in the file named textfile defined in the bottom

swi 0x66    @Open file
bcs FileMissing @In case of a missing file it branches and reports a missing file

mov r9,r0	@move the file handle and save it to r9

swi 0x6c	@Read integers from file
bcs FileEmpty   @If the file is empty it branches to FileEmpty and reports file is empty

mov r4,r0   @move first int read from file to r4



cmp r0,r5   @compares the first integer against 0 and puts r0 in r5
    mov r5,r0

add r6,r6,#1    @r6 keeps count of numbers in the file



@ r4 = first int
@ r5 = biggest value
@ r6 = keeps count
@ r7 = counts less than first int


RLoop:

    mov r0,r9   @recall filehandle
    swi 0x6c    @Read int from  file
    bcs Exit    @if the carry bit is set to one then the end of the file has been reached and it will skip to Exit branch
    add r6,r6,#1    @r6 keeps count of the numbers in the file
    cmp r0,r4   @compare r0 and r4 and if r4 is less than first int add one to r7.
        addlt r7,r7,#1    @r7 keeps track of the amount of numbers less than first number
    cmp r0,r5   @compare r0 and r5 and if r0 is bigger put r0 in r5. Keeps track of the biggest number in the file. 
        movgt r5,r0   @r5 keeps track of the biggest int


b RLoop @start over again at RLoop


Exit:

    mov r1,r0   @put the int from r0 to r1 to empty r0

    mov r0,#1

    @block that prints out the first int
    ldr r1,=firstInt    @load the String variable firstInt into r1 
    swi 0x69    @prints out string in firstInt
    mov r1,r4   @puts first int in r0 to get ready to print
    swi 0x6b    @print whatever thats in r1
    ldr r1,=NL  @puts new line in r1
    swi 0x69    @prints out new line

    @block that prints out the biggest int
    ldr r1,=BiggestVal
    swi 0x69    
    mov r1,r5   
    swi 0x6b    
    ldr r1,=NL  
    swi 0x69  

    @block that prints out the values less than first int
    ldr r1,=lessThanFirst
    swi 0x69
    mov r1,r7
    swi 0x6b
    ldr r1,=NL
    swi 0x69

    @block that prints out the count
    ldr r1,=count
    swi 0x69
    mov r1,r6
    swi 0x6b
    ldr r1,=NL
    swi 0x69

    b Done


@If the file is missing this branch is executed and reports the file is missing then goes to done branch
FileMissing:
    mov r0,#1
    ldr r1,=MissingFile
    swi 0x69

    b Done

@If the file is empty this branch is executed and it reports the file is empty and then goes to done branch
FileEmpty:
    mov r0,#1
    ldr r1,=EmptyFile
    swi 0x69
    
    b Done

@Branch of Done that will run at the end
Done:
    mov r0,r9   @move the file handle back to r0
    swi 0x68	@ close file with r0
    swi 0x11    @ends program










.data
textfile: .ASCIZ "integers.dat" @put the file into memory
firstInt: .ASCIZ "The first integer in the file is: "
NL: .ASCIZ "\n"
BiggestVal: .ASCIZ  "The greatest value in the file is: "
lessThanFirst: .ASCIZ "The amount of numbers less than the first number in the file is: "
count: .ASCIZ "The amount of numbers in the file is: "
MissingFile: .ASCIZ "The File is missing"
EmptyFile: .ASCIZ "The File is Empty"