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

//kill some warnings
/*#pragma GCC diagnostic ignored "-Wwrite-strings" DONT USE 'char *hello="hello"' FORMAT, ITS DEPRECATED AS FUUUUCK!!!!!!*/
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wparentheses"
#pragma GCC diagnostic ignored "-Wformat="

//common ascii stuff
/*	0~9 => 48~57
*	a~z => 97~122
*	A~Z => 65~90
*	"carriage return + line feed" or "CR + LF" or "\r + \n" or in ascii: "13 + 10"
*/

//misc stuff - unsigned
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;
typedef unsigned long long u64;
//signed
typedef signed char s8;
typedef signed short s16;
typedef signed long s32;
typedef signed long long s64;

//i use const when assigning a pointer to prevent memory leaks...
//const will block these stuff: *(stuff++);, so use stuff[i]; instead.
void mystrcpy(char *stuff, const char *other){
	int i=0;
	int options=2;
	if(options==1){
		for(; stuff[0]&&other[i]; i++){
			*(stuff++)=other[i];
			//stuff[i]=other[i];
		}
		stuff[0]='\0';
	}else{
		for(; stuff[i]&&other[i]; i++){
			stuff[i]=other[i];
		}
		stuff[i]='\0';
	}
}


//printbit - char ch -128~127 unsigned 0~255
#include<cstdio>
void printbit(u32 ch/*prevent overflow*/, int count=8){
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
		//c[y]='\0'; everythings already nullified. ascii null equates to int zero.
		a=c;
		//printf("%d\t%d\n", a, c);
		return EXIT_SUCCESS;
	}
	void string_delete(){delete [] c;}
	//friend void appendtest(char *, char *, int); //WTH?! TODO: figure out why the hell this doesnt let me access private members
	~string_tools(){delete [] c;}
};

//still trying to figure out, this is not really a run on exit termination.
string_tools asdf; //***global declaration makes destructor run properly on main() return.***
void string_delete(int){asdf.string_delete();} //unnecessary but whatever.
#include<csignal> //unnecessary but whatever.
void append(char *&a, char *b, int x=0){
	asdf.append(a, b, x);
	
	//unnecessary but whatever.
	signal(SIGINT, string_delete); //^C politely ask
	signal(SIGTSTP, string_delete); //^Z pause a process
	signal(SIGQUIT, string_delete); //^\ mercilessly kill
	signal(SIGTERM, string_delete); // terminate
}

//fibonacci - a simple fibonacci.
namespace single{
	s32 fibonacci(s32 &n){
		s32 i=1;
		s32 a=1, b=1, tmp;
		for(;i<n;i++){
			tmp=a;
			a+=b;
			b=tmp;
		}
		return b;
	}
};
namespace array{
	s32 *fibonacci(s32 &n){
		s32 i=1;
		s32 a=1, b=1, tmp; //we'll need to make this global if we want to pass the addr as a stack. otherwise, heap is necessary.
		s32 *addr=new s32[n];
		addr[0]=b;
		for(;i<n;i++){
			tmp=a;
			a+=b;
			b=tmp;
			addr[i]=b;
		}
		return addr;
	}
};

