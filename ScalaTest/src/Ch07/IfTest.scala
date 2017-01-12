package Ch07

/**
  * Created by terzeron on 2016. 11. 21..
  */
object IfTest {
  def main(args: Array[String]): Unit = {
    val filename =
      if (!args.isEmpty) args(0)
      else "default.txt"
    println(filename)
  }
}
