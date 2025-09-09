#include <stdio.h>
#include <stdlib.h>

void shownbits(unsigned int x, unsigned int size){
    for(int i=size-1 ; i>=0 ; i--){
        unsigned int result = x & (1u << i);

        if(result == 0) putchar('0');
        else putchar('1');
    }
    printf("\n");
}

unsigned int lookup(unsigned int x){
    if(x == 0) return 0b0000000000;
    else if(x == 8) return 0b0000100011; 
    else if(x == 16) return 0b0001000110; 
    else if(x == 24) return 0b0001101000; 
    else if(x == 32) return 0b0010000111; 
    else if(x == 40) return 0b0010100100; 
    else if(x == 48) return 0b0010111110; 
    else if(x == 56) return 0b0011010100; 
    else if(x == 64) return 0b0011100110; 
    else if(x == 72) return 0b0011110011; 
    else if(x == 80) return 0b0011111100; 
    else if(x == 88) return 0b0011111110; 
    else if(x == 89) return 0b0011111111; 
    else if(x == 90) return 0b0100000000;
    else return 0b1000000000; //512
}

unsigned int transformX(unsigned int x){
    if(x >= 0 && x<90) return x;
    else if(x>=90 && x<180) return 180-x;
    else if(x>=180 && x<270) return x-180;
    else return 360-x;
}

unsigned int calculateSine(unsigned int x){
    unsigned int lookup_result = lookup(x);
    if(lookup_result != 512) return lookup_result;

    unsigned int pn = (x/8) * 8;
    unsigned int nn = pn + 8;

    unsigned int sine_pn = lookup(pn);
    unsigned int sine_nn = lookup(nn);

    unsigned int intermediate_result = ((sine_nn - sine_pn)*(x - pn)) >> 3;
    return sine_pn + intermediate_result;
}

void sine_interpolator(int i){
    unsigned int x = i;
    
    unsigned int abs_result = calculateSine(transformX(x));

    // Se angolo tra 180 e 359, cambia segno con complemento a due
    unsigned int final_result;
    if(x >= 180 && x < 360){
        final_result = (~abs_result + 1) & 0x3FF;  // Mantieni solo 10 bit
    } else {
        final_result = abs_result;
    }

    shownbits(final_result, 10);
}

int main(){
    for(int i=0 ; i<361 ; i++){
        printf("sin(%d): ", i);
        sine_interpolator(i);
    }
}
