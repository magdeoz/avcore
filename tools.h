/*
*	tools.h
*	collection of tools for convenience
*	Copyright (c) 2015 hoholee12@naver.com
*/

//	stuff<<=1; => stuff*=2;
//	stuff<<=2; => stuff*=2*2;
//	stuff<<=2; => stuff*=2*2*2;
/*
*	i*2 = i<<1
*	i*3 = (i<<1) + i
*	i*10 = (i<<3) + (i<<1)
*/
//printbit - char ch -128~127 unsigned 0~255
#include<cstdio>
void printbit(unsigned int ch/*prevent overflow*/, int count=8){
	int arr[count];
	for(int i=(count-1);i>=0;i--){
		arr[i]=ch%2;
		ch/=2;
	}
	for(int i=0; i<count; i++){
		printf("%d", arr[i]);
	}
}

//swap - just regular swap. :p
//extern bool enable_swap; very inconvenient, fuck it
template<class T> void swap(T &a, T &b, bool enable_swap=1){
	if(enable_swap==1){ T tmp=a; a=b; b=tmp;}
}

//append - call string_tools first to init. written as a class because it needs a destructor.
#include<cstdio>
#include<cstdlib>
#include<climits>
class string_tools{
private:
	char *c=new char[INT_MAX/*no reason intended*/]; //dyna alloc // outside b/c destructor needs it.
public:
	string_tools(){}
	bool append(char *&a/*THIS IS HOW YOU REFERENCE A POINTER!!!*/, char *b, int x=0){
		if(!c){ fprintf(stderr,"alloc failed!"); //fail
			return EXIT_FAILURE;
		}
		int y=0;
		for(int i=0; a[i]; i++){
			if(x==i){
				for(int j=0; b[j]; j++){
					c[y++]=b[j];
				}
			}
			else c[y++]=a[i];
		}
		//c[y]='\0'; everythings already nullified. ascii null equals int zero.
		a=c;
		//printf("%d	%d\n", a, c);
		return EXIT_SUCCESS;
	}
	void string_delete(){delete [] c;}
	//friend void appendtest(char *, char *, int); WTH?! TODO: figure out why the hell this doesnt let me access private members
	//~string_tools(){delete [] c;}
};
void append(char *&a, char *b, int x=0){
	string_tools asdf;
	asdf.append(a, b, x);
	//asdf.string_delete();
	//delete [] c;
}
