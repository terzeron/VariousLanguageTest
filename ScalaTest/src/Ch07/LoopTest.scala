package Ch07

/**
  * Created by terzeron on 2016. 11. 21..
  */
object LoopTest {
  def main(args: Array[String]): Unit = {
    def searchFrom(i: Int): Int =
      if (i >= args.length) -1
      else if (args(i).startsWith("-")) searchFrom(i + 1)
      else if (args(i).endsWith(".scala")) i
      else searchFrom(i + 1)

    val i = searchFrom(0)
    println(i)
  }
}
