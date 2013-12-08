# exampe makefile for compiling a C++ program that calls haskell functions 

# final executable
NAME = test

GHC = @ghc
CC  = @g++
LINKER  = @g++
ECHO = @echo
CAT = @cat
RM = @rm

# Source definition is wildcard based at the moment
SOURCES_CPP = $(wildcard *.cpp)
SOURCES_HS  = $(wildcard *.hs)

STUB_HEADERS= $(patsubst %.hs, %_stub.h, $(SOURCES_HS))
OBJECTS  = $(patsubst %.cpp, %.o, $(SOURCES_CPP))
OBJECTS_HS  = $(patsubst %.hs, %.o, $(SOURCES_HS))
OBJECTS_HI  = $(patsubst %.hs, %.hi, $(SOURCES_HS))
GHC_OUTPUT  = $(patsubst %.hs, %.ghc_output, $(SOURCES_HS))
LINK_OUTPUT = $(patsubst %.ghc_output, %.link_output, $(GHC_OUTPUT))

all: $(NAME)

.SUFFIXES: .ghc_output .link_output .o .hs .cpp

.cpp.o:
	$(ECHO) "Compiling $<..."
	$(CC) -c $< -I`ghc --print-libdir`/include -std=c++11

.hs.ghc_output:
	$(ECHO) "Compiling: $<"
	$(GHC) --make -no-hs-main $< -v > $@ 2>&1 ; 
	$(GHC) -no-link $<

.ghc_output.link_output:
	$(ECHO) generating link info: $<
	$(CAT) $< | grep -A 1 "\*\*\* Linker" | tail -n 1 | tr ' ' '\n' | \
		grep -e '\-L' -e '\-l' | tr '\n' ' ' | sed "s/'//g" > $@

$(NAME): $(GHC_OUTPUT) $(LINK_OUTPUT) $(OBJECTS)
	$(ECHO) "Linking $@..."
	$(LINKER) -o $@ $(OBJECTS) $(OBJECTS_HS) `cat $(LINK_OUTPUT)`
	$(ECHO) "Built $@!"

clean:
	$(ECHO) "Removing: $(OBJECTS) $(GHC_OUTPUT) $(LINK_OUTPUT) $(STUB_HEADERS)" \
		$(OBJECTS_HS) $(OBJECTS_HI)
	$(RM) -rf $(OBJECTS) $(GHC_OUTPUT) $(LINK_OUTPUT) $(STUB_HEADERS) \
		$(OBJECTS_HS) $(OBJECTS_HI) $(NAME)
