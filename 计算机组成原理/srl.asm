.text
.globl main

main:
    li      $a0,   0xC01830F0  
    li      $v0,   1
    jal     srl32              #   $v0(����λ) + $a0 һ������1λ=> $a0 + $v0(�Ƴ�λ)
    la      $a2,   msg1
    move    $a1,   $v0
    jal     disp_adc32         # $a2 - address of msg $a1- carry bit a0 - 32bits

    li      $a0,   0xC01830F1  
    li      $v0,   0
    jal     srl32              #   $v0(����λ) + $a0 һ������1λ=> $a0 + $v0(�Ƴ�λ)
    la      $a2,   msg2
    move    $a1,   $v0
    jal     disp_adc32         # $a2 - address of msg $a1- carry bit a0 - 32bits
     
    li      $v0,    10         # ����ϵͳ
    syscall

#   $v0(����λ) + $a0 һ������1λ=> $a0 + $v0(�Ƴ�λ)
srl32: 
    #  ...
    andi $t0, $a0, 1
    add $t1, $zero, $v0
    sll $t1, $t1, 31
    srl $a0, $a0, 1
    or $a0, $t1, $a0
    move $v0, $t0
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
    
.data
   str1:
       .asciiz "please give an integer from 1 to 20: "
   msg1:
       .asciiz "1st srl32: "
   msg2:
       .asciiz "2st srl32: "
   errormsg:
       .asciiz "out of range(1 to 20)\n" # �ַ������壬��"00"�ַ���Ϊ��ֹ������
   nline:  
       .asciiz "\n"  
   space:  
       .asciiz " "  
