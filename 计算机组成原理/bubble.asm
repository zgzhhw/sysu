.text
.globl main

main:
   
    li      $a0,   0xC01830F1
    li      $a1,   0x205A0F26
    li      $v1,   0
    jal     adc32             # $v1(��λ) + $a1 + $a0 = $v1(��λ) + $v0 
    
    la      $a1,    msg1
    move    $a0,    $v0    
    jal     disp_adc32      # a1 - address of msg v1- carry bit a0 - 32bits
    
    li      $a0,   0x7E341E86
    li      $a1,   0xA240F834
    li      $v1,   0
    jal     adc32             # $v1(��λ) + $a1 + $a0 = $v1(��λ) + $v0 
    
    la      $a1,    msg2    
    move    $a0,    $v0
    jal     disp_adc32      # a1 - address of msg v1- carry bit a0 - 32bits
        
    li      $v0,    10          # ����ϵͳ
    syscall
    
# $v1(��λ) + $a1 + $a0 = $v1(��λ) + $v0 
adc32: 
    #...
    addu $v0, $a0, $a1
    sltu $t3, $v0, $a0
    sltu $t4, $v0, $a1
    addi $t2, $zero, 2
    add $t3, $t3, $t4
    beq $t3, $t2 set
    j set_exit
set:
    addi $v1, $zero, 1
    addi $v0, $v0, 1
    j return
set_exit:
    addi $v1, $zero, 0
return:
    move $a0, $v0
    jr $ra
 
 
# a1 - address of msg v1- carry bit a0 - 32bits
disp_adc32:
    move    $t0,  $a0
    move    $t1,  $v1
    move    $t2,  $a1
    
    li      $v0,   4                 # ��ӡ�ַ���(���ܺţ�4)
    move    $a0,   $t2               # ȡ�ַ����׵�ַ
    syscall                          # ϵͳ����
    
    li      $v0,    1                # ��ӡʮ��������
    move    $a0,    $t1              # ��ӡ$t1�е���
    syscall                          # ϵͳ����
    
    li      $v0,    4                # ��ӡ�ַ���(���ܺţ�4)
    la      $a0,    space            # ����ո�" "          
    syscall
    
    li      $v0,    34               # ��ӡ16�������������һ����
    move    $a0,    $t0              # ��ӡ$t0�е���
    syscall 
  
    li      $v0,    4                # ��ӡ�ַ���(���ܺţ�4)
    la      $a0,    nline            # ������з���"\n"          
    syscall
    
    jr $ra
    
.data
   str1:
       .asciiz "please give an integer from 1 to 20: "
   msg1:
       .asciiz "1st sum: " # �ַ������壬��"00"�ַ���Ϊ��ֹ������
   msg2:
       .asciiz "2nd sum: " # �ַ������壬��"00"�ַ���Ϊ��ֹ������
   errormsg:
       .asciiz "out of range(1 to 20)\n" # �ַ������壬��"00"�ַ���Ϊ��ֹ������
   nline:  
       .asciiz "\n"  
   space:  
       .asciiz " "  
