#!/bin/bash


<<COMMENT1
	   Bash implementation of The Trivium algorithm. 
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

trivium_heart () {

shift_register_A_after_clocks=(${shift_register_A[@]})
shift_register_B_after_clocks=(${shift_register_B[@]})
shift_register_C_after_clocks=(${shift_register_C[@]})

unset shift_register_A_after_clocks[${#shift_register_A_after_clocks[@]}-1]
unset shift_register_B_after_clocks[${#shift_register_B_after_clocks[@]}-1]
unset shift_register_C_after_clocks[${#shift_register_C_after_clocks[@]}-1]

shift_register_A_after_clocks=($t3 ${shift_register_A_after_clocks[@]})
shift_register_B_after_clocks=($t1 ${shift_register_B_after_clocks[@]})
shift_register_C_after_clocks=($t2 ${shift_register_C_after_clocks[@]})

unset -v shift_register_A[@]
unset -v shift_register_B[@]
unset -v shift_register_C[@]
shift_register_A=(${shift_register_A_after_clocks[@]})
shift_register_B=(${shift_register_B_after_clocks[@]})
shift_register_C=(${shift_register_C_after_clocks[@]})

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

key_and_iv_setup () {

# Shift Register A (S1...S93) = IV_array + fill_with_0 from S80 up to S93
shift_register_A=(${IV_array[@]} 0 0 0 0 0 0 0 0 0 0 0 0 0)

# Shift Register B (S94...S177) = key_array + fill_with_0 from S174 to S177
shift_register_B=(${key_array[@]} 0 0 0 0)

# Shift Register C (S178...S288) = key_array + fill_with_0 from S174 to S177
for ((i=0;i < 108; i++))

do
	shift_register_C[$i]=0

done
shift_register_C=(${shift_register_C[@]} 1 1 1)

########

shift_register_A_original=(${shift_register_A[@]})
shift_register_B_original=(${shift_register_B[@]})
shift_register_C_original=(${shift_register_C[@]})

for (( i = 0; i < (4 * 1); i++ ));

do
	#bitwise XOR has lower precedence than AND.
	s=(${shift_register_A[@]} ${shift_register_B[@]} ${shift_register_C[@]})
	t1=$(echo $((${s[65]} ^ ${s[90]} & ${s[91]} ^ ${s[92]} ^ ${s[170]} )))
	t2=$(echo $((${s[161]} ^ ${s[174]} & ${s[175]} ^ ${s[176]} ^ ${s[263]} )))
	t3=$(echo $((${s[242]} ^ ${s[285]} & ${s[286]} ^ ${s[287]} ^ ${s[68]} )))
	trivium_heart
 	echo ${shift_register_A_after_clocks[@]}
	echo ${shift_register_B_after_clocks[@]}
	echo ${shift_register_C_after_clocks[@]}

	echo $t1
	echo $t2
	echo $t3

done
}

#######################################################################################

#############
#2.1
#############
key_stream_generation () {

	for (( i = 0; i < 8c; i++ ));
	 do
	 	s=(${shift_register_A[@]} ${shift_register_B[@]} ${shift_register_C[@]})
		t1=$(echo $((${s[65]} ^ ${s[92]} )))
		t2=$(echo $((${s[161]} ^ ${s[176]} )))
		t3=$(echo $((${s[242]} ^ ${s[287]} )))
		z=$(echo $(($t1 ^ $t2 ^ $t3 )))
		t1=$(echo $(($t1 ^ ${s[90]} & ${s[91]} ^ ${s[170]} )))
		t2=$(echo $(($t2 ^ ${s[174]} & ${s[175]} ^ ${s[263]} )))
		t3=$(echo $(($t3 ^ ${s[285]} & ${s[286]} ^ ${s[68]} )))

trivium_heart

echo "s:" ${s[@]}
 	echo "t1:" $t1
 	echo "t2:" $t2
 	echo "t3:" $t3
 	echo "Shift register A: " ${shift_register_A_after_clocks[@]}
	echo "Shift register B: " ${shift_register_B_after_clocks[@]}
	echo "Shift register C: " ${shift_register_C_after_clocks[@]}
	echo "z: " $z
	done


}

key_and_iv_setup
key_stream_generation
