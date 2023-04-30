/*CC = gcc
CFLAGS = -Wall -Werror -g
LIBS = -lcunit -lpthread
INCLUDE_HEADERS_DIRECTORY = -Iinclude

sp: sp.c src/belleman.o src/graph.o  # add your other object files needed to compile your program here. !! The ordering is important !! if file_a.o depends on file_b.o, file_a.o must be placed BEFORE file_b.o in the list !
	$(CC) $(INCLUDE_HEADERS_DIRECTORY) $(CFLAGS) -o $@ $^ $(LIBS)    
%.o: %.c
	$(CC) $(INCLUDE_HEADERS_DIRECTORY) $(CFLAGS) -o $@ -c $<

clean:
	@rm -f src/*.o
	@rm -f sp
	@rm -f out
	@rm -f *.bin
	@echo === Cleaned ! ===

tests: sp.c src/belleman.c src/graph.c 
	@echo ===cppcheck on $^===
	@cppcheck --enable=all --suppress=missingIncludeSystem ./$^
	@echo ===gcc on $^===
	@gcc -Wall -Werror -o $@ $^
	@valgrind --leak-check=full --show-leak-kinds=all ./$@ -f out_test.bin graphs/graph.bin

	@echo ===sanity check on output of $@===
	python3 python_utils/verify_output.py out_test.bin
	@rm -f out_test.bin
	@echo ===valgrind on $@===
	@valgrind --leak-check=full --quiet --show-leak-kinds=all --error-exitcode=1 ./$@ -v graphs/graph.bin || (ret=$$?; rm -f $@ && exit $$ret)
	@rm -f $@
	@echo $@ is a Succes ! && exit 0


.PHONY: clean tests*/

