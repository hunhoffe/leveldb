#define RUMPUSER_OPEN_RDWR  0x0002
#define RUMPUSER_OPEN_CREATE  0x0004

struct rumpuser_iovec {
    void *iov_base;
    size_t iov_len;
};

// Leave these as weak symbols because we'll link them directly to bespin during bake-time
int rumpuser_iovwrite(int fd, const struct rumpuser_iovec *ruiov, size_t iovlen, int64_t off, size_t *retv) __attribute__((weak));
int rumpuser_open(const char *name, int mode, int *fd) __attribute__((weak));
int rumpuser_close(int fd) __attribute__((weak));
