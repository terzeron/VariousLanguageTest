#!/usr/bin/env python

import asyncio
import aiohttp

@asyncio.coroutine
def fetch_page(url):
    response = yield from aiohttp.request('GET', url)
    assert response.status == 200
    content = yield from response.read()
    print("URL: %s Content: %d" % (url, len(content)))


loop = asyncio.get_event_loop()
tasks = [
    fetch_page('http://google.com'),
    fetch_page('http://cnn.com'),
    fetch_page('http://twitter.com')]
loop.run_until_complete(asyncio.wait(tasks))
loop.close()

for task in tasks:
    print(task)
