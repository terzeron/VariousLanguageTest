package Ch08

/**
  * Created by terzeron on 2016. 11. 28..
  */
object ClosureTest {
  def main(args: Array[String]): Unit = {
    var more = 1
    var addMore = (x: Int) => x + more
    var addOne = (x: Int) => x + 1
    println(addMore(10))
    more = 2
    println(addMore(10))
  }

}
