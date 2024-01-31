# cut from div32.asm
.text
.globl main

main:
    li      $a0,   1   
    jal     comp64        # a2a0 ��=> a2a0   ��ߵ�a2����0
    la      $a3,   msg1
    li      $v1,   0
    jal     disp_adc64    # a3 - address of msg $v1(��λ), $a2$a0 - 64bit

    li      $a0,   0xC01830F1    
    jal     comp64        # a2a0 ��=> a2a0   ��ߵ�a2����0
    la      $a3,   msg2
    li      $v1,   0
    jal     disp_adc64    # a3 - address of msg $v1(��λ), $a2$a0 - 64bit
        
    li      $v0,   1
    li      $v1,   1
    li      $a1,   0xC01830F1
    li      $a0,   0xA01830F2  
    jal     sbc32                # $v1$a1 - $a0 - $v0 => $v0($v1�����λ)����ߵ�v1��v0ȡֵ0��1
    la      $a2,   msg3
    move    $a1,   $v1
    move    $a0,   $v0
    jal     disp_adc32
    
    li      $v0,   1
    li      $v1,   0
    li      $a1,   0xC01830F2
    li      $a0,   0xE01830F1  
    jal     sbc32                # $v1$a1 - $a0 - $v0 => $v0($v1�����λ)����ߵ�v1��v0ȡֵ0��1
    la      $a2,   msg4
    move    $a1,   $v1
    move    $a0,   $v0
    jal     disp_adc32           # $a2 - address of msg $a1- carry bit a0 - 32bits
    
    li      $a0,   0x701830F1
    li      $v0,   0
    jal     sll32                #   $a0 + $v0(����λ) ����1λ=> $v0(�Ƴ�λ) + $a0    $v0Ϊ0��1
    la      $a2,   msg5
    move    $a1,   $v0
    jal     disp_adc32           # $a2 - address of msg $a1- carry bit a0 - 32bits

    li      $a0,   0xC01830F1
    li      $v0,   1
    jal     sll32                 #   $a0 + $v0(����λ) ����1λ=> $v0(�Ƴ�λ) + $a0    $v0Ϊ0��1
    la      $a2,   msg6
    move    $a1,   $v0
    jal     disp_adc32            # $a2 - address of msg $a1- carry bit a0 - 32bits
        
    li      $a0,   0xC01830F1
    li      $a1,   0xC01830F1    
    li      $v0,   0
    jal     sll64                 #  $a1$a0 + $v0(����λ) ����1λ=> $v0(�Ƴ�λ) + $a1$a0  $v0Ϊ0��1
    la      $a3,   msg7
    move    $a2,   $a1
    move    $v1,   $v0
    jal     disp_adc64             # a3 - address of msg $v1(��λ), $a2$a0 - 64bit
    
    li      $a0,   0xC01830F0 
    li      $a1,   0x701830F1    
    li      $v0,   1
    jal     sll64                  #  $a1$a0 + $v0(����λ) ����1λ=> $v0(�Ƴ�λ) + $a1$a0  $v0Ϊ0��1
    la      $a3,   msg8
    move    $a2,   $a1
    move    $v1,   $v0
    jal     disp_adc64             # a3 - address of msg $v1(��λ), $a2$a0 - 64bit
            
    li      $a0,   0x123430F1
    li      $a1,   0xC01830F3
    li      $v0,   0
    jal     div32                    # $a1 / $a0 => $a1-remainer $a0-quotient  
    la      $a3,   msg9
    move    $a2,   $a1
    li      $v1,   0
    jal     disp_adc64              # a3 - address of msg $v1(��λ), $a2$a0 - 64bit

    li      $a0,   0xC01830F3
    li      $a1,   0x123430F1
    li      $v0,   0
    jal     div32                   # $a1 / $a0 => $a1-remainer $a0-quotient  
    la      $a3,   msg10
    move    $a2,   $a1
    li      $v1,   0
    jal     disp_adc64             # a3 - address of msg $v1(��λ), $a2$a0 - 64bit
    
    li      $v0,    10               # ����ϵͳ
    syscall

  #   a2a0 ��=>  a2a0   ��ߵ�a2����0
comp64:
    #... 
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    addi $t0, $zero, 0xffffffff
    move $a2, $zero
    sub $a2, $t0, $a2
    sub $a0, $t0, $a0
    move $a3, $zero
    addi $a1, $zero, 1
    move $v1, $zero
    move $v0, $zero
    jal adc64
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
#   $v1$a1 - $a0 - $v0 => $v0($v1�����λ)����ߵ�v1��v0ȡֵ0��1
sbc32: 
    addi $sp,$sp,-12
    sw $ra,0($sp)
    addu $a0,$a0,$v0
    sltu $s0,$a1,$a0
    sw $a1, 4($sp)
    sw $v1, 8($sp)
    move $s1, $v1
    jal comp64    
    or $v1,$s0,$s1
    lw $a1, 4($sp)
    addu $v0,$a0,$a1
    lw $ra,0($sp)
    addi $sp,$sp,12
    jr $ra 

 
#   $a0 + $v0(����λ) ����1λ=> $v0(�Ƴ�λ) + $a0    $v0Ϊ0��1
sll32:
    #...
    addi $t0, $zero, 1
    sll $t0, $t0, 31
    and $t0, $t0, $a0
    srl $t0, $t0, 31
    sll $a0, $a0, 1
    or $a0, $a0, $v0
    move $v0, $t0
    jr $ra

#  $a1$a0 + $v0(����λ) ����1λ=> $v0(�Ƴ�λ) + $a1$a0  $v0Ϊ0��1
sll64: 
    # ...
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    jal sll32
    sw $a0, 4($sp)
    move $a0, $a1
    jal sll32
    move $a1, $a0
    lw $a0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

#   $v0(����λ) + $a1$a0 һ������=> $a1$a0 + $v0(�Ƴ�λ)
srl64: 
   # ...
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    move $a0, $a1
    jal srl32
    move $a1, $a0
    lw $a0, 4($sp)
    jal srl32
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra
#   $v0(����λ) + $a0 һ������1λ=> $a0 + $v0(�Ƴ�λ)
srl32: 
    #  ...
    addi $sp, $sp, -4
    andi $t0, $a0, 1
    sw $t0, 0($sp)
    sll $v0, $v0, 31
    srl $a0, $a0, 1
    or $a0, $a0, $v0
    lw $v0, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
# $a1 / $a0 => $a1-remainer $a0-quotient  
#$v1$a1 - $a0 - $v0 => $v0($v1�����λ)����ߵ�v1��v0ȡֵ0��1
div32:    
    move $s2,$zero #��������ʼֵΪ0
    addi $sp,$sp,-4
    sw $ra,0($sp)   
    move $t9,$a1    
    move $t8,$a0    
    move $a0,$a1     
    move $a1,$zero
    
loop:
    li $v0,0     
    li $v1,0
    jal sll64
    move $t7,$a1
    move $v1,$zero
    move $t5,$a0
    move $a0,$t8
    jal sbc32
    #subu $v0,$a1,$a0
    move $a1,$v0
    move $v0,$zero
    move $a0,$t5
    xor $v1,$v1,1
    addu $a0,$a0,$v1
    bne $v1,$zero,next
    move $a1,$t7
next:
    addi $s2,$s2,1
    slti $t0,$s2,32
    bne $t0,$zero,loop
    lw $ra,0($sp)
    addi $sp,$sp,4
    jr $ra 

 


#  $v1(��λ) + $a3$a1 + $a2$a0 = $v1(��λ) + $a2$a0 
adc64:
   #...
   addi $sp, $sp, -8
   sw $ra, 0($sp)
   jal adc32
   sw $v0, 4($sp)
   move $a1, $a3
   move $a0, $a2
   jal adc32 
   move $a2, $v0
   lw $a0, 4($sp)
   
   lw $ra, 0($sp)
   addi $sp, $sp, 8
   jr   $ra    
   

#  $v1(��λ) + $a1 + $a0 = $v1(��λ) + $v0 
adc32: 
    #...
    addu $v0, $a0, $a1
    sltu $t3, $v0, $a0
    sltu $t4, $v0, $a1
    addu $v0, $v0, $v1
    addi $t2, $zero, 2
    add $t3, $t3, $t4
    beq $t3, $t2 set
    j set_exit
set:
    addi $v1, $zero, 1
    j return
set_exit:
    addi $v1, $zero, 0
return:
    jr $ra 
 
# $a2 - address of msg $a1- carry bit a0 - 32bits
disp_adc32:
    move    $t0,  $a0
    move    $t1,  $a1
    move    $t2,  $a2
    
    li      $v0,   4                 # ��ӡ�ַ���(���ܺţ�4)
    move    $a0,   $t2               # ȡ�ַ����׵�ַ
    syscall                          # ϵͳ����
    
    li      $v0,    1                # ��ӡʮ��������
    move    $a0,    $t1              # �����λλ
    syscall                          # ϵͳ����
    
    li      $v0,    4                # ��ӡ�ַ���(���ܺţ�4)
    la      $a0,    space            # ����ո�" "          
    syscall
    
    li      $v0,    34               # ��ӡ16�������������һ����
    move    $a0,    $t0              # ����������ݱ��浽$a0��Ϊ�����׼��
    syscall 
  
    li      $v0,    4                # ��ӡ�ַ���(���ܺţ�4)
    la      $a0,    nline            # ������з���"\n"          
    syscall
    
    jr $ra
    
# a3 - address of msg $v1(��λ), $a2$a0 - 64bit
disp_adc64:
    move    $t0,  $a0
    
    li      $v0,   4                 # ��ӡ�ַ���(���ܺţ�4)
    move    $a0,   $a3               # ȡ�ַ����׵�ַ
    syscall                          # ϵͳ����
    
    li      $v0,    1                # ��ӡʮ��������
    move    $a0,    $v1              # �����λλ
    syscall                          # ϵͳ����
    
    li      $v0,    4                # ��ӡ�ַ���(���ܺţ�4)
    la      $a0,    space            # ����ո�" "          
    syscall
    
    li      $v0,    34               # ��ӡ16�������������һ����
    move    $a0,    $a2              # �����4���ֽ�
    syscall 

    li      $v0,    4                # ��ӡ�ַ���(���ܺţ�4)
    la      $a0,    space            # ����ո�" "          
    syscall
      
    li      $v0,    34               # ��ӡ16�������������һ����
    move    $a0,    $t0              # �����4���ֽ�
    syscall       
    
    li      $v0,    4                # ��ӡ�ַ���(���ܺţ�4)
    la      $a0,    nline            # ������з���"\n"          
    syscall
    
    jr $ra
    
.data
   msg1:
       .asciiz "1st comp64: "
   msg2:
       .asciiz "2nd comp64: "
   msg3:
       .asciiz "1st sbc32: "
   msg4:
       .asciiz "2nd sbc32: "
   msg5:
       .asciiz "1st sll32: "
   msg6:
       .asciiz "2nd sll32: "
   msg7:
       .asciiz "1st sll64: "
   msg8:
       .asciiz "2nd sll64: "
   msg9:
       .asciiz "1st div32: "
   msg10:
       .asciiz "2nd div32: "
   nline:  
       .asciiz "\n"  
   space:  
       .asciiz " "  
