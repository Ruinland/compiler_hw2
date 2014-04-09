#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include<math.h>
#include"header.h"

#define TABLE_SIZE	256

struct idsetnode{
    char name[256];
    int counter;
} v[1000] ;
int count=0;


symtab * hash_table[TABLE_SIZE];
extern int linenumber;

int HASH(char * str){
	int idx=0;
	while(*str){
		idx = idx << 1;
		idx+=*str;
		str++;
	}	
	return (idx & (TABLE_SIZE-1));
}

/*returns the symbol table entry if found else NULL*/

symtab * lookup(char *name){
	int hash_key;
	symtab* symptr;
	if(!name)
		return NULL;
	hash_key=HASH(name);
	symptr=hash_table[hash_key];

	while(symptr){
		if(!(strcmp(name,symptr->lexeme)))
			return symptr;
		symptr=symptr->front;
	}
	return NULL;
}


void insertID(char *name){
	int hash_key;
	symtab* ptr;
	symtab* symptr=(symtab*)malloc(sizeof(symtab));	
	
	hash_key=HASH(name);
	ptr=hash_table[hash_key];
	
	if(ptr==NULL){
		/*first entry for this hash_key*/
		hash_table[hash_key]=symptr;
		symptr->front=NULL;
		symptr->back=symptr;
	}
	else{
		symptr->front=ptr;
		ptr->back=symptr;
		symptr->back=symptr;
		hash_table[hash_key]=symptr;	
	}
	
	strcpy(symptr->lexeme,name);
	symptr->line=linenumber;
	symptr->counter=1;
}

void printSym() 
{
    int i;
    int sz = count;
    for(i=0; i<sz; i++)
    {
        printf("%-10s %6d\n", v[i].name, v[i].counter);
    }
}

void sortnode()
{
   //bubble sort
   int sz= count;
   int i, j;
   struct idsetnode t;
   for(i=0; i<sz; i++)
      for(j=i; j>0; j--)
      {
          if(strcmp(v[j].name, v[j-1].name)<0)
          {
              strcpy(t.name, v[j].name);
              t.counter=v[j].counter;
              strcpy(v[j].name , v[j-1].name);
              v[j].counter = v[j-1].counter;
              strcpy(v[j-1].name, t.name);
              v[j-1].counter = t.counter;
          }
      }
}

void printSymTab()
{
    int i;
	puts("");
    printf("Frequency of identifiers:\n");
    
    
    for (i=0; i<TABLE_SIZE; i++)
    {
        symtab* symptr;
        struct idsetnode n;
	    symptr = hash_table[i];
        while (symptr != NULL)
	    {
	        strcpy( n.name, symptr->lexeme );
            n.counter = symptr->counter;
            v[count++]=n;           
	        symptr=symptr->front;
	    }

    } 
    sortnode();
    printSym(); 
}
