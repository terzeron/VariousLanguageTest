#!/usr/bin/env python

import asyncio

@asyncio.coroutine
def my_coroutine(task_name, seconds_to_sleep=3):
    print("%s sleeping for %d seconds" % (task_name, seconds_to_sleep))
    yield from asyncio.sleep(seconds_to_sleep)
    print("%s is finished" % (task_name))

loop = asyncio.get_event_loop()
tasks = [
    my_coroutine('task1', 4),
    my_coroutine('task2', 3),
    my_coroutine('task3', 2)]
loop.run_until_complete(asyncio.wait(tasks))
loop.close()
