#ifndef PROCESSQUEUE_H
#define PROCESSQUEUE_H

#include <iostream>
#include <queue>
#include <thread>
#include <future>

template <class T>
class queueProcess {
public:
    queueProcess():
        runFlag(false){}

    ~queueProcess() {
        {
            std::lock_guard<std::mutex> lock{mMutex};
            runFlag = true;
            mCondVar.notify_one();
        }
        if(fut.valid())
        {
            fut.wait();
        }
    }

  void addQueue(const T& process) {
    {
        std::lock_guard<std::mutex> lock{mMutex};
        mQueue.push(process);
        mCondVar.notify_one();
    }

  }

  bool safeToLeaveProcess()
  {
      {
          std::lock_guard<std::mutex> lock{mMutex};
          runFlag = true;
          mCondVar.notify_one();
      }
      if(fut.valid())
      {
          fut.wait();
          return false;
      }
      else
      {
          return true;
      }
  }

  void processQueue() {

    if(!fut.valid())
    {
    fut = std::async(std::launch::async, [&](){

      while (!runFlag) {
           std::unique_lock<std::mutex> lock{mMutex};

           mCondVar.wait(
                lock, [this]() { return !mQueue.empty() || runFlag; });

          if(runFlag)
          {
                return;
          }

           auto process = mQueue.front();
           mQueue.pop();
           lock.unlock();

           process();
      }

      });
    }
  }

private:
  std::future<void> fut;
  std::queue<T> mQueue;
  std::mutex mMutex;
  bool runFlag;
  std::condition_variable mCondVar;
};

#endif // PROCESSQUEUE_H
