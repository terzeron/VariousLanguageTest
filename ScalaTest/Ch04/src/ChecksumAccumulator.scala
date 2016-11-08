/**
  * Created by terzeron on 2016. 11. 7..
  */

import scala.collection.mutable.Map

class ChecksumAccumulator {
  private var sum = 0

  def add(b: Byte) {
    sum += b
  }

  def checksum(): Int = ~(sum & 0xFF) + 1
}

object ChecksumAccumulator {
  private val cache = Map[String, Int]()

  def calculate(s: String): Int =
    if (cache.contains(s))
      cache(s)
    else {
      val acc = new ChecksumAccumulator
      for (c <- s)
        acc.add(c.toByte)
      val cs = acc.checksum()
      cache += (s -> cs)
      cs
    }
}

//println(ChecksumAccumulator.calculate("test"))
//println(ChecksumAccumulator.calculate("singleton object test string"))