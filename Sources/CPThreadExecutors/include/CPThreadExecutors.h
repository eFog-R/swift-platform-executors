//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2025 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#ifndef C_PTHREAD_EXECUTORS_LINUX_H
#define C_PTHREAD_EXECUTORS_LINUX_H

#ifdef __linux__
#include <sys/epoll.h>
#include <sys/eventfd.h>
#include <pthread.h>
#include <errno.h>

int CPThreadExecutors_pthread_setname_np(pthread_t thread, const char *name);
int CPThreadExecutors_pthread_getname_np(pthread_t thread, char *name, size_t len);

#endif
#endif
