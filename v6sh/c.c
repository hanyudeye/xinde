#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
ssize_t write (int __fd, const void *__buf, size_t __n);
int main(){
  //  printf("有时欢乐有时忧郁,world!");
  /* if((wirte(1,"Hello is some data\n")) != 18) */
  /*   write(2,"a write errors has fasheng\n",27); */
  //  if ((write(1, "Here is some data\n", 18)) != 18)
  // write(2, "A write error has occurred on file descriptor 1\n",46);
  //  (length "Here is some data\n")
  int arr[5]={1,2,3,4,5};
  RightShift(arr,5,3);
  for(int i=0;i<5;i++){
    printf("%d\n",arr[i]);
  }
  exit(0);
 
  //return 0;
}

RightShift(int* arr, int N, int K)
{
  while(K--)
    {
      int t = arr[N - 1];
      for(int i = N - 1; i > 0; i --)
        arr[i] = arr[i - 1];
      arr[0] = t;
    }
}
