# Swift Platform Executors

This package provides platform-native executors for Swift Concurrency that
do not rely on Dispatch or Foundation to provide the job scheduling system.

## Getting Started

Below is a description of the steps you need to take to use this
package.

#### Add the dependency

You will need to add the dependency to your `Package.swift`, as show
below:

```swift
.package(
  url: "https://github.com/swiftlang/swift-platform-executors",
  from: "0.0.1"
),
```

You will also need to add it to your application or library target,
e.g:

```swift
.target(name: "MyApplication", dependencies: ["SwiftPlatformExecutors"]),
```


## Getting started

Below is a description of the steps you need to take to use this
package.

#### Add the dependency

You will need to add the dependency to your `Package.swift`, as show
below:

```swift
.package(
  url: "https://github.com/swiftlang/swift-win32-native-executors",
  from: "0.0.1"
),
```

You will also need to add it to your application or library target,
e.g:

```swift
.target(name: "MyApplication", dependencies: ["Win32NativeExecutors"]),
```

#### Using the executors

##### Windows

###### `Win32EventLoopExecutor`

`Win32EventLoopExecutor` is a
[`SerialExecutor`](https://developer.apple.com/documentation/swift/serialexecutor)
and may be used as a [custom actor executor,
ala
SE-0392](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0392-custom-actor-executors.md):

```swift
import Win32NativeExecutors

actor Win32Actor {
  nonisolated let executor = Win32EventLoopExecutor()

  nonisolated var unownedExecutor: UnownedSerialExecutor {
    self.executor.asUnownedSerialExecutor()
  }

  func greet() {
    print("Hello from a Win32 event loop!")
    try? await Task.sleep(for: .seconds(3))
  }
}

func test() {
  let myActor = Win32Actor()
  let t = Task.detached {
    await myActor.greet()
    myActor.executor.stop()
  }
  myActor.executor.run()
}
```

This will also work for global actors, e.g.

```swift
import Win32NativeExecutors

@globalActor
actor MessageLoopActor {
  let executor = Win32EventLoopExecutor()

  nonisolated var unownedExecutor: UnownedSerialExecutor {
    self.executor.asUnownedSerialExecutor()
  }
}

@MessageLoopActor
func hello() {
  print("Hello from a Win32 event loop!")
  try? await Task.sleep(for: .seconds(3))
}

func test() {
  let t = Task.detached {
    await hello()
    myActor.executor.stop()
  }
  myActor.executor.run()
}
```

Note that you will need to call the `run()` method on the
`Win32EventLoopExecutor` from some thread to actually service the
message loop.  This will return on receipt of `WM_QUIT`, or if
something calls the `stop()` method (the latter is thread-safe and can
be done asynchronously; the message loop will stop when it is next
safe to do so).

###### `Win32ThreadPoolExecutor`

The `Win32ThreadPoolExecutor` is a
[`TaskExecutor`](https://developer.apple.com/documentation/swift/taskexecutor) 
built on [the Win32 Thread Pool
API](https://learn.microsoft.com/en-us/windows/win32/procthread/thread-pool-api)
and can be used with the
[`withTaskExecutorPreference(_:operation:)`](https://developer.apple.com/documentation/swift/withtaskexecutorpreference(_:isolation:operation:)),
[`Task(executorPreference:)`](https://developer.apple.com/documentation/swift/task/init(executorpreference:priority:operation:)-7zpzv)
or [`group.addTask(executorPreference:)`](https://developer.apple.com/documentation/swift/taskgroup/addtask(executorpreference:priority:operation:))
families of APIs:

```swift
import Win32NativeExecutors

let threadPool = Win32ThreadPoolExecutor()

func test() {
  Task {
     await withTaskExecutorPreference(threadPool) {
       print("I am running in the default Win32 thread pool")
     }
  }
}
```

If you have a custom Win32 thread pool that you wish to use instead,
you can use the `Win32ThreadPoolExecutor(pool: PTP_POOL?)` API to
construct an executor that will target that thread pool specifically.
Passing `nil` to that API will use the default pool.

##### Replacing the default main and global executors

Once [the relevant Swift Evolution proposal lands](https://github.com/swiftlang/swift-evolution/pull/2654/files), it will be possible
to replace the default main and global executors with executors from
this package.

See [the
proposal](https://github.com/swiftlang/swift-evolution/pull/2654/files)
for more information on doing this.

Be aware that if you take advantage of this option, the Dispatch main
queue will not be processed, so anything that relies explicitly on
`Dispatch.main` will not work.
