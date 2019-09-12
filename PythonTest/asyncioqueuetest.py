#!/usr/bin/env python

import asyncio

@asyncio.coroutine
def do_work(task_name, work_queue):
    while not work_queue.empty():
        queue_item = yield from work_queue.get()
        print("%s grabbed item %s" % (task_name, queue_item))
        yield from asyncio.sleep(2)

if __name__ == "__main__":
    q = asyncio.Queue()
    for x in range(20):
        q.put_nowait(x)
    print(q)
    loop = asyncio.get_event_loop()
    tasks = [
        do_work('task1', q),
        do_work('task2', q),
        do_work('task3', q)]
    loop.run_until_complete(asyncio.wait(tasks))
    loop.close()
    
