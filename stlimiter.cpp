#include<iostream>
#include<unistd.h>
#include<stdlib.h>
#include<signal.h>
#include<sys/types.h>
using namespace std;

static const int msecs=1000;
static int pid;
static int limiter;

void send_signal(){
        kill(::pid, SIGSTOP);
        usleep(msecs*limiter);
        kill(::pid, SIGCONT);
        usleep(msecs*10);//10 millisecs == one jiffy
}

void handler(int){
	kill(::pid, SIGCONT);
	exit(0);
}

int main(int argc, char **argv){
	if(!argv[1]){
cout<<"Copyright (C) 2013-2015  hoholee12@naver.com"<<endl;
cout<<"Usage: "<<argv[0]<<" [milliseconds] [pid]"<<endl; return 0;}
        pid=atoi(argv[2]);
	limiter=atoi(argv[1])-10;
        if(getuid()){
                cout<<"big problem."<<endl;
                return 1;
        }
        if(kill(pid, 0)){
                cout<<"second big problem."<<endl;
                return 1;
        }
		signal(SIGINT, handler);
	for(;;) send_signal();
        return 0;
}
