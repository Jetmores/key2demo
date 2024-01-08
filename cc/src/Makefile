evio:
	gcc -o evio evio.c  -L/usr/local/lib -I/usr/local/include/ -lev -Wl,-rpath,/usr/local/lib

evdemo:
	gcc -o evdemo evdemo.c  -L/usr/local/lib -I/usr/local/include/ -lev -Wl,-rpath,/usr/local/lib

mio:
	g++ -g mio.cc -o mio

echo:
	g++ -g echo.cc -o echo
#cc echo.cc -lpthread -o echo

.PHONY:clean
clean:
	rm -f *.o a.out echo mio evdemo evio
