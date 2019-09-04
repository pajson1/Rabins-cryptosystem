#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <limits.h>

int e = 2, n; // e is the exponent 2 // n is the public key
int p, q; // p and q are private keys (primes)

// this a key generation step that will get us two primes private keys p and q
int keyGen()
{
	do {
		do {
			p = rand() % 500;
		}
		while (!((p % 2 == 1) && (p % 4 == 3)));
	}
	while (!primarityTest(2, p));

	do {
		do {
			q = rand() % 500;
		}
		while (!((q % 2 == 1) && (q % 4 == 3)));
	}
	while (!primarityTest(2, q));
	
	n = p * q;
	printf("p = %d, q = %d, n = %d\n\n", p, q, n);
}

// this is the encription part where we encrypt the plaintext to the ciphertext
// c = m2 mod n
int encryption(int plainText)
{
	printf("plainText is %d\n", plainText);
	int c = findT(plainText, e, n);
	fprintf(stdout, "CipherText is %d\n", c);
	
	return c;
}

// this is function for finding greates common divisor between 2 numbers
int gcd(int a, int b) {
    return b == 0 ? a : gcd(b, a % b);
}

// this is the decryption part 
void decryption(int c)
{
	int R1, R2, R3, R4;
	int mp, a2, mq, b2;
	static int *arrayR[4];

	mp = findT(c, (p + 1) / 4, p);
	a2 = p - mp;

	mq = findT(c, (q + 1) / 4, q);
	b2 = q - mq;

  // these are the 4 results from which will be one correct answers
	R1 = cdr(mp, mq, p, q);
	R2 = cdr(mp, b2, p, q);
	R3 = cdr(a2, mq, p, q);
	R4 = cdr(a2, b2, p, q);

    printf("\n****ONE OF THESE FOUR IS YOUR MESSAGE********");
	printf("\nR1 = %d\nR2 = %d\nR3 = %d\nR4 = %d\n", R1, R2, R3, R4);
    	
}

int primarityTest(int a, int i)
{
	int n = i - 1;
	int k = 0;
	int j, m, T;

	while (n % 2 == 0) {
		k++;
		n = n / 2;
	}

	m = n;
	T = findT(a, m, i);

	if (T == 1 || T == i - 1)
		return 1;

	for (j = 0; j < k; j++)
	{
		T = findT(T, 2, i);

		if (T == 1)
			return 0;

		if (T == i - 1)
			return 1;
	}

	return 0;
}

// exponention calculation
int findT(int a, int m, int n)
{
	int r;
	int y = 1;
	
	while (m > 0) {
		r = m % 2;
		exponention(r, n, &y, &a);
		m = m / 2;
	}
	
	return y;
}

int exponention(int bit, int n, int* y, int* a)
{
	if (bit == 1)
		*y = (*y * (*a)) % n;

	*a = (*a) * (*a) % n;
}

// finding the inverse
int inverse(int a, int b)
{
	int inv;
	int q, r, r1 = a, r2 = b, t, t1 = 0, t2 = 1;

	while (r2 > 0) {
		q = r1 / r2;
		r = r1 - q * r2;
		r1 = r2;
		r2 = r;

		t = t1 - q * t2;
		t1 = t2;
		t2 = t;
	}

	if (r1 == 1)
		inv = t1;
	if (inv < 0)
		inv = inv + a;

	return inv;
}


// chinese theorem remainder
int cdr(int a, int b, int m1, int m2)
{
	int M, M1, M2, M1_inv, M2_inv;
	int result;
 
	M = m1 * m2;
	M1 = M / m1;
	M2 = M / m2;
 
	M1_inv = inverse(m1, M1);
	M2_inv = inverse(m2, M2);
 
	result = (a * M1 * M1_inv + b * M2 * M2_inv) % M;
 
	return result;

}

int main(void)
{
	int plainText;
	keyGen();

	do {
		plainText = rand() % (n - 1) + 1; 
	}
	while (gcd(plainText, n) != 1); 

	int c = encryption(plainText);
	printf("******AFTER DECRYPTING***********");
	decryption(c);
	

 
  

	return 0;
}