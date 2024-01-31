.text
.globl main

main:
    li      $a0,   0xC01830F1
    li      $a1,   0xC01830F1    
    li      $v0,   0
    jal     srl64              #  $v0(����λ) + $a1$a0 һ������1λ => $a1$a0 + $v0(�Ƴ�λ)
    la      $a3,   msg3
    move    $a2,   $a1
    move    $v1,   $v0
    jal     disp_adc64         # a3 - address of msg $v1(��λ), $a2$a0 - 64bit
            
    li      $a0,   0xC01830F0
    li      $a1,   0xC01830F1    
    li      $v0,   1
    jal     srl64              #  $v0(����λ) + $a1$a0 һ������1λ => $a1$a0 + $v0(�Ƴ�λ)
    la      $a3,   msg4
    move    $a2,   $a1
    move    $v1,   $v0
    jal     disp_adc64         # a3 - address of msg $v1(��λ), $a2$a0 - 64bit
    
    li      $v0,    10         # ����ϵͳ
    syscall

#  $v0(����λ) + $a1$a0 һ������1λ => $a1$a0 + $v0(�Ƴ�λ)
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
   str1:
       .asciiz "please give an integer from 1 to 20: "
   msg3:
       .asciiz "1st srl64: " 
   msg4:
       .asciiz "2st srl64: " 
   errormsg:
       .asciiz "out of range(1 to 20)\n" # �ַ������壬��"00"�ַ���Ϊ��ֹ������
   nline:  
       .asciiz "\n"  
   space:  
       .asciiz " "  
