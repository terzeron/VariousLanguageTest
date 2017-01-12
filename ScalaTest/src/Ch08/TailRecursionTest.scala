package Ch08

/**
  * Created by terzeron on 2016. 11. 28..
  */
object TailRecursionTest {
  def main(args: Array[String]): Unit = {
    def bang(x: Int): Unit = {
      if (x == 0) throw new Exception("bang")
      else bang(x-1)
    }
    print(bang(10))
  }
}
