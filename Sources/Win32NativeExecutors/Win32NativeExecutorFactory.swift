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

#if canImport(WinSDK)
public struct Win32NativeExecutorFactory: ExecutorFactory {
  public static let mainExecutor: any MainExecutor = Win32EventLoopExecutor(isMainExecutor: true)
  public static let defaultExecutor: any TaskExecutor = Win32ThreadPoolExecutor()
}
#endif
