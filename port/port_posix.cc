// Copyright (c) 2011 The LevelDB Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file. See the AUTHORS file for names of contributors.

#include "port/port_posix.h"

#include <cstdlib>
#include <stdio.h>
#include <string.h>
#include "util/logging.h"

namespace leveldb {
namespace port {

int amy_pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr) asm ("amy_pthread_mutex_init") __attribute__((weak));
int amy_pthread_mutex_destroy(pthread_mutex_t *mutex) asm ("amy_pthread_mutex_destroy") __attribute__((weak));
int amy_pthread_mutex_lock(pthread_mutex_t *mutex) asm ("amy_pthread_mutex_lock") __attribute__((weak));
int amy_pthread_mutex_unlock(pthread_mutex_t *mutex) asm ("amy_pthread_mutex_unlock") __attribute__((weak));

int amy_pthread_cond_init(pthread_cond_t *cond, const pthread_condattr_t *attr) asm("amy_pthread_cond_init") __attribute__((weak));
int amy_pthread_cond_destroy(pthread_cond_t *cond) asm("amy_pthread_cond_destroy") __attribute__((weak));
int amy_pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex) asm("amy_pthread_cond_wait") __attribute__((weak));
int amy_pthread_cond_signal(pthread_cond_t *cond) asm("amy_pthread_cond_signal") __attribute__((weak));
int amy_pthread_cond_broadcast(pthread_cond_t *cond) asm("amy_pthread_cond_broadcast") __attribute__((weak));

static void PthreadCall(const char* label, int result) {
  if (result != 0) {
    fprintf(stderr, "pthread %s: %s\n", label, strerror(result));
    abort();
  }
}

Mutex::Mutex() { PthreadCall("init mutex", amy_pthread_mutex_init(&mu_, NULL)); }

Mutex::~Mutex() { PthreadCall("destroy mutex", amy_pthread_mutex_destroy(&mu_)); }

void Mutex::Lock() { PthreadCall("lock", amy_pthread_mutex_lock(&mu_)); }

void Mutex::Unlock() { PthreadCall("unlock", amy_pthread_mutex_unlock(&mu_)); }

CondVar::CondVar(Mutex* mu)
    : mu_(mu) {
    PthreadCall("init cv", amy_pthread_cond_init(&cv_, NULL));
}

CondVar::~CondVar() { PthreadCall("destroy cv", amy_pthread_cond_destroy(&cv_)); }

void CondVar::Wait() {
  PthreadCall("wait", amy_pthread_cond_wait(&cv_, &mu_->mu_));
}

void CondVar::Signal() {
  PthreadCall("signal", amy_pthread_cond_signal(&cv_));
}

void CondVar::SignalAll() {
  PthreadCall("broadcast", amy_pthread_cond_broadcast(&cv_));
}

void InitOnce(OnceType* once, void (*initializer)()) {
  PthreadCall("once", pthread_once(once, initializer));
}

}  // namespace port
}  // namespace leveldb
