
all: build build/macros-23 build/all-insts.d tests

build:
	@ mkdir -p build

clean:
	rm -Rf build/

build/all-possible-instructions.o: src/all-possible-instructions.s
	@echo $@; tarn-elf32-as $< -o $@
build/all-insts.s: build/all-possible-instructions.o
	@echo $@; tarn-elf32-objdump -d $< | sed 's/^ *[0-9a-f]*:[\t ]*[0-9a-f]*[\t ]*[0-9a-f]*[\t ]*//' | sed -n '/00000000/,$$ { /00000000/n ; p }' | grep -v 'Bad inst' > $@
build/all-insts.o: build/all-insts.s
	@echo $@; tarn-elf32-as $< -o $@
build/all-insts.d: build/all-insts.o
	@echo $@; tarn-elf32-objdump -wd $< > $@

build/macros-23.o: src/macros-23.s
	@echo $@; tarn-elf32-as -o $@ $<

build/macros-23: build/macros-23.o src/ld.txt
	@echo $@; tarn-elf32-ld -T src/ld.txt -o $@ $<


# tarn-elf32-nm build/macros
# tarn-elf32-objdump -d build/macros | ~/repo/colorize-asm.sh
# tarn-elf32-run --memory-mapfile cpu23.mem --memory-region 0 --memory-info --map-info -t build/macros
