/**
  * Created by terzeron on 2016. 11. 7..
  */
object FunctionalTest {
  def printArgs1(args: Array[String]): Unit = {
    var i = 0
    while (i < args.length) {
      print(args(i))
      i+=1
    }
  }

  def printArgs2(args: Array[String]): Unit = {
    for (arg <- args)
      print(arg)
  }

  def printArgs3(args: Array[String]): Unit = {
    args.foreach(print)
  }

  def main(args: Array[String]): Unit = {
    printArgs1(Array("1", "2", "3"))
    println("")
    printArgs2(Array("4", "5", "6"))
    println("")
    printArgs3(Array("7", "8", "9"))
    println("")
  }
}
