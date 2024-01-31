# cut from div32.asm
.text
.globl main

main:
    li      $a0,  	0x1
    jal     comp64        # a2a0 ��=> a2a0   ��ߵ�a2����0
    la      $a3,   msg1
    li      $v1,   0
    jal     disp_adc64    # a3 - address of msg $v1(��λ), $a2$a0 - 64bit

    li      $a0,   0xC01830F1    
    jal     comp64        # a2a0 ��=> a2a0   ��ߵ�a2����0
    la      $a3,   msg2
    li      $v1,   0
    jal     disp_adc64    # a3 - address of msg $v1(��λ), $a2$a0 - 64bit
    
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
    
#  $v1(��λ) + $a3$a1 + $a2$a0 = $v1(��λ) + $a2$a0 
adc64:
   #...
   addi $sp, $sp, -4
   sw $ra, 0($sp)
   jal adc32
   addi $sp, $sp, -4
   sw $v0, 0($sp)
   move $a1, $a3
   addu $a0, $a2, $v1
   move $v1, $zero
   jal adc32 
   move $a2, $v0
   lw $a0, 0($sp)
   lw $ra, 4($sp)
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
