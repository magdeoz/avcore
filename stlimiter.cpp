/*
# stlimiter.cpp
#
# Copyright (C) 2013-2015  hoholee12@naver.com
#
# May be freely distributed and modified as long as copyright
# is retained.
*/

#include<iostream> //kill
#include<unistd.h> //usleep, getuid
#include<stdlib.h> //atoi
#include<signal.h> //SIGCONT, SIGSTOP
#include<sys/types.h> //i dont know what this contains.
using namespace std;

static const int jiffy=10000;
static int pid;
static double limiter;
static int sigstopsleepr;
static int sigcontsleepr;
static const int enable_swap=1;

inline void send_signal(){
	kill(::pid, SIGSTOP);
	usleep(::sigstopsleepr);
	kill(::pid, SIGCONT);
	usleep(::sigcontsleepr);
}

void handler(int){
	kill(::pid, SIGCONT);
	exit(0);
}

void swap(int &a, int &b){
	if(::enable_swap==1){
		int tmp=a; a=b; b=tmp;
	}
}

int main(int argc, char **argv){
	if(!argv[1]){
cout<<"Copyright (C) 2013-2015  hoholee12@naver.com"<<endl;
cout<<"Usage: "<<argv[0]<<" [percentage] [pid]"<<endl; return 0;}
	pid=atoi(argv[2]);
	limiter=atof(argv[1]);
	if(limiter>100.0) limiter=100.0;
	else if(limiter<0.0) limiter=0.0;
	if(getuid()){
		cout<<"Permission denied, are you root?"<<endl;
		return 1;
	}
	if(kill(::pid, 0)){
		cout<<"process "<<::pid<<" does not exist."<<endl;
		return 1;
	}
	sigstopsleepr=jiffy*limiter/100;
	sigcontsleepr=jiffy*(100-limiter)/100;
	swap(sigstopsleepr, sigcontsleepr);
	signal(SIGINT, handler);
	for(;;){ 
		if(kill(::pid, 0)){
			cout<<"process "<<::pid<<" ended."<<endl;
			break;
		}
	send_signal();}
	return 0;
}
