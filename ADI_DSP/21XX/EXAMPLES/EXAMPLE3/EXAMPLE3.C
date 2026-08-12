
int outside;
int outside1;
int outside2;
int outside3;
int outside4;
int outside5;

void first( int * );
void second( int * );

main()
{
  int x;
  int y[10];

   while (1) {
  	outside = 10;
  	outside1 = 10;
  	outside2 = 10;
  	outside3 = 10;
  	outside4 = 10;
  	outside5 = 10;
  	for (x = 0; x < 10; x++)
    		y[x] = x;

  	first(y);
     }
  }

void first( int *ptr )
{
 int j;

 for (j = 0; j< 5; j++)
   second((ptr+j));
}

void second( int *d )
{
 *d += outside;
 *d *= outside;
}

