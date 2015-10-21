#!/bin/bash

###############################################
# Author: Nicolas Carusso                     #
# Author's email: ncarusso at gmail dot com   #
# Date: October 2015                          #
###############################################

<<COMMENT1
	   Bash implementation The The Trivium algorithm. 
	   The Trivium algorithm is a hardware-efficient (profile 2), synchronous stream cipher designed by Christophe De Canniere and Bart Preneel. 
	   (http://www.ecrypt.eu.org/stream/e2-trivium.html). I only used bash commands to write this script in order to maximize its compatibility with linux distros

       TESTED IN: debian/Ubuntu/ Mac OSX 10.6.8 /Windows + CygWin...

COMMENT1

##########################################################
##########################################################
#####		FUNCTIONS
##########################################################
##########################################################
#
#
#

convert_binary_into_array () {

aux=$1
unset bits_array[@]

for (( x=0; x<${#1}; x++))
do
        bits_array[$x]=${aux:x:1}
done
}

#Initialization Vector (80 bits)
IV=11001001111100101100100111001101000001000110011101001110110111101010010000000000
#Key (80 bits)
Key=01101110011010010110101101100011011000010111001001110101011100110111001101101111


# Convert both IV and Key in arrays
convert_binary_into_array $IV
IV_array=(${bits_array[@]})
echo "IV array is" ${IV_array[@]}

convert_binary_into_array $Key
key_array=(${bits_array[@]})
echo "Key array is" ${key_array[@]}

######################################################################
#2.2 Key and IV setup
######################################################################

# Shift Register A (S1...S93) = IV_array + fill_with_0 from S80 up to S93
for ((i=0;i < ${#IV_array[@]}; i++))

do
	shift_register_A[$i]=${IV_array[i]}

done
shift_register_A=(${IV_array[@]} 0 0 0 0 0 0 0 0 0 0 0 0 0)

echo ${shift_register_A[@]}
echo ${#shift_register_A[@]}

# Shift Register B (S94...S177) = key_array + fill_with_0 from S174 to S177
for ((i=0;i < ${#key_array[@]}; i++))

do
	shift_register_B[$i]=${key_array[i]}

done
shift_register_B=(${key_array[@]} 0 0 0 0)

echo ${shift_register_B[@]}
echo ${#shift_register_B[@]}

# Shift Register C (S178...S288) = key_array + fill_with_0 from S174 to S177
for ((i=0;i < 108; i++))

do
	shift_register_C[$i]=0

done
shift_register_C=(${shift_register_C[@]} 1 1 1)

echo ${shift_register_C[@]}
echo ${#shift_register_C[@]}

# Unir los 3 shift_registers en 1! (OK)
# chequear que el tamaño sea, efectivamente, la suma de los 3 (OK! 288)
s=(${shift_register_A[@]} ${shift_register_B[@]} ${shift_register_C[@]})
echo ${s[@]}
echo ${#s[@]}

########

#for (( i = 0; i < (4*288); i++ ));

#do
	#bitwise XOR has lower precedence than AND.
	t1=$(echo $((${s[65]} ^ ${s[90]} & ${s[91]} ^ ${s[92]} ^ ${s[170]} )))

	echo $t1
#done

########################################################################################
# Escribir 2.1
# Escribir 2.2

#Bitwise XOR
#echo $((0 ^ 0 ^1))

#Bitwise and
#echo $((0 & 0))


