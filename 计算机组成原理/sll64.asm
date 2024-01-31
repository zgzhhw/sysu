# cut from div32.asm
.text
.globl main

main:     
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
    
    li      $v0,    10               # ����ϵͳ
    syscall

 
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
