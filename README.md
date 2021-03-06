# Trivium

The Trivium algorithm is a hardware-efficient (profile 2), synchronous stream cipher designed by Christophe De Canniere and
Bart Preneel. The cipher makes use of a 80-bit key and 80-bit initialization vector (IV);
its secret state has 288 bits, consisting of three interconnected non-linear feedback shift registers (NLSR) of length 93, 84
and 111 bits respectively. The cipher operation consists of two phases: the key and <b>IV set-up</b> and the <b>keystream generation</b>. 

Initialisation is very similar to keystream generation and requires 1152 steps of the clocking procedure of Trivium. 
The keystream is generated by repeatedly clocking the cipher, where in each clock cycle three state bits are updated using a
non-linear feedback function, and one bit of keystream is produced and output. 
The cipher specification states that 2<sup>64</sup> keystream bits can be generated from each key/IV pair
