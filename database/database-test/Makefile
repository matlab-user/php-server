main: main.o
	gcc -o $@ $^ -L/usr/lib/x86_64-linux-gnu -lmysqlclient -lpthread -lz -lm -ldl
main.o: main.c
	gcc -c $< -I/usr/include/mysql -DBIG_JOINS=1 -fno-strict-aliasing -g

clean:
	rm -rf *.o