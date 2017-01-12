package Ch08

/**
  * Created by terzeron on 2016. 11. 28..
  */
object VarArgsTest {
  def main(args: Array[String]): Unit = {
    def echo(args: String*): Unit = {
      for (arg <- args) println(arg)
    }
    echo("hello", "world")
  }
}
