
INCLUDES= -Ijni/include -Ijni -isystem /usr/local/android-ndk-r12b/platforms/android-18/arch-arm/usr/include
LIBRARIES = -L .

SYMVER =fuse_versionscript

CFLAGS = -fpic -ffunction-sections -funwind-tables -fstack-protector-strong \
	-no-canonical-prefixes  -g -march=armv7 -mtune=arm7 -msoft-float \
	-mthumb -O0 -UNDEBUG -DANDROID -D_FILE_OFFSET_BITS=64 \
	-DFUSE_USE_VERSION=26 -D__MULTI_THREAD -DPIC -Wa,--noexecstack -Wformat -Werror=format-security 

CCFLAGS = -shared -ffunction-sections -funwind-tables -fstack-protector-strong \
	-no-canonical-prefixes  -g -march=armv7 -mtune=arm7 -msoft-float \
	-mthumb -O0 -UNDEBUG -DANDROID -D_FILE_OFFSET_BITS=64 \
	-Wl,--version-script,$(SYMVER) \
	-Wl,-rpath,. -Wl,-rpath,/system/lib -L /system/lib\
	-DFUSE_USE_VERSION=26 -D__MULTI_THREAD -fPIC -Wa,--noexecstack -Wformat -Werror=format-security
CC=/usr/local/android-ndk-r12b/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gcc

NAME = libfuse.so
SRCS_DIR = jni/
OBJS_DIR = ./obj/local/armeabi/objs-debug/fuse/
SRCS = cuse_lowlevel.c fuse.c \
       fuse_kern_chan.c fuse_loop.c \
       fuse_loop_mt.c fuse_lowlevel.c fuse_mt.c fuse_opt.c \
       fuse_session.c fuse_signals.c helper.c \
       mount.c mount_util.c ulockmgr.c

OBJS = $(subst .c,.o,$(SRCS))

all: $(NAME)

$(NAME): $(addprefix $(OBJS_DIR),$(OBJS))
	gcc $(CCFLAGS) -o $@ $(addprefix $(OBJS_DIR),$(OBJS)) $(LIBRARIES)

$(OBJS_DIR)%.o: $(SRCS_DIR)%.c
	$(CC) -MMD -MP -MF $@.d  $(CFLAGS) $(INCLUDES) -c $^ -o $@ 

clean:
	rm $(addprefix $(OBJS_DIR),$(OBJS))

re: clean all
