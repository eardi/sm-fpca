CC=g++
# INC_DIR = ../Demo
CFLAGS=-Wall -Wextra -Werror -g -I.

all: BaseMesh_3D_example.o

%.o: %.cpp
	$(CC) $(CFLAGS) $< -o $@
# NOTE: $< refers to the LEFT of :
#       $@ refers to the RIGHT of :

clean:
	rm -rf *o all

# g++ BaseMesh_3D_example.cpp -o BaseMesh_3D_example
# g++ -Wall -Wextra -Werror -g BaseMesh_3D_example.cpp -o BaseMesh_3D_example
