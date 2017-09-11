/***

block_alloc.h -- simple arena-based memory allocator
Copyright (c) 2008
David Bindel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

****/

/* @T
 * An [[Arena]] is a type of memory allocator that you can allocate
 * from or delete in entirety.  You cannot deallocate one part of an
 * [[Arena]], which means you don't have to keep track of a free list
 * or anything of that sort.  To further simplify matters, this
 * particular [[Arena]] class works with elements of a single type
 * only.
 *
 * @q */

#ifndef ARENA_H
#define ARENA_H

template<class T>
class Arena {
public:
    Arena(int chunk_size = 8000) :
        chunk_size(chunk_size),
        chunk(new Chunk(0, chunk_size)) {}

    ~Arena() {
        while (chunk) {
            Chunk* next = chunk->next;
            delete chunk;
            chunk = next;
        }
    }

    T* malloc(int n) {
        if (n >= chunk_size) {
            chunk->next = new Chunk(chunk->next, n);
            return chunk->next->data;
        } else if (n > chunk->ntotal - chunk->nused) {
            chunk = new Chunk(chunk, chunk_size);
        }
        T* data = &(chunk->data[chunk->nused]);
        chunk->nused += n;
        return data;
    }

private:
    struct Chunk {
        Chunk(Chunk* p, int n) :
            nused(0),
            ntotal(n),
            data(new T[(unsigned int)n]),
            next(p) {}

        ~Chunk() {
            delete[] data;
        }

        int nused;
        int ntotal;
        T* data;
        Chunk* next;
    };

    int chunk_size;
    Chunk* chunk;
};

#endif /* ARENA_H */
