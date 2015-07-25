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

//0 1 2 3 4 5 6 7 8 9 a  b  c  d  e  f
//0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15

//0xDEADBEEF
//Dx16^7+Ex16^6+Ax16^5+Dx16^4+Bx16^3+Ex16^2+Ex16^1+Fx16^0
//F		E		E		B		D		A			E			D
//15	14		14		11		13		10			14			13
//1		16		256		4096	65536	1048576		16777216	268435456

//15	224		3584	45056	851968	10485760	234881024	3489660928

//373598559

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


#include<ctype.h> //overload compensation for original toupper & tolower.
char toupper(char &ch){
	if(ch>='a'&&ch<='z') ch-=('a'-'A');
	return ch;
}
char tolower(char &ch){
	if(ch>='A'&&ch<='Z') ch+=('a'-'A');
	return ch;
}

//i use const when assigning a pointer to prevent memory leaks...
//const will block these stuff: *(stuff++);, so use stuff[i]; instead.
template<int n/*its called: "instantiation"*/> int mystrcpy(char (&stuff)[n], const char *other){
	//printf("%d\n", sizeof(stuff)); // pass an actual array with reference, and you'll be able to get the real size of it.
	u32 i=0;
	if(!other[0]){
		return 1; //nothing entered.
	}else if(!stuff[0]){
		stuff[0]='a'; //reserved to prevent breaks when nothing entered.
	}
	int options=2;
	if(options==1){
		/*for(; stuff[0]&&other[i]; i++){
			*(stuff++)=other[i];
		}
		stuff[0]='\0';*/
		//this method does not work when the actual array was passed.
	}else{
		for(; other[i]; i++){ //sizeof returns an unsigned integer
			stuff[i]=other[i];
		}
		stuff[i]='\0';
	}
	return 0;
}


// pow - power
/***overload works when pairing with pointer and non-pointer***/
template<typename T> T pow(T x, const int y){
	T tmp=x;
	for(int i=1; i<y; i++){
		x*=tmp;
	}
	return x;
}
template<typename T> T pow(T *x, const int y){ //pass an address to use this.
	T tmp=*x;
	for(int i=1; i<y; i++){
		(*x)*=tmp;
	}
	return *x;
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

//mappend - call string_tools first to init. written as a class because it needs a destructor. seriously flawed piece of garbage. use append instead of this abomination.
#include<cstdio>
#include<cstdlib>
#include<climits>
class string_tools{
private:
	char *c=new char[INT_MAX/*no reason intended*/]; //dyna alloc // outside b/c destructor needs it.
public:
	string_tools(){}
	bool mappend(char *&a/*THIS IS HOW YOU REFERENCE A POINTER!!!*/, char *b, int x=0){
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
void mappend(char *&a, char *b, int x=0){
	asdf.mappend(a, b, x);
	
	//unnecessary but whatever.
	signal(SIGINT, string_delete); //^C politely ask
	signal(SIGTSTP, string_delete); //^Z pause a process
	signal(SIGQUIT, string_delete); //^\ mercilessly kill
	signal(SIGTERM, string_delete); // terminate
}

//"blah blah" format used to be rewritable in c, but not anymore in c++. its format is now using 'const char *' as a standard, not 'char *'.
//if you still assign them like this: 'char str[]="blah blah"', it is converted as rewritable.
//if you still assign them like this: 'char *str="blah blah"', it is converted as rewritable, BUT IT WILL INTRODUCE SHIT TONS OF ERRORS!!!!
//best way to get rid of the incompatibility error, is to change '*str' to 'str[]'. NOTE: just dont ever put the string constant as an r-value for 'char *str' format.

//if you want the actual declared array size of the fucking thing, use template and do a reference to an array instead.
/***demonstration***/
template<int n>void arraysize(char (&str)[n]){
	printf("%d\n", sizeof(str));
}


/*********************************************************************************************************************/
// append - combined strcpy and strcat, the most powerful and sophisticated tool i have ever created.
/*
*	char str[]="hello";
*	append(str, ", world!", **option for strncpy**, **option for strncat**);
*	printf("%s\n", str);
*/

/*
* option for strcpy - formula is: "sizeof(str)-1"
* if you opt to use option for strcat, do the same above on option for strcpy.
*/

template<int n, int m>void append(char (&a)[n], const char (&b)[m]/*the string 'constant' still requires to be const if directly assigned*/, int c=n-1/*-1 to remove null at the end*/, int d=m-1){
	int i=0;
	for(;b[i]&&i<d;i++) a[i+c]=b[i];
	//a[i+c]=b[i]; //effectively sends array b's null character to array a //commented out because i wanted to get same effect of strcpy:p
	a[i+c]=0; //null
}
/*********************************************************************************************************************/



//fibonacci - a simple fibonacci.
namespace single{
	s32 fibonacci(s32 n){ //left out ampersand(&) because you can't reference a constant which was implemented on compile time.
		s32 i=1;
		s32 a=1, b=1, tmp;
		for(;i<n;i++){
			tmp=a;
			a+=b;
			b=tmp;
		}
		return b;
	}
	int fibonacci(int *n){ //pass an address to use this.
		int i=1;
		int a=1, b=1, tmp;
		for(;i<*n;i++){
			tmp=a;
			a+=b;
			b=tmp;
		}
		*n=b;
		return *n;
	}
	/*dont use int *fibonacci(){return n;}!! its not the same. **just reminding myself in case i become a monkey in the future...**
	the former returns an actual value, but the latter defines itself as returning an address.
	if you want to use the latter one, you will have to put asterisk on the front everytime you use it..*/
};
namespace array{
	s32 *fibonacci(s32 n){ //asterisk(*) needed because we're returning an address
		s32 i=1;
		s32 a=1, b=1, tmp;
		s32 *addr=new s32[n]; //we'll need to make addr global if we want to pass it as a stack. otherwise, heap is necessary since it is big and universally accessible.
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


//my version of strcmp.

// obey the rulez:
//same => false, 0
//not same => true, 1

template<int n>bool strcmp(char *a, const char (&b)[n]){
	int i=0;
	for(;i<n&&a[i]==b[i];i++);
	if(i==n) return false;
	else return true;
}
//no case comparison***
template<int n, int m>bool strncasecmp(char (&a)[n], const char (&b)[m]){
	int i=0;
	for(;i<n||i<m;i++){
		if(a[i]!=b[i]){
			if(a[i]>='A'&&a[i]<='Z') a[i]+='a'-'A';
			else a[i]+='A'-'a';
			if(a[i]==b[i]) continue;
			else break;
		}
	}
	if(i==n) return false; //for some reason, 'm' doesnt always work...
	else return true;
}

//strdup - make a heap and pass the addr to the target pointer.
template<int n>char *strdup(const char (&str)[n]){
	char *addr=new char [n];
	for(int i=0; i<n; i++) addr[i]=str[i];
	return addr;
}

int strlen(const char *str){
	int i=0;
	for(;str[i];i++);
	return i;
}

//reverse - esrever
void strrev(char *str){
	int i=0, n=strlen(str)-1;
	char temp;
	for(; i<(n+1)/2; i++){
		//printf("%c<->%c\n", str[n-i], str[i]);
		temp=str[i];
		str[i]=str[n-i];
		str[n-i]=temp;
	}
}

//char str[]="blah blah" ==> you can't modify the pointer, for some reason....idk:p
//char *str="blah blah" ==> you can modify the pointer
//const char *str="blah blah" ==> you obviously can't modify the pointer.

//tried double pointer, still can't get past the restriction they put in to this compiler....only way is to do 'char *str="blah blah"' format...
//#pragma GCC diagnostic ignored "-Wwrite-strings"
/*
*	char test[]="ABCABCABCABCABCABCABC";
*	char *str=test; //use this method if you dont want to get some BS.
*	char *ptr=strchr(str, 'A'); //check from start
*	char *ptr2=strrchr(str, 'A'); //reverse from end
*	printf("%s\t%s\t%s\n", ptr, str, ptr2);
*
****result: ABCABCABCABCABCABCABC	ABC	ABC
*/

//if on c compiler, use double pointer and pass an address of that pointer. this won't work.
char *strchr(char *&str, const char ch){ //disable '-Wwrite-strings' and use 'char *str' format.
	int i=0, n=strlen(str); //faster
	for(; i<n&&(str[i]!=ch); i++);
	str=&str[i];
	return str;
}
//reverse check
char *strrchr(char *&str, const char ch){
	int i=strlen(str)-1;
	for(; i>=0&&(str[i]!=ch); i--);
	str=&str[i]; //somehow got fixed after separating this....?????
	return str;
}


