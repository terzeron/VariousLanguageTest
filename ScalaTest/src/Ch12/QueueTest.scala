package Ch12

/**
  * Created by terzeron on 2016. 12. 19..
  */

import scala.collection.mutable.ArrayBuffer

object QueueTest {
  def main(args: Array[String]): Unit = {
    val intQueue = new BasicIntQueue with Filtering with Doubling with Incrementing
    intQueue.put(12)
    println(intQueue.get())
  }
}

abstract class IntQueue {
  def get(): Int

  def put(x: Int)
}

class BasicIntQueue extends IntQueue {
  private val buf = new ArrayBuffer[Int]

  def get() = buf.remove(0)

  override def put(x: Int) {
    buf += x
  }
}

trait Doubling extends IntQueue {
  abstract override def put(x: Int) {
    super.put(x * 2)
  }
}

trait Incrementing extends IntQueue {
  abstract override def put(x: Int) {
    super.put(x + 1)
  }
}

trait Filtering extends IntQueue {
  abstract override def put(x: Int) = {
    if (x >= 0) super.put(x) else ()
  }
}